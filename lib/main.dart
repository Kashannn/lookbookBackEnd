import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:lookbook/core/app_theme.dart';
import 'package:lookbook/routes/app_routes.dart';
import 'package:lookbook/views/Admin/admin_main_screen.dart';
import 'package:lookbook/views/Customer/customer_main_screen.dart';
import 'package:lookbook/views/Designer/designer_main_screen.dart';
import 'package:lookbook/views/welcomeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Look Book',
          theme: AppTheme.lightThemeMode,
          initialRoute: '/',
          getPages: AppRoutes.routes,
          home: WelcomeScreen(),
        );
      },
    );
  }
}
