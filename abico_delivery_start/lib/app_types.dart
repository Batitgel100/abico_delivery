import 'package:abico_delivery_start/ui/screen/login_screen.dart';
import 'package:abico_delivery_start/ui/screen/main_screen.dart';
import 'package:abico_delivery_start/ui/screen/settings%20screen/settings_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen());
      case RoutesName.main:
        return MaterialPageRoute(
            builder: (BuildContext context) => const MainScreen());
      case RoutesName.item:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SettingsScreen());

      // case RoutesName.item:
      //   return MaterialPageRoute(
      //       builder: (BuildContext context) => const CountItemScreen());

      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('No route defined'),
            ),
          );
        });
    }
  }
}

class RoutesName {
  static const String attendanceRegister = 'attendanceRegister';
  static const String attendanceScreen = 'attendanceScreen';
  static const String countScreen = 'countScreen';
  static const String countItemScreen = 'countItemScreen';

  static const String login = 'login';
  static const String item = 'item';
  static const String productScreen = 'product_screen';

  //home screen routes name
  static const String main = 'main_screen';
}
