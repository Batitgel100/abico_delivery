// To parse this JSON data, do
//
//     final stockPickingLineEntity = stockPickingLineEntityFromJson(jsonString);
import 'dart:convert';

StockPickingLineEntity stockPickingLineEntityFromJson(String str) =>
    StockPickingLineEntity.fromJson(json.decode(str));

String stockPickingLineEntityToJson(StockPickingLineEntity data) =>
    json.encode(data.toJson());

class StockPickingLineEntity {
  int id;
  int? moveId;
  ProductId? productId;
  Id? locationId;
  Id? locationDestId;
  dynamic lotId;
  double? qtyDone;
  int? productUomId;
  Id? pickingId;
  String? productName;

  StockPickingLineEntity({
    required this.id,
    required this.moveId,
    required this.productId,
    required this.locationId,
    required this.locationDestId,
    required this.lotId,
    required this.qtyDone,
    required this.productUomId,
    required this.pickingId,
    required this.productName,
  });

  factory StockPickingLineEntity.fromJson(Map<String, dynamic> json) =>
      StockPickingLineEntity(
        id: json["id"],
        moveId: json["move_id"],
        productId: ProductId.fromJson(json["product_id"]),
        locationId: Id.fromJson(json["location_id"]),
        locationDestId: Id.fromJson(json["location_dest_id"]),
        lotId: json["lot_id"],
        qtyDone: json["qty_done"] ?? 0.0, // Provide a default value if null
        productUomId:
            json["product_uom_id"] ?? 0, // Provide a default value if null
        pickingId: Id.fromJson(json["picking_id"]),
        productName: json["product_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "move_id": moveId,
        "product_id": productId?.toJson(),
        "location_id": locationId?.toJson(),
        "location_dest_id": locationDestId?.toJson(),
        "lot_id": lotId,
        "qty_done": qtyDone,
        "product_uom_id": productUomId,
        "picking_id": pickingId?.toJson(),
        "product_name": productName,
      };
}

class Id {
  int? id;
  String? name;

  Id({
    required this.id,
    required this.name,
  });

  factory Id.fromJson(Map<String, dynamic> json) => Id(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class ProductId {
  int? id;
  String? displayName;
  String? barcode;

  ProductId({
    required this.id,
    required this.displayName,
    required this.barcode,
  });

  factory ProductId.fromJson(Map<String, dynamic> json) => ProductId(
        id: json["id"],
        displayName: json["display_name"],
        barcode: json["barcode"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "display_name": displayName,
        "barcode": barcode,
      };
}
