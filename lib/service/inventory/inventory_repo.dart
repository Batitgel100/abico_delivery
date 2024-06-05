import 'dart:convert';

import 'package:abico_delivery_start/constant/app_url.dart';
import 'package:abico_delivery_start/globals.dart';
import 'package:abico_delivery_start/model/inventory/inventory_entity.dart';
import 'package:http/http.dart' as http;

class InventoryApiClient {
  Future<List<InventoryEntity>> fetchStockPicking() async {
    final Map<String, String> headers = {
      'Access-token': Globals.getRegister().toString(),
    };

    final response = await http.get(
      Uri.parse(
          '${AppUrl.baseUrl}/api/stock.inventory?filters=[["state", "=", "confirm"],["company_id","=",${Globals.companyId}]]'),
      headers: headers,
    );


    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);

      if (jsonData.containsKey('results')) {
        dynamic results = jsonData['results'];

        if (results is Map<String, dynamic>) {
          // Wrap the single result in a list
          results = [results];
        }

        if (results is List<dynamic>) {
          // Parse each result into InventoryEntity objects
          return results.map((json) => InventoryEntity.fromJson(json)).toList();
        } else {
          print('Invalid or missing results in the response');
          return [];
        }
      } else {
        print('No results found in the response');
        return [];
      }
    } else {
      print('StockPickingApiClient error. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load data');
    }
  }
}
