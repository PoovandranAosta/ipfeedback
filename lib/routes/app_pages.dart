import 'package:get/get.dart';
import 'package:ipfeedback/screens/dashboard_screen.dart';
import '../screens/feedback_screen.dart';
import '../screens/not_found_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/thankyou_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.splash, page: () => SplashScreen()),
    GetPage(name: AppRoutes.form, page: () => const Feedback()),
    GetPage(name: AppRoutes.thanks, page: () => const ThankyouScreen()),
    GetPage(name: AppRoutes.notFound, page: () => const NotFoundScreen()),
    GetPage(name: AppRoutes.dashboard, page: ()=> const DashboardScreen())
  ];
}
