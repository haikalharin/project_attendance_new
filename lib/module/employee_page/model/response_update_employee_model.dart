// To parse this JSON data, do
//
//     final responseUpdateEmployeeModel = responseUpdateEmployeeModelFromJson(jsonString);

import 'dart:convert';

ResponseUpdateEmployeeModel responseUpdateEmployeeModelFromJson(String str) => ResponseUpdateEmployeeModel.fromJson(json.decode(str));

String responseUpdateEmployeeModelToJson(ResponseUpdateEmployeeModel data) => json.encode(data.toJson());

class ResponseUpdateEmployeeModel {
  bool status;
  String message;

  ResponseUpdateEmployeeModel({
    required this.status,
    required this.message,
  });

  ResponseUpdateEmployeeModel copyWith({
    bool? status,
    String? message,
  }) =>
      ResponseUpdateEmployeeModel(
        status: status ?? this.status,
        message: message ?? this.message,
      );

  factory ResponseUpdateEmployeeModel.fromJson(Map<String, dynamic> json) => ResponseUpdateEmployeeModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
