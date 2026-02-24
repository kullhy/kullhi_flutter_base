import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

class SubscriptionController extends GetxController {
  final InAppPurchase _iap = InAppPurchase.instance;

  /// ===== PRODUCT IDS =====
  static const String weeklyId = 'subscription_weekly';
  static const String yearlyId = 'subscription_yearly';

  final Set<String> _productIds = {weeklyId, yearlyId};

  /// ===== STATE =====
  RxBool isAvailable = false.obs;
  RxBool isLoading = true.obs;
  RxBool purchasePending = false.obs;
  RxList<ProductDetails> products = <ProductDetails>[].obs;

  /// Những gói user đang active.
  RxList<PurchaseDetails> activePurchases = <PurchaseDetails>[].obs;

  /// Giữ tương thích với các widget hiện tại.
  RxBool isPremium = false.obs;

  StreamSubscription<List<PurchaseDetails>>? _subscription;

  @override
  void onInit() {
    super.onInit();

    // Lắng nghe stream ngay lập tức để không miss event.
    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onError: (_) {
        purchasePending.value = false;
      },
      onDone: () => _subscription?.cancel(),
    );

    _initialize();
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

    // Restore ngầm để Android upgrade/downgrade có old purchase.
    await _restoreActiveSubscriptionsInBackground();
  }

  Future<void> _loadProducts() async {
    final response = await _iap.queryProductDetails(_productIds);
    if (response.error == null) {
      products.assignAll(response.productDetails);
    }
    isLoading.value = false;
  }

  Future<void> _restoreActiveSubscriptionsInBackground() async {
    await _iap.restorePurchases();
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

  Future<void> _onPurchaseUpdate(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    for (final purchase in purchaseDetailsList) {
      if (purchase.status == PurchaseStatus.pending) {
        purchasePending.value = true;
      } else {
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
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchase) async {
    return true;
  }

  Future<void> _deliverSubscription(PurchaseDetails purchase) async {
    if (!activePurchases.any((p) => p.productID == purchase.productID)) {
      activePurchases.add(purchase);
    }

    isPremium.value = activePurchases.isNotEmpty;
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
