import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

import '../../../core/network/dio_client.dart';
import '../../../core/services/storage_service.dart';

class IapService extends GetxService {
  final InAppPurchase _iap = InAppPurchase.instance;
  final DioClient _dioClient = Get.find<DioClient>();
  final StorageService _storageService = Get.find<StorageService>();

  late final String weeklyId;
  late final String yearlyId;

  Set<String> get _productIds => {weeklyId, yearlyId};

  RxBool isAvailable = false.obs;
  RxBool isLoading = true.obs;
  RxBool purchasePending = false.obs;
  RxList<ProductDetails> products = <ProductDetails>[].obs;
  RxList<PurchaseDetails> activePurchases = <PurchaseDetails>[].obs;
  RxBool isPremium = false.obs;

  StreamSubscription<List<PurchaseDetails>>? _subscription;

  Future<IapService> init() async {
    weeklyId = dotenv.env['IAP_WEEKLY_ID'] ?? 'subscription_weekly';
    yearlyId = dotenv.env['IAP_YEARLY_ID'] ?? 'subscription_yearly';
    isPremium.value = _storageService.isPremium;

    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onError: (_) {
        purchasePending.value = false;
      },
      onDone: () => _subscription?.cancel(),
    );

    await _initialize();
    return this;
  }

  Future<void> _initialize() async {
    final available = await _iap.isAvailable();
    isAvailable.value = available;

    if (!available) {
      isLoading.value = false;
      return;
    }

    if (Platform.isIOS) {
      final iosAddition =
          _iap.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosAddition.setDelegate(null);
    }

    await _loadProducts();
    await _iap.restorePurchases();
  }

  Future<void> _loadProducts() async {
    final response = await _iap.queryProductDetails(_productIds);
    if (response.error == null) {
      products.assignAll(response.productDetails);
    }
    isLoading.value = false;
  }

  Future<void> buySubscription(ProductDetails product) async {
    purchasePending.value = true;
    late final PurchaseParam purchaseParam;

    if (Platform.isAndroid) {
      final oldSubscription = _getOldSubscription(product);
      purchaseParam = GooglePlayPurchaseParam(
        productDetails: product,
        changeSubscriptionParam: oldSubscription != null
            ? ChangeSubscriptionParam(
                oldPurchaseDetails: oldSubscription,
                replacementMode: ReplacementMode.withTimeProration,
              )
            : null,
      );
    } else {
      purchaseParam = PurchaseParam(productDetails: product);
    }

    try {
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (_) {
      purchasePending.value = false;
    }
  }

  Future<void> restorePurchases() async {
    purchasePending.value = true;
    try {
      await _iap.restorePurchases();
    } catch (_) {
      purchasePending.value = false;
      Get.snackbar('Lỗi', 'Không thể khôi phục giao dịch');
    }
  }

  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    for (final purchase in purchaseDetailsList) {
      if (purchase.status == PurchaseStatus.pending) {
        purchasePending.value = true;
        continue;
      }

      if (purchase.status == PurchaseStatus.error) {
        Get.snackbar('Lỗi', 'Giao dịch thất bại hoặc đã bị hủy.');
      } else if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        final valid = await _verifyPurchase(purchase);
        if (valid) {
          await _deliverSubscription(purchase);
        }
      }

      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }

      purchasePending.value = false;
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchase) async {
    try {
      final isAndroid = purchase is GooglePlayPurchaseDetails;
      final response = await _dioClient.post<Map<String, dynamic>>(
        '/verify',
        data: {
          'platform': isAndroid ? 'android' : 'ios',
          'productId': purchase.productID,
          if (isAndroid) 'purchaseToken': purchase.verificationData.serverVerificationData,
          if (!isAndroid) 'transactionReceipt': purchase.verificationData.serverVerificationData,
        },
        options: Options(
          baseUrl: dotenv.env['CLOUDFLARE_WORKER_URL'] ?? '',
        ),
      );
      return response.data?['isActive'] == true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _deliverSubscription(PurchaseDetails purchase) async {
    if (!activePurchases.any((p) => p.productID == purchase.productID)) {
      activePurchases.add(purchase);
    }

    isPremium.value = activePurchases.isNotEmpty;
    await _storageService.setPremium(isPremium.value);
  }

  GooglePlayPurchaseDetails? _getOldSubscription(ProductDetails newProduct) {
    for (final purchase in activePurchases) {
      if (purchase is GooglePlayPurchaseDetails) {
        if ((newProduct.id == weeklyId && purchase.productID == yearlyId) ||
            (newProduct.id == yearlyId && purchase.productID == weeklyId)) {
          return purchase;
        }
      }
    }
    return null;
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
