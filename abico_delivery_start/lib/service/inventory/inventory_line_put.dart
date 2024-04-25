import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:abico_delivery_start/constant/app_url.dart';
import 'package:abico_delivery_start/globals.dart';
import 'package:http/http.dart' as http;

class StockInventoryLinePutApiClient {
  Future<MessageResponseDto> getStockInventoryLinePutList(
    String ip,
    String id,
    String time,
  ) async {
    http.Response response;

    // Null check and parse id
    var formid = int.tryParse(id);
    if (formid == null) {
      throw FormatException('Invalid id: $id');
    }

    // Null check and parse time
    var too = double.tryParse(time);
    if (too == null) {
      throw FormatException('Invalid time: $time');
    }

    String url =
        '${AppUrl.baseUrl}/api/stock.inventory.line/$formid?product_qty=$too';
    print('end url irnee $url');

    try {
      response = await http.put(
        Uri.parse(url),
        headers: {
          'Access-token': Globals.getRegister(),
        },
      );
      print(response.body);
    } on SocketException {
      throw RequestTimeoutException(url);
    } on TimeoutException {
      throw RequestTimeoutException(url);
    }

    print('======================');
    print(id);
    print(time);
    print(response.statusCode);
    print(response.body);
    print('======================');

    if (response.statusCode == 200 || response.statusCode == 202) {
      return MessageResponseDto.fromRawJson(response.body);
    }
    throw BadResponseException('bad response');
  }
}

class StockMovePutApiClient {
  Future<MessageResponseDto> getStockMovePutList(
    String ip,
    String id,
    String time,
  ) async {
    http.Response response;

    var formId = int.parse(id);
    int too = int.parse(time);

    String url = '${AppUrl.baseUrl}/stock.move/$formId?check_qty=$too';
    print('end url irnee $url');
    try {
      response = await http.put(
        Uri.parse(url),
        headers: {
          'Access-token': Globals.getRegister(),
        },
      );
    } on SocketException {
      throw RequestTimeoutException(url);
    } on TimeoutException {
      throw RequestTimeoutException(url);
    }

    print('======================');
    print(id);
    print(time);
    print(response.body);
    print('======================');

    if (response.statusCode == 200 || response.statusCode == 202) {
      return MessageResponseDto.fromRawJson(response.body);
    }
    throw BadResponseException('bad response');
  }
}

class MessageResponseDto {
  MessageResponseDto({
    required this.id,
    required this.employeeId,
    required this.checkIn,
  });

  int id;
  int employeeId;
  DateTime checkIn;

  factory MessageResponseDto.fromRawJson(String str) =>
      MessageResponseDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MessageResponseDto.fromJson(Map<String, dynamic> json) =>
      MessageResponseDto(
        id: json["id"],
        employeeId: json["employee_id"],
        checkIn: json["check_in"] == null
            ? DateTime.now()
            : DateTime.parse(json["check_in"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "employee_id": employeeId,
        "check_in": checkIn.toIso8601String(),
      };
}

class BadResponseException implements Exception {
  BadResponseException(this.cause);

  String cause;

  @override
  String toString() => cause;
}

class RequestTimeoutException implements Exception {
  final String url;

  RequestTimeoutException(this.url);

  @override
  String toString() => 'Language.EXCEPTION_TIMEOUT_OR_SOCKET';
}
