import 'package:abico_delivery_start/globals.dart';

class AppUrl {
  static var baseUrl = 'http://${Globals.getbaseUrl()}';

  static var loginEndPint =
      '$baseUrl/api/auth/get_tokens?username=admin&password=Tenger@2022';
}
