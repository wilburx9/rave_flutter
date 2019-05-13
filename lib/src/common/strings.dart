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
  static var invalidNumber = 'Enter a valid card number';
  static var invalidAmount = 'Enter a valid amount';
  static var invalidEmail = 'Enter a valid email';
  static var demo = 'Demo';

  static cannotBeNull(String name) => '$name cannot be null';

  static cannotBeNullOrNegative(String name) => '${cannotBeNull(name)} or negative';

  static cannotBeNullOrEmpty(String name) => '${cannotBeNull(name)} or empty';
}
