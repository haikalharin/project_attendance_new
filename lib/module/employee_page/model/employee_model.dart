// To parse this JSON data, do
//
//     final employee = employeeFromJson(jsonString);

import 'dart:convert';

Employee employeeFromJson(String str) => Employee.fromJson(json.decode(str));

String employeeToJson(Employee data) => json.encode(data.toJson());

class Employee {
  String? name;
  bool? isActive;

  Employee({
    this.name,
    this.isActive,
  });

  Employee copyWith({
    String? name,
    bool? isActive,
  }) =>
      Employee(
        name: name ?? this.name,
        isActive: isActive ?? this.isActive,
      );

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
    name: json["name"],
    isActive: json["isActive"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "isActive": isActive,
  };
}
