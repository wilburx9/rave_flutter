class Strings {
  static const ngn = 'NGN';
  static const ng = 'NG';
  static const card = 'Card';
  static const account = 'Account';
  static const amount = 'Amount';
  static const ach = 'Ach';
  static const mpesa = 'Mpesa';
  static const ghanaMobileMoney = 'Ghana Mobile Money';
  static const ugandaMobileMoney = 'Uganda Mobile Money';
  static const pay = 'Pay';
  static const invalidCVV = 'Enter a valid cvv';
  static String invalidExpiry = 'Enter a valid expiry date';
  static var invalidCardNumber = 'Enter a valid card number';
  static var invalidPhoneNumber = 'Enter a valid phone number';
  static var invalidAccountNumber = 'Enter a valid account number';
  static var invalidAmount = 'Enter a valid amount';
  static var invalidEmail = 'Enter a valid email';
  static var invalidBVN = 'Enter a valid BVN';
  static var invalidVoucher = 'Enter a valid voucher code';
  static var invalidDOB = 'Enter a valid date of birth';
  static var demo = 'Demo';
  static var youCancelled = 'You cancelled';
  static var sthWentWrong = 'Something went wrong';
  static var noResponseData = 'No response data was returned';
  static var unknownAuthModel = 'Unknown auth model';
  static var enterOtp = 'Enter your one  time password (OTP)';

  static cannotBeNull(String name) => '$name cannot be null';

  static cannotBeNullOrNegative(String name) => '${cannotBeNull(name)} or negative';

  static cannotBeNullOrEmpty(String name) => '${cannotBeNull(name)} or empty';
}
