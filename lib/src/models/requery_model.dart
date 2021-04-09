import 'package:equatable/equatable.dart';

class ReQueryResponseModel extends Equatable {
  final String? status;
  final String? chargeResponseCode;
  final String? dataStatus;
  final Map? rawResponse;
  final String? message;
  final bool? hasData;

  ReQueryResponseModel({
    this.status,
    this.chargeResponseCode,
    this.dataStatus,
    this.rawResponse,
    this.message,
    this.hasData,
  });

  factory ReQueryResponseModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> data = json["data"] ?? {};
    String? message = data["vbvrespmessage"]?.toString();
    if (message == null || message.toUpperCase() == "N/A") {
      message = data["chargeResponseMessage"];
    }
    return ReQueryResponseModel(
        status: json["status"],
        chargeResponseCode: data["chargeResponseCode"],
        dataStatus: data["status"],
        message: message,
        hasData: data.isNotEmpty,
        rawResponse: json);
  }

  @override
  List<Object?> get props => [status, chargeResponseCode, dataStatus];
}
