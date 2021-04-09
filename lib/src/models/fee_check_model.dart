import 'package:equatable/equatable.dart';

class FeeCheckResponseModel extends Equatable {
  final String? message;
  final String? status;
  final String? fee;
  final String? chargeAmount;
  final String? merchantFee;
  final String? raveFee;
  final Map? rawResponse;

  FeeCheckResponseModel({
    this.message,
    this.status,
    this.fee,
    this.chargeAmount,
    this.merchantFee,
    this.raveFee,
    this.rawResponse,
  });

  factory FeeCheckResponseModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> data = json["data"];
    return FeeCheckResponseModel(
      message: json["message"],
      status: json["status"],
      fee: data["fee"].toString(),
      chargeAmount: data["charge_amount"],
      merchantFee: data["merchantfee"],
      raveFee: data["ravefee"],
      rawResponse: json,
    );
  }

  @override
  List<Object?> get props => [
        message,
        status,
        fee,
        chargeAmount,
        merchantFee,
        raveFee,
      ];
}
