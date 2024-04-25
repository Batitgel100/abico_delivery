// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:abico_delivery_start/constant/app_url.dart';
import 'package:abico_delivery_start/globals.dart';
import 'package:abico_delivery_start/model/product_entity.dart';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ProductListApiClient {
  Future<List<ProductEntity>> fetchData({int page = 1}) async {
    try {
      final Map<String, String> headers = {
        'Access-token': Globals.getRegister().toString(),
      };
      final response = await http.get(
        Uri.parse('${AppUrl.baseUrl}/api/product.product?page=$page'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> resultsData = jsonData['results'];
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

class ProductListApiClientWithFilter {
  Future<List<Product>> fetchData(
      List<Map<String, int>> locationIds, BuildContext context) async {
    // Check if locationIds is not empty
    if (locationIds.isEmpty) {
      print('Location IDs are empty');
      return []; // or throw an error, depending on your use case
    }

    final List<int> idList = locationIds.map((map) => map['id'] ?? 0).toList();

    final Map<String, String> headers = {
      'Access-token': Globals.getRegister().toString(),
    };

    final response = await http.get(
      Uri.parse(
          '${AppUrl.baseUrl}/api/stock.quant?filters=[["location_id","in",$idList]]'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);

      print('Response data: $jsonData');

      if (jsonData.containsKey('results')) {
        dynamic resultsData = jsonData['results'];

        if (resultsData is List) {
          return resultsData.map((json) => Product.fromJson(json)).toList();
        } else if (resultsData is Map) {}
      }

      print('Unexpected data format for "results".');
      throw Exception('Failed to load data');
    } else {
      print('Failed to load data. Status code: ${response.request}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load data');
    }

    // ... rest of your code
  }
}

class ProdListApiClientWithSingleFilter {
  Future<List<Product>> fetchData(int locationIds, BuildContext context) async {
    // Check if locationIds is not empty

    final Map<String, String> headers = {
      'Access-token': Globals.getRegister().toString(),
    };

    final response = await http.get(
      Uri.parse(
          'http://ivco.mn/api/stock.quant?filters=[["location_id","=",$locationIds]]'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);

      print('Response data: $jsonData');

      if (jsonData.containsKey('results')) {
        dynamic resultsData = jsonData['results'];

        if (resultsData is List) {
          return resultsData.map((json) => Product.fromJson(json)).toList();
        } else if (resultsData is Map) {}
      }

      print('Unexpected data format for "results".');
      throw Exception('Failed to load data');
    } else {
      print('Failed to load data. Status code: ${response.request}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load data');
    }

    // ... rest of your code
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
