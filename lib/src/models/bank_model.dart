class BankModel {
  final String name;
  final String code;
  final bool internetBanking;

  BankModel.fromJson(Map map)
      : this.name = map['bankname'],
        this.code = map['bankcode'],
        this.internetBanking = map['internetbanking'];

  bool showBVNField() =>
      code == '033'; // 033 is code for UNITED BANK FOR AFRICA PLC

  bool showDOBField() =>
      code == '057' || code == '033'; // 057 is for ZENITH BANK PLC

  bool showAccountNumField() => !internetBanking;
}
