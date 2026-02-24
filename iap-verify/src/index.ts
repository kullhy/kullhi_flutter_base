export interface Env {
  APPLE_SHARED_SECRET: string;
  GOOGLE_SERVICE_ACCOUNT_EMAIL: string;
  GOOGLE_SERVICE_ACCOUNT_PRIVATE_KEY: string;
  GOOGLE_PLAY_PACKAGE_NAME: string;
  APP_BUNDLE_ID: string;
  APP_SECRET_KEY: string;
}

type VerifyPlatform = 'android' | 'ios';

interface VerifyRequest {
  platform: VerifyPlatform;
  productId: string;
  purchaseToken?: string;
  transactionReceipt?: string;
}

const GOOGLE_SCOPE = 'https://www.googleapis.com/auth/androidpublisher';

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    if (request.method === 'OPTIONS') {
      return withCors(new Response(null, { status: 204 }));
    }

    const url = new URL(request.url);

    if (url.pathname === '/health') {
      return withCors(json({ ok: true, service: 'iap-verify' }));
    }

    if (request.method !== 'POST' || url.pathname !== '/verify') {
      return withCors(json({ error: 'Not found' }, 404));
    }

    try {
      verifyAppSecret(request, env);
      const body = (await request.json()) as VerifyRequest;
      validateRequest(body);

      if (body.platform === 'android') {
        const result = await verifyAndroid(env, body.productId, body.purchaseToken!);
        return withCors(json(result));
      }

      const result = await verifyIos(env, body.productId, body.transactionReceipt!);
      return withCors(json(result));
    } catch (error) {
      return withCors(
        json(
          {
            error: error instanceof Error ? error.message : 'Unhandled error',
          },
          400,
        ),
      );
    }
  },
};


function verifyAppSecret(request: Request, env: Env): void {
  const headerSecret = request.headers.get('App-Secret-Key');
  if (!env.APP_SECRET_KEY || !headerSecret || headerSecret != env.APP_SECRET_KEY) {
    throw new Error('Unauthorized request');
  }
}

function validateRequest(body: VerifyRequest): void {
  if (!body.platform || !body.productId) {
    throw new Error('platform and productId are required');
  }

  if (body.platform === 'android' && !body.purchaseToken) {
    throw new Error('purchaseToken is required for android');
  }

  if (body.platform === 'ios' && !body.transactionReceipt) {
    throw new Error('transactionReceipt is required for ios');
  }
}

async function verifyAndroid(env: Env, productId: string, purchaseToken: string) {
  const accessToken = await createGoogleAccessToken(env);
  const endpoint =
    `https://androidpublisher.googleapis.com/androidpublisher/v3/applications/` +
    `${encodeURIComponent(env.GOOGLE_PLAY_PACKAGE_NAME)}/purchases/subscriptionsv2/tokens/` +
    `${encodeURIComponent(purchaseToken)}`;

  const resp = await fetch(endpoint, {
    headers: {
      Authorization: `Bearer ${accessToken}`,
      'Content-Type': 'application/json',
    },
  });

  if (!resp.ok) {
    const raw = await resp.text();
    throw new Error(`Google verify failed: ${resp.status} ${raw}`);
  }

  const data = (await resp.json()) as {
    subscriptionState?: string;
    lineItems?: Array<{ productId?: string; expiryTime?: string }>;
  };

  const matched = data.lineItems?.find((item) => item.productId === productId);
  const isActive = data.subscriptionState === 'SUBSCRIPTION_STATE_ACTIVE' && Boolean(matched);

  return {
    platform: 'android',
    isActive,
    productId,
    expiresAt: matched?.expiryTime ?? null,
    raw: data,
  };
}

async function verifyIos(env: Env, productId: string, transactionReceipt: string) {
  const payload = {
    'receipt-data': transactionReceipt,
    password: env.APPLE_SHARED_SECRET,
    'exclude-old-transactions': true,
  };

  let result = await callAppleVerifyReceipt(payload, false);

  // 21007: sandbox receipt sent to production.
  if (result.status === 21007) {
    result = await callAppleVerifyReceipt(payload, true);
  }

  if (result.status !== 0) {
    throw new Error(`Apple verify failed with status ${result.status}`);
  }

  const latest = [...(result.latest_receipt_info ?? [])]
    .sort((a, b) => Number(b.expires_date_ms ?? 0) - Number(a.expires_date_ms ?? 0))
    .find((item) => item.product_id === productId);

  const expiresAtMs = Number(latest?.expires_date_ms ?? 0);

  return {
    platform: 'ios',
    isActive: expiresAtMs > Date.now(),
    productId,
    expiresAt: expiresAtMs ? new Date(expiresAtMs).toISOString() : null,
    raw: result,
  };
}

