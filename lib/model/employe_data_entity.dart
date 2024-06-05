import 'dart:convert';

EmployeeDataEntity employeeDataEntityFromJson(String str) =>
    EmployeeDataEntity.fromJson(json.decode(str));

String employeeDataEntityToJson(EmployeeDataEntity data) =>
    json.encode(data.toJson());

class EmployeeDataEntity {
  int id;
  String? name;
  int? userId;
  String? jobTitle;
  String? mobilePhone;
  String? workEmail;
  int? companyId;
  dynamic image1920;
  String? workLocation;

  EmployeeDataEntity({
    required this.id,
    required this.name,
    required this.userId,
    required this.jobTitle,
    required this.mobilePhone,
    required this.workEmail,
    required this.companyId,
    required this.image1920,
    required this.workLocation,
  });

  factory EmployeeDataEntity.fromJson(Map<String, dynamic> json) =>
      EmployeeDataEntity(
        id: json["id"],
        name: json["name"],
        userId: json["user_id"],
        jobTitle: json["job_title"],
        mobilePhone: json["mobile_phone"],
        workEmail: json["work_email"],
        companyId: json["company_id"],
        image1920: json["image_1920"],
        workLocation: json["work_location"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "user_id": userId,
        "job_title": jobTitle,
        "mobile_phone": mobilePhone,
        "work_email": workEmail,
        "company_id": companyId,
        "image_1920": image1920,
        "work_location": workLocation,
      };
}
