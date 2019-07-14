import 'package:equatable/equatable.dart';

class FeeCheckModel extends Equatable {
  final String message;
  final String status;
  final String fee;
  final String chargeAmount;
  final String merchantFee;
  final String raveFee;

  FeeCheckModel({
    this.message,
    this.status,
    this.fee,
    this.chargeAmount,
    this.merchantFee,
    this.raveFee,
  }) : super([message, status, fee, chargeAmount, merchantFee, raveFee]);

  factory FeeCheckModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> data = json["data"];
    return FeeCheckModel(
        message: json["message"],
        status: json["status"],
        fee: data["fee"].toString(),
        chargeAmount: data["charge_amount"],
        merchantFee: data["merchantfee"],
        raveFee: data["ravefee"]);
  }
}