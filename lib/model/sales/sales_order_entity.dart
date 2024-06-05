// To parse this JSON data, do
//
//     final salesOrderEntity = salesOrderEntityFromJson(jsonString);

import 'dart:convert';

SalesOrderEntity salesOrderEntityFromJson(String str) =>
    SalesOrderEntity.fromJson(json.decode(str));

String salesOrderEntityToJson(SalesOrderEntity data) =>
    json.encode(data.toJson());

class SalesOrderEntity {
  int id;
  String name;
  int? partnerId;
  DateTime? dateOrder;
  int? pricelistId;
  int userId;
  String? state;
  double? amountUntaxed;
  double? amountTax;
  double? amountTotal;

  SalesOrderEntity({
    required this.id,
    required this.name,
    required this.partnerId,
    required this.dateOrder,
    required this.pricelistId,
    required this.userId,
    required this.state,
    required this.amountUntaxed,
    required this.amountTax,
    required this.amountTotal,
  });

  factory SalesOrderEntity.fromJson(Map<String, dynamic> json) =>
      SalesOrderEntity(
        id: json["id"],
        name: json["name"],
        partnerId: json["partner_id"],
        dateOrder: DateTime.parse(json["date_order"]),
        pricelistId: json["pricelist_id"],
        userId: json["user_id"],
        state: json["state"],
        amountUntaxed: json["amount_untaxed"],
        amountTax: json["amount_tax"],
        amountTotal: json["amount_total"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "partner_id": partnerId,
        "date_order": dateOrder!.toIso8601String(),
        "pricelist_id": pricelistId,
        "user_id": userId,
        "state": state,
        "amount_untaxed": amountUntaxed,
        "amount_tax": amountTax,
        "amount_total": amountTotal,
      };
}
