// To parse this JSON data, do
//
//     final saleOrderLineEntity = saleOrderLineEntityFromJson(jsonString);

import 'dart:convert';

SaleOrderLineEntity saleOrderLineEntityFromJson(String str) =>
    SaleOrderLineEntity.fromJson(json.decode(str));

String saleOrderLineEntityToJson(SaleOrderLineEntity data) =>
    json.encode(data.toJson());

class SaleOrderLineEntity {
  int id;
  int productId;
  String name;
  double productUomQty;
  int productUom;
  double priceUnit;
  double priceSubtotal;
  int companyId;
  dynamic discount;
  int orderId;

  SaleOrderLineEntity({
    required this.id,
    required this.productId,
    required this.name,
    required this.productUomQty,
    required this.productUom,
    required this.priceUnit,
    required this.priceSubtotal,
    required this.companyId,
    required this.discount,
    required this.orderId,
  });

  factory SaleOrderLineEntity.fromJson(Map<String, dynamic> json) =>
      SaleOrderLineEntity(
        id: json["id"],
        productId: json["product_id"],
        name: json["name"],
        productUomQty: json["product_uom_qty"],
        productUom: json["product_uom"],
        priceUnit: json["price_unit"]?.toDouble(),
        priceSubtotal: json["price_subtotal"]?.toDouble(),
        companyId: json["company_id"],
        discount: json["discount"],
        orderId: json["order_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "name": name,
        "product_uom_qty": productUomQty,
        "product_uom": productUom,
        "price_unit": priceUnit,
        "price_subtotal": priceSubtotal,
        "company_id": companyId,
        "discount": discount,
        "order_id": orderId,
      };
}
