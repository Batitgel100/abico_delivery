// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:abico_delivery_start/constant/app_url.dart';
import 'package:abico_delivery_start/globals.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../utils/utils.dart';

class CreateInventoryLineApiClient {
  Future create(int productId, int locationId, int inventoryId, double qty,
      String productName, String barcode, BuildContext context) async {
    var headers = {
      'Access-token': Globals.getRegister().toString(),
      'Content-Type': 'text/plain',
    };

    var request = http.Request(
        'POST', Uri.parse('${AppUrl.baseUrl}/api/stock.inventory.line'));

    var requestBody = {
      "inventory_id": inventoryId,
      "company_id": Globals.getCompanyId(),
      "product_qty": qty,
      "product_id": productId,
      "location_id": locationId,
      "product_name": productName,
      "barcode": barcode
    };

    request.body = json.encode(requestBody);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Utils.flushBarSuccessMessage('Амжилттай нэмэгдлээ', context);
    } else {
      String responseBody = await response.stream.bytesToString();

      Map<String, dynamic> errorJson = jsonDecode(responseBody);
      String errorDescription = errorJson['error_descrip'];

      errorDescription =
          errorDescription.replaceAll('UserError(', '').replaceAll(", )", '');

      print('Error Description: $errorDescription');

      Utils.flushBarErrorMessage('Алдаа заалаа $errorDescription', context);
    }
  }
}
