// To parse this JSON data, do
//
//     final productEntity = productEntityFromJson(jsonString);

import 'dart:convert';

ProductEntity productEntityFromJson(String str) =>
    ProductEntity.fromJson(json.decode(str));

String productEntityToJson(ProductEntity data) => json.encode(data.toJson());

class ProductEntity {
  int id;
  String? name;
  String? barcode;
  int? categId;
  String? defaultCode;
  double? listPrice;
  int? uomId;
  dynamic image128;
  double? weight;
  double? volume;
  double? qtyAvailable;

  ProductEntity({
    required this.id,
    required this.name,
    required this.barcode,
    required this.categId,
    required this.defaultCode,
    required this.listPrice,
    required this.uomId,
    required this.image128,
    required this.weight,
    required this.volume,
    required this.qtyAvailable,
  });

  factory ProductEntity.fromJson(Map<String, dynamic> json) => ProductEntity(
        id: json["id"],
        name: json["name"],
        barcode: json["barcode"],
        categId: json["categ_id"],
        defaultCode: json["default_code"],
        listPrice: json["list_price"],
        uomId: json["uom_id"],
        image128: json["image_128"],
        weight: json["weight"],
        volume: json["volume"],
        qtyAvailable: json["qty_available"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "barcode": barcode,
        "categ_id": categId,
        "default_code": defaultCode,
        "list_price": listPrice,
        "uom_id": uomId,
        "image_128": image128,
        "weight": weight,
        "volume": volume,
        "qty_available": qtyAvailable,
      };
}
