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
  int? partnerId;
  int? pickingTypeId;
  LocationId? locationId;
  DateTime? scheduledDate;
  String? origin;
  dynamic checkUserId;
  String? isChecked;
  String? state;
  int? stockUserId;
  int? warperId;

  InventoryEntity({
    required this.id,
    required this.name,
    required this.partnerId,
    required this.pickingTypeId,
    required this.locationId,
    required this.scheduledDate,
    required this.origin,
    required this.checkUserId,
    required this.isChecked,
    required this.state,
    required this.stockUserId,
    required this.warperId,
  });

  factory InventoryEntity.fromJson(Map<String, dynamic> json) {
    List<LocationId> locationIds = [];
    if (json.containsKey("location_ids") && json["location_ids"] != null) {
      // Parse each location_id into LocationId objects
      locationIds = (json["location_ids"] as List)
          .map((locationJson) => LocationId.fromJson(locationJson))
          .toList();
    }

    return InventoryEntity(
      id: json["id"],
      name: json["name"],
      partnerId: json["partner_id"],
      pickingTypeId: json["picking_type_id"],
      locationId: locationIds.isNotEmpty ? locationIds[0] : null,
      scheduledDate: json["accounting_date"] != null
          ? DateTime.parse(json["accounting_date"])
          : null,
      origin: json["origin"],
      checkUserId: json["check_user_id"],
      isChecked: json["is_checked"],
      state: json["state"],
      stockUserId: json["stock_user_id"],
      warperId: json["warper_id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "partner_id": partnerId,
        "picking_type_id": pickingTypeId,
        "location_id": locationId!.toJson(),
        "scheduled_date": scheduledDate!.toIso8601String(),
        "origin": origin,
        "check_user_id": checkUserId,
        "is_checked": isChecked,
        "state": state,
        "stock_user_id": stockUserId,
        "warper_id": warperId,
      };
}

class LocationId {
  int id;
  String name;

  LocationId({
    required this.id,
    required this.name,
  });

  factory LocationId.fromJson(Map<String, dynamic> json) => LocationId(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
