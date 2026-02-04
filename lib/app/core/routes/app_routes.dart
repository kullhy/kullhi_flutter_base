import '../../modules/home/views/home_view.dart';

/// App Routes
/// Access route names via each View's static routeName
/// Example: HomeView.routeName returns '/home'
///
/// Usage:
///   - Get.toNamed(HomeView.routeName)
///   - HomeView.to()  // Navigation helper
///   - HomeView.off() // Replace current route
///   - HomeView.offAll() // Clear all and navigate
///
/// This file provides backward compatibility aliases
abstract class AppRoutes {
  // Backward compatibility aliases
  static String get home => HomeView.routeName;

  // Add more aliases as you create new views:
  // static String get login => LoginView.routeName;
  // static String get profile => ProfileView.routeName;
  // static String get settings => SettingsView.routeName;
}
