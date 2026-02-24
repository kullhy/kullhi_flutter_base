
import 'package:share_plus/share_plus.dart';

class AppShareService {
  static Future<void> shareContent(String text, {String? subject}) async {
    await Share.share(text, subject: subject);
  }

  static Future<void> shareFile(String path, String text) async {
    await Share.shareXFiles([XFile(path)], text: text);
  }
}
