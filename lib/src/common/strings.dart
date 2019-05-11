class Strings {
  static const ngn = 'NGN';
  static const ng = 'NG';
  static const card = 'Card';
  static const account = 'Account';
  static const ach = 'Ach';
  static const mpesa = 'Mpesa';
  static const ghanaMobileMoney = 'Ghana Mobile Money';
  static const ugandaMobileMoney = 'Uganda Mobile Money';

  static cannotBeNull(String name) => '$name cannot be null';

  static cannotBeNullOrNegative(String name) => '${cannotBeNull(name)} or negative';

  static cannotBeNullOrEmpty(String name) => '${cannotBeNull(name)} or empty';
}
