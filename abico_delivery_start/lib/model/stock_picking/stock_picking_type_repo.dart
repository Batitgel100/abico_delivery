import 'dart:convert';

import 'package:abico_delivery_start/globals.dart';
import 'package:http/http.dart' as http;

class StockPickingTypeApi {
  Future<Map<String, dynamic>?> fetchData(int typeId) async {
    var headers = {'Access-token': Globals.getRegister()};
    var uri = Uri.parse(
        'http://203.91.116.148/api/stock.picking.type?filters=[["company_id","=",${Globals.getCompanyId()}],["id","=",$typeId]]');

    try {
      var response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Request failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception occurred: $e');
      return null;
    }
  }
}
