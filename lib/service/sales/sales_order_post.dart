// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:abico_delivery_start/constant/app_url.dart';
import 'package:abico_delivery_start/globals.dart';
import 'package:abico_delivery_start/model/product_entity.dart';

import 'package:http/http.dart' as http;

class SalesOrderPostApiClient {
  Future post(
    int partnerId,
    int priceList,
    List<ProductEntity> list,
  ) async {
    var headers = {
      'Access-token': Globals.getRegister().toString(),
      'Content-Type': 'text/plain',
    };

    var request =
        http.Request('POST', Uri.parse('${AppUrl.baseUrl}/api/sale.order'));

    var requestBody = {
      "partner_id": partnerId,
      "date_order": DateTime.now().toString(),
      "pricelist_id": priceList,
      "state": "draft",
      "user_id": Globals.getUserId(),
      "picking_policy": "direct",
      "order_line": list
    };

    request.body = json.encode(requestBody);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print('Амжилттай');
    } else {
      String responseBody = await response.stream.bytesToString();

      Map<String, dynamic> errorJson = jsonDecode(responseBody);
      String errorDescription = errorJson['error_descrip'];

      errorDescription =
          errorDescription.replaceAll('UserError(', '').replaceAll(", )", '');

      print('Error Description: $errorDescription');

      print('Алдаа заалаа $errorDescription');
    }
  }
}
