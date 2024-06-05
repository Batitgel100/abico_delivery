import 'dart:convert';

import 'package:abico_delivery_start/constant/app_url.dart';
import 'package:abico_delivery_start/globals.dart';
import 'package:abico_delivery_start/model/sales/sales_order_entity.dart';
import 'package:abico_delivery_start/model/stock_picking/stock_picking_model.dart';
import 'package:http/http.dart' as http;

class SalesOrderApiClient {
  Future<List<SalesOrderEntity>> fetchsales() async {
    final Map<String, String> headers = {
      'Access-token': Globals.getRegister().toString(),
    };
    final response = await http.get(
      Uri.parse(
          '${AppUrl.baseUrl}/api/sale.order?filters=[["state", "=", "sale"],["company_id","=",${Globals.getCompanyId()}],["cr_user_id","=",${Globals.getUserId()}]]'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final dynamic resultsData = jsonData['results'];

      if (resultsData is List) {
        return resultsData
            .map((json) => SalesOrderEntity.fromJson(json))
            .toList();
      } else {
        print('No results found in the response');
        return []; // Return an empty list if no results are found
      }
    } else {
      print('StockPickingApiClient error. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load data');
    }
  }
}
