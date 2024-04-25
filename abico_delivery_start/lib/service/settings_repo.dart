import 'dart:convert';

import 'package:abico_delivery_start/constant/app_url.dart';
import 'package:abico_delivery_start/globals.dart';
import 'package:abico_delivery_start/model/employe_data_entity.dart';
import 'package:http/http.dart' as http;

class EmployeDataApiClient {
  Future<EmployeeDataEntity?> getEmployeeData() async {
    var headers = {'Access-token': Globals.getRegister().toString()};
    var response = await http.get(
      Uri.parse(
          '${AppUrl.baseUrl}/api/res.users?filters=[["id","=",${Globals.getUserId()}]]'),
      headers: headers,
    );
    // print('user id: ${Globals.getUserId()}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      final int id = results[0]['id'];
      // final int companyId = results[0]['company_id'];
      Globals.changeEmployeeId(id);
      // Globals.changeCompanyId(companyId);
      // log('company id: ${Globals.companyId}');

      if (results.isNotEmpty) {
        return EmployeeDataEntity.fromJson(results[0]);
      } else {
        print('object');
        return null;
      }
    } else {
      throw Exception('Failed to load employee data');
    }
  }
}
