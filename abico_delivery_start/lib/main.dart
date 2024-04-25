import 'package:abico_delivery_start/app_types.dart';
import 'package:flutter/material.dart';
import 'package:abico_delivery_start/constant/constant.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.mainColor,
          // ···
          // brightness: Brightness.,
        ),
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Routes.generateRoute,
      initialRoute: RoutesName.login,
      // home: const LoginScreen(),
    );
  }
}
