class Strings {
  static const ngn = 'NGN';
  static const ng = 'NG';
  static const usd = 'USD';
  static const us = 'US';
  static const card = 'Card';
  static const account = 'Account';
  static const amount = 'Amount';
  static const ach = 'ACH';
  static const mpesa = 'Mpesa';
  static const ghanaMobileMoney = 'Ghana Mobile Money';
  static const ugandaMobileMoney = 'Uganda Mobile Money';
  static const mobileMoneyFrancophoneAfrica = 'Mobile Money Francophone Africa';
  static const pay = 'Pay';
  static const invalidCVV = 'Enter a valid cvv';
  static const invalidExpiry = 'Enter a valid expiry date';
  static const invalidCardNumber = 'Enter a valid card number';
  static const invalidPhoneNumber = 'Enter a valid phone number';
  static const invalidAccountNumber = 'Enter a valid account number';
  static const invalidAmount = 'Enter a valid amount';
  static const invalidEmail = 'Enter a valid email';
  static const invalidBVN = 'Enter a valid BVN';
  static const invalidVoucher = 'Enter a valid voucher code';
  static const invalidDOB = 'Enter a valid date of birth';
  static const demo = 'Demo';
  static const youCancelled = 'You cancelled';
  static const sthWentWrong = 'Something went wrong';
  static const noResponseData = 'No response data was returned';
  static const unknownAuthModel = 'Unknown auth model';
  static const enterOtp = 'Enter your one  time password (OTP)';
  static const noAuthUrl = 'No authUrl was returned';

  static cannotBeNull(String name) => '$name cannot be null';

  static cannotBeNullOrNegative(String name) =>
      '${cannotBeNull(name)} or negative';

  static cannotBeNullOrEmpty(String name) => '${cannotBeNull(name)} or empty';
}
