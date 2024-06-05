// To parse this JSON data, do
//
//     final inventoryLineEntity = inventoryLineEntityFromJson(jsonString);

import 'dart:convert';

InventoryLineEntity inventoryLineEntityFromJson(String str) =>
    InventoryLineEntity.fromJson(json.decode(str));

String inventoryLineEntityToJson(InventoryLineEntity data) =>
    json.encode(data.toJson());

class InventoryLineEntity {
  int id;
  int inventoryId;
  ProdId? productId;

  double? theoreticalQty;
  double? productQty;
  double? packQty;
  String? barcode;

  InventoryLineEntity({
    required this.id,
    required this.inventoryId,
    required this.productId,
    required this.theoreticalQty,
    required this.productQty,
    required this.packQty,
    required this.barcode,
  });

  factory InventoryLineEntity.fromJson(Map<String, dynamic> json) =>
      InventoryLineEntity(
        id: json["id"],
        inventoryId: json["inventory_id"],
        productId: json["product_id"] = ProdId.fromJson(json["product_id"]),
        theoreticalQty: json["theoretical_qty"],
        productQty: json["product_qty"],
        packQty: json["pack_qty"],
        barcode: json["barcode"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "inventory_id": inventoryId,
        "product_id": productId?.toJson(),
        "theoretical_qty": theoreticalQty,
        "product_qty": productQty,
        "pack_qty": packQty,
        "barcode": barcode,
      };
}

class ProdId {
  int? id;
  String? displayName;
  String? barcode;

  ProdId({
    this.id,
    this.displayName,
    this.barcode,
  });

  factory ProdId.fromJson(Map<String, dynamic> json) => ProdId(
        id: json["id"],
        barcode: json["barcode"],
        displayName: json["display_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "display_name": displayName,
        "barcode": barcode,
      };
}
