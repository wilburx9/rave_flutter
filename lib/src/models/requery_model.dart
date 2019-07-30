import 'package:equatable/equatable.dart';

class ReQueryResponseModel extends Equatable {
  final String status;
  final String chargeResponseCode;
  final String dataStatus;

  ReQueryResponseModel({this.status, this.chargeResponseCode, this.dataStatus})
      : super([status, chargeResponseCode, dataStatus]);

  factory ReQueryResponseModel.fromJson(Map<String, dynamic> json) {
    return ReQueryResponseModel(
        status: json["status"],
        chargeResponseCode: json["data"]["chargeResponseCode"],
        dataStatus: json["data"]["status"]);
  }
}
