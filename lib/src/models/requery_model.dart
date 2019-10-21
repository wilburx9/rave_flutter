import 'package:equatable/equatable.dart';

class ReQueryResponseModel extends Equatable {
  final String status;
  final String chargeResponseCode;
  final String dataStatus;
  final Map json;
  final String message;

  ReQueryResponseModel(
      {this.status,
      this.chargeResponseCode,
      this.dataStatus,
      this.json,
      this.message});

  factory ReQueryResponseModel.fromJson(Map<String, dynamic> json) {
    var data = json["data"];
    return ReQueryResponseModel(
        status: json["status"],
        chargeResponseCode: data["chargeResponseCode"],
        dataStatus: data["status"],
        message: data["vbvrespmessage"],
        json: json);
  }

  @override
  List<Object> get props => [status, chargeResponseCode, dataStatus];
}
