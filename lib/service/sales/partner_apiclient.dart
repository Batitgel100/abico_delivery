import 'dart:convert';

import 'package:abico_delivery_start/constant/app_url.dart';
import 'package:abico_delivery_start/globals.dart';
import 'package:abico_delivery_start/model/sales/partner/partner_entity.dart';
import 'package:http/http.dart' as http;

class PartnerApiClient {
  Future<List<PartnerEntity>> fetchPartner(
      {int offset = 0, int limit = 200}) async {
    final Map<String, String> headers = {
      'Access-token': Globals.getRegister().toString(),
    };

    final response = await http.get(
      Uri.parse(
          '${AppUrl.baseUrl}/api/res.partner?filters=[["name","!=",False],["active", "=", True]]&offset=$offset&limit=$limit'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final dynamic resultsData = jsonData['results'];

      if (resultsData is List) {
        return resultsData.map((json) => PartnerEntity.fromJson(json)).toList();
      } else {
        print('No results found in the response');
        return []; // Return an empty list if no results are found
      }
    } else {
      print('PartnerApiClient error. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load data');
    }
  }
}
