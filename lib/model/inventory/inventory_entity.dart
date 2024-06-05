// To parse this JSON data, do
//
//     final inventoryEntity = inventoryEntityFromJson(jsonString);

import 'dart:convert';

InventoryEntity inventoryEntityFromJson(String str) =>
    InventoryEntity.fromJson(json.decode(str));

String inventoryEntityToJson(InventoryEntity data) =>
    json.encode(data.toJson());

class InventoryEntity {
  int id;
  String? name;
  List<LocationIds>? locationIdss;
  DateTime? accountingDate;
  String? state;
  Id? companyId;

  InventoryEntity({
    required this.id,
    required this.name,
    required this.locationIdss,
    required this.accountingDate,
    required this.state,
    required this.companyId,
  });

  factory InventoryEntity.fromJson(Map<String, dynamic> json) =>
      InventoryEntity(
        id: json["id"],
        name: json["name"],
        locationIdss: List<LocationIds>.from(
            json["location_ids"].map((x) => LocationIds.fromJson(x))),
        accountingDate: DateTime.parse(json["accounting_date"]),
        state: json["state"],
        companyId: Id.fromJson(json["company_id"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "location_ids":
            List<dynamic>.from(locationIdss!.map((x) => x.toJson())),
        "accounting_date":
            "${accountingDate!.year.toString().padLeft(4, '0')}-${accountingDate?.month.toString().padLeft(2, '0')}-${accountingDate?.day.toString().padLeft(2, '0')}",
        "state": state,
        "company_id": companyId!.toJson(),
      };
}

class Id {
  int id;
  String name;

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

class LocationIds {
  int id;
  String name;
  String displayName;

  LocationIds({
    required this.id,
    required this.name,
    required this.displayName,
  });

  factory LocationIds.fromJson(Map<String, dynamic> json) => LocationIds(
      id: json["id"], name: json["name"], displayName: json["display_name"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "display_name": displayName,
      };
}
