import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:ipfeedback/routes/app_pages.dart';
import 'package:ipfeedback/routes/app_routes.dart';
import 'package:ipfeedback/screens/not_found_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'IP Feedback',

      // Debugger Icon
      debugShowCheckedModeBanner: false,

      // App Theme
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        scaffoldBackgroundColor: Colors.white,
      ),

      // Router
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,

      unknownRoute: GetPage(
        name: AppRoutes.notFound,
        page: () => const NotFoundScreen(),
      ),
    );
  }
}
