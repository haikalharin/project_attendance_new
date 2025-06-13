// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  bool? status;
  String? message;
  String? token;
  Data? data;

  LoginModel({
    this.status,
    this.message,
    this.token,
    this.data,
  });

  LoginModel copyWith({
    bool? status,
    String? message,
    String? token,
    Data? data,
  }) =>
      LoginModel(
        status: status ?? this.status,
        message: message ?? this.message,
        token: token ?? this.token,
        data: data ?? this.data,
      );

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    status: json["status"],
    message: json["message"],
    token: json["token"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "token": token,
    "data": data?.toJson(),
  };
}

class Data {
  String? nama;
  String? jabatan;
  String? photo;

  Data({
    this.nama,
    this.jabatan,
    this.photo,
  });

  Data copyWith({
    String? nama,
    String? jabatan,
    String? photo,
  }) =>
      Data(
        nama: nama ?? this.nama,
        jabatan: jabatan ?? this.jabatan,
        photo: photo ?? this.photo,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    nama: json["nama"],
    jabatan: json["jabatan"],
    photo: json["photo"],
  );

  Map<String, dynamic> toJson() => {
    "nama": nama,
    "jabatan": jabatan,
    "photo": photo,
  };
}
