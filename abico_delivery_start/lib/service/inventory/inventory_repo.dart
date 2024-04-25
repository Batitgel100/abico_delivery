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
          '${AppUrl.baseUrl}/api/stock.inventory?filters=[["state", "=", "confirm"],["company_id","=",${Globals.getCompanyId()}]]'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);

      // Check if 'results' key exists and is not null
      if (jsonData.containsKey('results') && jsonData['results'] != null) {
        final List<dynamic> resultsData = jsonData['results'];

        // Parse each result into InventoryEntity objects
        return resultsData
            .map((json) => InventoryEntity.fromJson(json))
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
