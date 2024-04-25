import 'package:abico_delivery_start/constant/app_url.dart';
import 'package:abico_delivery_start/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CompanyNameRepository {
  Future<void> getCompanyName() async {
    var headers = {'Access-token': Globals.getRegister().toString()};
    var request =
        http.Request('GET', Uri.parse('${AppUrl.baseUrl}/api/res.company'));
    request.bodyFields = {};
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseString = await response.stream.bytesToString();
      final Map<String, dynamic> jsonResponse = json.decode(responseString);
      final name = jsonResponse['results'][0]['name'];
      Globals.changeCompany(name);

      // print('Компаны нэр: $name');
    } else {
      print(
          'Failed to load todays attendance data. Respons: ${response.reasonPhrase}');
    }
  }
}
