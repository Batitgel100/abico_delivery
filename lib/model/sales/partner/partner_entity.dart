// To parse this JSON data, do
//
//     final partnerEntity = partnerEntityFromJson(jsonString);

import 'dart:convert';

PartnerEntity partnerEntityFromJson(String str) =>
    PartnerEntity.fromJson(json.decode(str));

String partnerEntityToJson(PartnerEntity data) => json.encode(data.toJson());

class PartnerEntity {
  //   int id;
//   String? name;
//   String? vat;
//   int? companyId;
//   String? email;
//   String? phone;
//   String? street;
//   String? website;
//   int? userId;
//   int? propertyProductPricelist;
//   int? propertyPaymentTermId;
//   String? companyType;
//   List<int>? categoryId;
//   String? mobile;
//   String? function;
//   double? partnerCredit;
//   double? partnerDebit;
//   double? creditLimit;
//   int? parentId;
//   String? displayName;
  int id;
  String? name;
  String? vat;
  int? companyId;
  String? email;
  String? phone;
  String? street;
  String? website;
  int? userId;
  int? propertyProductPricelist;
  int? propertyPaymentTermId;
  double? credit;
  double? debit;
  double? creditLimit;
  int? partnerGroupId;
  int? parentId;
  String? displayName;

  PartnerEntity({
    required this.id,
    required this.name,
    required this.vat,
    required this.companyId,
    required this.email,
    required this.phone,
    required this.street,
    required this.website,
    required this.userId,
    required this.propertyProductPricelist,
    required this.propertyPaymentTermId,
    required this.credit,
    required this.debit,
    required this.creditLimit,
    required this.partnerGroupId,
    required this.parentId,
    required this.displayName,
  });

  factory PartnerEntity.fromJson(Map<String, dynamic> json) => PartnerEntity(
        id: json["id"],
        name: json["name"],
        vat: json["vat"],
        companyId: json["company_id"],
        email: json["email"],
        phone: json["phone"],
        street: json["street"],
        website: json["website"],
        userId: json["user_id"],
        propertyProductPricelist: json["property_product_pricelist"],
        propertyPaymentTermId: json["property_payment_term_id"],
        credit: json["credit"],
        debit: json["debit"],
        creditLimit: json["credit_limit"],
        partnerGroupId: json["partner_group_id"],
        parentId: json["parent_id"],
        displayName: json["display_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "vat": vat,
        "company_id": companyId,
        "email": email,
        "phone": phone,
        "street": street,
        "website": website,
        "user_id": userId,
        "property_product_pricelist": propertyProductPricelist,
        "property_payment_term_id": propertyPaymentTermId,
        "credit": credit,
        "debit": debit,
        "credit_limit": creditLimit,
        "partner_group_id": partnerGroupId,
        "parent_id": parentId,
        "display_name": displayName,
      };
}


// class PartnerEntity {
//   PartnerEntity({
//     required this.id,
//     required this.name,
//     required this.vat,
//     required this.companyId,
//     required this.email,
//     required this.phone,
//     required this.street,
//     required this.website,
//     required this.userId,
//     required this.propertyProductPricelist,
//     required this.propertyPaymentTermId,
//     required this.companyType,
//     required this.categoryId,
//     required this.mobile,
//     required this.function,
//     required this.partnerCredit,
//     required this.partnerDebit,
//     required this.creditLimit,
//     required this.parentId,
//     required this.displayName,
//   });

//   int id;
//   String? name;
//   String? vat;
//   int? companyId;
//   String? email;
//   String? phone;
//   String? street;
//   String? website;
//   int? userId;
//   int? propertyProductPricelist;
//   int? propertyPaymentTermId;
//   String? companyType;
//   List<int>? categoryId;
//   String? mobile;
//   String? function;
//   double? partnerCredit;
//   double? partnerDebit;
//   double? creditLimit;
//   int? parentId;
//   String? displayName;

//   factory PartnerEntity.fromJson(String str) {
//     try {
//       final jsonData = json.decode(str);
//       return PartnerEntity.fromMap(jsonData);
//     } catch (e) {
//       throw FormatException('Invalid input for PartnerEntity.fromJson: $e');
//     }
//   }

//   String toJson() => json.encode(toMap());

//   factory PartnerEntity.fromMap(Map<String, dynamic> json) {
//     return PartnerEntity(
//       id: json["id"],
//       name: json["name"],
//       vat: json["vat"],
//       companyId: json["company_id"],
//       email: json["email"],
//       phone: json["phone"],
//       street: json["street"],
//       website: json["website"],
//       userId: json["user_id"],
//       propertyProductPricelist: json["property_product_pricelist"],
//       propertyPaymentTermId: json["property_payment_term_id"],
//       companyType: json["company_type"],
//       categoryId: json["category_id"] == null
//           ? null
//           : List<int>.from(json["category_id"].map((x) => x)),
//       mobile: json["mobile"],
//       function: json["function"],
//       partnerCredit: json["partner_credit"]?.toDouble(),
//       partnerDebit: json["partner_debit"]?.toDouble(),
//       creditLimit: json["credit_limit"]?.toDouble(),
//       parentId: json["parent_id"],
//       displayName: json["display_name"],
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       "id": id,
//       "name": name,
//       "vat": vat,
//       "company_id": companyId,
//       "email": email,
//       "phone": phone,
//       "street": street,
//       "website": website,
//       "user_id": userId,
//       "property_product_pricelist": propertyProductPricelist,
//       "property_payment_term_id": propertyPaymentTermId,
//       "company_type": companyType,
//       "category_id": categoryId == null
//           ? null
//           : List<dynamic>.from(categoryId!.map((x) => x)),
//       "mobile": mobile,
//       "function": function,
//       "partner_credit": partnerCredit,
//       "partner_debit": partnerDebit,
//       "credit_limit": creditLimit,
//       "parent_id": parentId,
//       "display_name": displayName,
//     };
//   }
// }
