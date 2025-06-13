class ResponseServiceModel {
  ResponseServiceModel({
    required this.isSuccess,
    required this.message,
    required this.data,
    this.secondsTimeLimit
  });

  bool isSuccess;
  String message;
  dynamic data;
  dynamic secondsTimeLimit;

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess.toString(),
        "message": message,
        "data": data.toString(),
         "secondsTimeLimit": secondsTimeLimit
      };

  ResponseServiceModel copyWith({
    bool? isSuccess,
    String? message,
    dynamic data,
    dynamic  secondsTimeLimit
  }) {
    return ResponseServiceModel(
      isSuccess: isSuccess ?? this.isSuccess,
      message: message ?? this.message,
      data: data ?? this.data,
      secondsTimeLimit : secondsTimeLimit ?? this.secondsTimeLimit
    );
  }
}