async function callAppleVerifyReceipt(
  payload: Record<string, unknown>,
  sandbox: boolean,
): Promise<AppleVerifyReceiptResponse> {
  const endpoint = sandbox
    ? 'https://sandbox.itunes.apple.com/verifyReceipt'
    : 'https://buy.itunes.apple.com/verifyReceipt';

  const resp = await fetch(endpoint, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  });

  if (!resp.ok) {
    throw new Error(`Apple endpoint error: ${resp.status}`);
  }

  return (await resp.json()) as AppleVerifyReceiptResponse;
}

async function createGoogleAccessToken(env: Env): Promise<string> {
  const now = Math.floor(Date.now() / 1000);
  const jwtHeader = { alg: 'RS256', typ: 'JWT' };
  const jwtClaim = {
    iss: env.GOOGLE_SERVICE_ACCOUNT_EMAIL,
    scope: GOOGLE_SCOPE,
    aud: 'https://oauth2.googleapis.com/token',
    exp: now + 3600,
    iat: now,
  };

  const unsignedJwt = `${base64UrlEncode(JSON.stringify(jwtHeader))}.${base64UrlEncode(
    JSON.stringify(jwtClaim),
  )}`;

  const signature = await signJwt(unsignedJwt, env.GOOGLE_SERVICE_ACCOUNT_PRIVATE_KEY);
  const assertion = `${unsignedJwt}.${signature}`;

  const tokenResp = await fetch('https://oauth2.googleapis.com/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
      assertion,
    }),
  });

  if (!tokenResp.ok) {
    const raw = await tokenResp.text();
    throw new Error(`Google OAuth failed: ${tokenResp.status} ${raw}`);
  }

  const tokenData = (await tokenResp.json()) as { access_token: string };
  return tokenData.access_token;
}

async function signJwt(unsignedJwt: string, privateKeyPem: string): Promise<string> {
  const cleanPem = privateKeyPem.replace(/\\n/g, '\n');
  const binaryDer = pemToArrayBuffer(cleanPem);

  const cryptoKey = await crypto.subtle.importKey(
    'pkcs8',
    binaryDer,
    {
      name: 'RSASSA-PKCS1-v1_5',
      hash: 'SHA-256',
    },
    false,
    ['sign'],
  );

  const signature = await crypto.subtle.sign(
    'RSASSA-PKCS1-v1_5',
    cryptoKey,
    new TextEncoder().encode(unsignedJwt),
  );

  return base64UrlEncodeBytes(new Uint8Array(signature));
}

function pemToArrayBuffer(pem: string): ArrayBuffer {
  const b64 = pem
    .replace('-----BEGIN PRIVATE KEY-----', '')
    .replace('-----END PRIVATE KEY-----', '')
    .replace(/\s+/g, '');
  const binary = atob(b64);
  const bytes = new Uint8Array(binary.length);
  for (let i = 0; i < binary.length; i += 1) {
    bytes[i] = binary.charCodeAt(i);
  }
  return bytes.buffer;
}

function base64UrlEncode(input: string): string {
  return base64UrlEncodeBytes(new TextEncoder().encode(input));
}

function base64UrlEncodeBytes(bytes: Uint8Array): string {
  let binary = '';
  bytes.forEach((byte) => {
    binary += String.fromCharCode(byte);
  });
  return btoa(binary).replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/g, '');
}

function json(data: unknown, status = 200): Response {
  return new Response(JSON.stringify(data), {
    status,
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
    },
  });
}

function withCors(response: Response): Response {
  const headers = new Headers(response.headers);
  headers.set('Access-Control-Allow-Origin', '*');
  headers.set('Access-Control-Allow-Methods', 'GET,POST,OPTIONS');
  headers.set('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  return new Response(response.body, {
    status: response.status,
    statusText: response.statusText,
    headers,
  });
}

interface AppleVerifyReceiptResponse {
  status: number;
  latest_receipt_info?: Array<{
    product_id?: string;
    expires_date_ms?: string;
  }>;
}
