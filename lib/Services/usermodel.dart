import 'dart:convert';

Usermodel usermodelFromJson(String str) => Usermodel.fromJson(json.decode(str));

String usermodelToJson(Usermodel data) => json.encode(data.toJson());

class Usermodel {
  Usermodel({
    required this.id,
    this.name,
    this.email,
    this.phone,
    this.companyname,
    this.designation,
    this.count,
  });

  String id;
  String? name;
  String? email;
  String? phone;
  String? companyname;
  String? designation;
  int? count;

  factory Usermodel.fromJson(Map<String, dynamic> json) => Usermodel(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    companyname: json["companyname"],
    designation: json["designation"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "companyname": companyname,
    "designation": designation,
    "count": count,
  };
}