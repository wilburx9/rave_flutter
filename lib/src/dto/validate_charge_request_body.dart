class ValidateChargeRequestBody {
  final String? transactionReference;
  final String? pBFPubKey;
  final String? otp;

  ValidateChargeRequestBody(
      {this.transactionReference, this.pBFPubKey, this.otp});

  Map<String, dynamic> toJson() => {
        "transaction_reference": transactionReference,
        "PBFPubKey": pBFPubKey,
        "otp": otp,
      };
}
