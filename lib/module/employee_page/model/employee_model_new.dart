// To parse this JSON data, do
//
//     final employeeModel = employeeModelFromJson(jsonString);

import 'dart:convert';

EmployeeModel employeeModelFromJson(String str) => EmployeeModel.fromJson(json.decode(str));

String employeeModelToJson(EmployeeModel data) => json.encode(data.toJson());

class EmployeeModel {
  bool status;
  List<Datum> data;

  EmployeeModel({
    required this.status,
    required this.data,
  });

  EmployeeModel copyWith({
    bool? status,
    List<Datum>? data,
  }) =>
      EmployeeModel(
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
    status: json["status"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  String name;
  int status;
  String address;
  String department;
  String jobTitle;
  String email;
  String phone;
  String photo;

  Datum({
    required this.id,
    required this.name,
    required this.status,
    required this.address,
    required this.department,
    required this.jobTitle,
    required this.email,
    required this.phone,
    required this.photo,
  });

  Datum copyWith({
    int? id,
    String? name,
    int? status,
    String? address,
    String? department,
    String? jobTitle,
    String? email,
    String? phone,
    String? photo,
  }) =>
      Datum(
        id: id ?? this.id,
        name: name ?? this.name,
        status: status ?? this.status,
        address: address ?? this.address,
        department: department ?? this.department,
        jobTitle: jobTitle ?? this.jobTitle,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        photo: photo ?? this.photo,
      );

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    status: json["status"],
    address: json["address"],
    department: json["department"],
    jobTitle: json["jobTitle"],
    email: json["email"],
    phone: json["phone"],
    photo: json["photo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "status": status,
    "address": address,
    "department": department,
    "jobTitle": jobTitle,
    "email": email,
    "phone": phone,
    "photo": photo,
  };
}
