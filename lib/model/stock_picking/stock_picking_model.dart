// To parse this JSON data, do
//
//     final stockPickingEntity = stockPickingEntityFromJson(jsonString);

import 'dart:convert';

StockPickingEntity stockPickingEntityFromJson(String str) =>
    StockPickingEntity.fromJson(json.decode(str));

String stockPickingEntityToJson(StockPickingEntity data) =>
    json.encode(data.toJson());

class StockPickingEntity {
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

  StockPickingEntity({
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
  factory StockPickingEntity.fromJson(Map<String, dynamic> json) {
    List<LocationId> locationIds = [];
    if (json.containsKey("location_ids") && json["location_ids"] != null) {
      // Parse each location_id into LocationId objects
      locationIds = (json["location_ids"] as List)
          .map((locationJson) => LocationId.fromJson(locationJson))
          .toList();
    }

    return StockPickingEntity(
      id: json["id"],
      name: json["name"],
      partnerId: json["partner_id"],
      pickingTypeId: json["picking_type_id"],
      locationId: locationIds.isNotEmpty ? locationIds[0] : null,
      scheduledDate: json["scheduled_date"] != null
          ? DateTime.parse(json["scheduled_date"])
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

  get displayName => null;

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
