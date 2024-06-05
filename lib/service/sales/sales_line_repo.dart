import 'dart:convert';

import 'package:abico_delivery_start/constant/app_url.dart';
import 'package:abico_delivery_start/globals.dart';
import 'package:abico_delivery_start/model/sales/sales_order_line_entity.dart';
import 'package:http/http.dart' as http;

class SalesOrderLineApiClient {
  Future<List<SaleOrderLineEntity>> fetchsales(int id) async {
    final Map<String, String> headers = {
      'Access-token': Globals.getRegister().toString(),
    };
    final response = await http.get(
      Uri.parse(
          '${AppUrl.baseUrl}/api/sale.order.line?filters=[["order_id", "=",$id]]'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<SaleOrderLineEntity> tempList = [];

      if (data['results'] is Map<String, dynamic>) {
        if (data['results'].isEmpty) {
          return tempList; // Return an empty list if there are no results
        }

        if (data['results'] is Iterable) {
          for (var entry in data['results']) {
            tempList.add(SaleOrderLineEntity.fromJson(entry));
          }
        } else {
          throw Exception('Invalid data format: results is not an Iterable');
        }
      } else if (data['results'] is Iterable) {
        for (var entry in data['results']) {
          tempList.add(SaleOrderLineEntity.fromJson(entry));
        }
      } else {
        throw Exception(
            'Invalid data format: results is not a Map<String, dynamic> or an Iterable');
      }

      return tempList;
    } else {
      throw Exception('Failed to load attendance data');
    }
  }
}
