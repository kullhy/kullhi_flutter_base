
import 'package:in_app_review/in_app_review.dart';

class ReviewService {
  static final InAppReview _inAppReview = InAppReview.instance;

  static Future<void> requestReview() async {
    if (await _inAppReview.isAvailable()) {
      // Chỉ trigger khi user đã hài lòng (logic do bạn định nghĩa)
      _inAppReview.requestReview();
    }
  }
}
