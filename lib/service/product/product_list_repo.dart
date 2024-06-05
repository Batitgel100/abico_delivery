// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:abico_delivery_start/constant/app_url.dart';
import 'package:abico_delivery_start/globals.dart';
import 'package:abico_delivery_start/model/product_entity.dart';
import 'package:http/http.dart' as http;

class ProductListApiClient {
  int _currentPage = 1;
  final int _itemsPerPage =
      200; // Change this according to your API's pagination settings
  final bool _isLoading = false;

  Future<List<ProductEntity>> fetchData() async {
    if (_isLoading) return []; // Prevent multiple simultaneous requests

    try {
      final Map<String, String> headers = {
        'Access-token': Globals.getRegister().toString(),
      };

      final response = await http.get(
        Uri.parse(
            '${AppUrl.baseUrl}/api/product.product?page=$_currentPage&limit=$_itemsPerPage'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> resultsData = jsonData['results'];
        _currentPage++; // Increment page for next request
        return resultsData.map((json) => ProductEntity.fromJson(json)).toList();
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
      throw Exception('Error fetching data: $error');
    }
  }
}

class Product {
  int id;
  ProductId? productId; // Make ProductId nullable

  Product({
    required this.id,
    this.productId,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        productId: json.containsKey("product_id")
            ? ProductId.fromJson(json["product_id"])
            : null,
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId?.toJson(),
      };
}

class ProductId {
  int id;
  String displayName;

  ProductId({
    required this.id,
    required this.displayName,
  });

  factory ProductId.fromJson(Map<String, dynamic> json) => ProductId(
        id: json["id"],
        displayName: json["display_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "display_name": displayName,
      };
}
