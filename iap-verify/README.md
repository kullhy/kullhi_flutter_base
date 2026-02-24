# iap-verify (Cloudflare Worker)

Worker backend verify subscription in-app purchase for **Android (Google Play)** and **iOS (App Store)**.

## 1) Setup

```bash
cd iap-verify
npm install
```

## 2) Configure secrets

> `GOOGLE_SERVICE_ACCOUNT_PRIVATE_KEY` must keep newline as `\n` when setting secret.

```bash
cd iap-verify
wrangler secret put APPLE_SHARED_SECRET
wrangler secret put GOOGLE_SERVICE_ACCOUNT_EMAIL
wrangler secret put GOOGLE_SERVICE_ACCOUNT_PRIVATE_KEY
wrangler secret put APP_SECRET_KEY
```

Set non-secret vars in `wrangler.toml` or by env:
- `GOOGLE_PLAY_PACKAGE_NAME`
- `APP_BUNDLE_ID`

## 3) Run local

```bash
cd iap-verify
cp .dev.vars.example .dev.vars
npm run dev
```

## 4) Deploy

```bash
cd iap-verify
npm run deploy
```

## 5) API contract

### `POST /verify`

Request body:

```json
{
  "platform": "android",
  "productId": "subscription_weekly",
  "purchaseToken": "xxxxx"
}
```

or

```json
{
  "platform": "ios",
  "productId": "subscription_weekly",
  "transactionReceipt": "base64_receipt"
}
```

Success response:

```json
{
  "platform": "android",
  "isActive": true,
  "productId": "subscription_weekly",
  "expiresAt": "2026-01-01T00:00:00.000Z",
  "raw": {}
}
```

Health check:
- `GET /health`

## Notes
- Android verification uses Google Play Developer API `subscriptionsv2`.
- iOS verification uses `verifyReceipt` endpoint and auto-retry sandbox when Apple returns `21007`.
- You should protect this API with auth (JWT/API key) before production.

- All `/verify` requests must include header `App-Secret-Key` that matches Worker secret `APP_SECRET_KEY`.
