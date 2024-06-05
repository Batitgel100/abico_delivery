// To parse this JSON data, do
//
//     final stockPickingLineEntity = stockPickingLineEntityFromJson(jsonString);

import 'dart:convert';
// To parse this JSON data, do
//
//     final stockPickingLineEntity = stockPickingLineEntityFromJson(jsonString);

StockPickingLineEntity stockPickingLineEntityFromJson(String str) =>
    StockPickingLineEntity.fromJson(json.decode(str));

String stockPickingLineEntityToJson(StockPickingLineEntity data) =>
    json.encode(data.toJson());

class StockPickingLineEntity {
  int id;
  ProductId? productId;
  String? descriptionPicking;
  DateTime? dateExpected;
  double? quantityDone;
  int? productUom;
  double? productUomQty;
  int? pickingId;
  double? checkQty;
  double? diffQty;
  String? barcode;
  String? productName;

  StockPickingLineEntity({
    required this.id,
    required this.productId,
    required this.descriptionPicking,
    required this.dateExpected,
    required this.quantityDone,
    required this.productUom,
    required this.productUomQty,
    required this.pickingId,
    required this.checkQty,
    required this.diffQty,
    required this.barcode,
    required this.productName,
  });

  factory StockPickingLineEntity.fromJson(Map<String, dynamic> json) =>
      StockPickingLineEntity(
        id: json["id"],
        productId: ProductId.fromJson(json["product_id"]),
        descriptionPicking: json["description_picking"],
        dateExpected: DateTime.parse(json["date_expected"]),
        quantityDone: json["quantity_done"],
        productUom: json["product_uom"],
        productUomQty: json["product_uom_qty"],
        pickingId: json["picking_id"],
        checkQty: json["check_qty"],
        diffQty: json["diff_qty"],
        barcode: json["barcode"],
        productName: json["product_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId!.toJson(),
        "description_picking": descriptionPicking,
        "date_expected": dateExpected!.toIso8601String(),
        "quantity_done": quantityDone,
        "product_uom": productUom,
        "product_uom_qty": productUomQty,
        "picking_id": pickingId,
        "check_qty": checkQty,
        "diff_qty": diffQty,
        "barcode": barcode,
        "product_name": productName,
      };
}

class ProductId {
  int id;
  String name;
  String barcode;

  ProductId({
    required this.id,
    required this.name,
    required this.barcode,
  });

  factory ProductId.fromJson(Map<String, dynamic> json) => ProductId(
        id: json["id"],
        name: json["name"],
        barcode: json["barcode"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "barcode": barcode,
      };
}
