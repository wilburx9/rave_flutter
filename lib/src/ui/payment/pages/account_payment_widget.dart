import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rave_flutter/src/common/my_colors.dart';
import 'package:rave_flutter/src/common/strings.dart';
import 'package:rave_flutter/src/manager/account_transaction_manager.dart';
import 'package:rave_flutter/src/models/bank_model.dart';
import 'package:rave_flutter/src/services/bank_service.dart';
import 'package:rave_flutter/src/ui/fields/account_number_field.dart';
import 'package:rave_flutter/src/ui/fields/base_field.dart';
import 'package:rave_flutter/src/ui/fields/bvn_field.dart';
import 'package:rave_flutter/src/ui/fields/phone_number_field.dart';
import 'package:rave_flutter/src/ui/payment/pages/base_payment_page.dart';

class AccountPaymentWidget extends BasePaymentPage {
  AccountPaymentWidget({required AccountTransactionManager manager})
      : super(transactionManager: manager);

  @override
  _AccountPaymentWidgetState createState() => _AccountPaymentWidgetState();
}

class _AccountPaymentWidgetState
    extends BasePaymentPageState<AccountPaymentWidget> {
  Future<List<BankModel>>? _banks;
  var _phoneFocusNode = FocusNode();
  var _bvnFocusNode = FocusNode();
  var _accountFocusNode = FocusNode();
  BankModel? _selectedBank;
  DateTime? _pickedDate;

  @override
  void initState() {
    _banks = BankService.instance!.fetchBanks;
    super.initState();
  }

  @override
  void dispose() {
    _phoneFocusNode.dispose();
    _bvnFocusNode.dispose();
    _accountFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return FutureBuilder<List<BankModel>>(
      future: _banks,
      builder: (_, snapshot) {
        Widget widget;
        if (snapshot.connectionState == ConnectionState.waiting) {
          widget = Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 20),
            child: SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(
                strokeWidth: 3,
              ),
            ),
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          widget = Column(
            children: <Widget>[buildHeader(), buildMainFields(snapshot.data)],
          );
        } else {
          widget = Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 20),
            child: FlatButton(
                onPressed: () {
                  setState(() {
                    _banks = BankService.instance!.fetchBanks;
                  });
                },
                color: MyColors.buttercup,
                padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                child: Text(
                  'Display banks',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                )),
          );
        }
        return widget;
      },
    );
  }

  @override
  List<Widget> buildLocalFields([data]) {
    return [
      PhoneNumberField(
          focusNode: _phoneFocusNode,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (value) => swapFocus(
              _phoneFocusNode,
              _selectedBank == null
                  ? null
                  : _selectedBank!.showAccountNumField()
                      ? _accountFocusNode
                      : _selectedBank!.showBVNField() ? _bvnFocusNode : null),
          onSaved: (value) => payload!.phoneNumber = value),
      _selectedBank != null && _selectedBank!.showAccountNumField()
          ? AccountNumberField(
              focusNode: _accountFocusNode,
              textInputAction: _selectedBank!.showBVNField()
                  ? TextInputAction.next
                  : TextInputAction.done,
              onFieldSubmitted: (value) => swapFocus(_accountFocusNode,
                  _selectedBank!.showBVNField() ? _bvnFocusNode : null),
              onSaved: (value) => payload!.accountNumber = value)
          : SizedBox(),
      _selectedBank != null && _selectedBank!.showBVNField()
          ? BVNField(
              focusNode: _bvnFocusNode,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (value) => swapFocus(_bvnFocusNode),
              onSaved: (value) => payload!.bvn = value)
          : SizedBox(),
      DropdownButtonHideUnderline(
        child: InputDecorator(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
            filled: true,
            errorText:
                autoValidate && _selectedBank == null ? 'Select a bank' : null,
            fillColor: Colors.grey[50],
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.grey[400]!.withOpacity(.7), width: .5),
                borderRadius: BorderRadius.all(Radius.circular(1.5))),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.grey[400]!.withOpacity(.7), width: 1),
                borderRadius: BorderRadius.all(Radius.circular(1.5))),
            hintText: 'Select bank',
          ),
          isEmpty: _selectedBank == null,
          child: new DropdownButton<BankModel>(
            value: _selectedBank,
            isDense: true,
            onChanged: (BankModel? newValue) {
              setState(() => _selectedBank = newValue);
              payload!.bank = _selectedBank;
            },
            items: data
                .cast<BankModel>()
                .map((BankModel value) {
                  return new DropdownMenuItem<BankModel>(
                    value: value,
                    child: new Text(value.name!),
                  );
                })
                .cast<DropdownMenuItem<BankModel>>()
                .toList(),
          ),
        ),
      ),
      _selectedBank != null && _selectedBank!.showDOBField()
          ? InkWell(
              onTap: _selectBirthday,
              child: IgnorePointer(
                child: BaseTextField(
                  labelText:
                      _pickedDate == null ? 'DATE OF BIRTH' : geFormattedDate(),
                  validator: (value) =>
                      _pickedDate == null ? Strings.invalidDOB : null,
                  labelStyle: TextStyle(
                      color:
                          _pickedDate == null ? Colors.grey : Colors.grey[800],
                      fontSize: 14),
                ),
              ),
            )
          : SizedBox()
    ];
  }

  @override
  onFormValidated() {
    payload!..bank = _selectedBank;
    super.onFormValidated();
  }

  void _selectBirthday() async {
    updateDate(date) {
      setState(() => _pickedDate = date);
      payload!.passCode = DateFormat('dd/MM/yyyy').format(_pickedDate!);
    }

    var now = new DateTime.now();
    var minimumYear = 1900;
    if (Platform.isIOS) {
      showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) => Container(
                height: _kPickerSheetHeight,
                padding: const EdgeInsets.only(top: 6.0),
                color: CupertinoColors.white,
                child: DefaultTextStyle(
                  style: const TextStyle(
                    color: CupertinoColors.black,
                    fontSize: 22.0,
                  ),
                  child: GestureDetector(
                    // Blocks taps from propagating to the modal sheet and popping.
                    onTap: () {},
                    child: SafeArea(
                      top: false,
                      child: new CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: now,
                        maximumDate: now,
                        minimumYear: minimumYear,
                        maximumYear: now.year,
                        onDateTimeChanged: updateDate,
                      ),
                    ),
                  ),
                ),
              ));
    } else {
      DateTime? result = await showDatePicker(
          context: context,
          selectableDayPredicate: (DateTime val) =>
              val.year > now.year && val.month > now.month && val.day > now.day
                  ? false
                  : true,
          initialDate: now,
          firstDate: new DateTime(minimumYear),
          lastDate: now);

      updateDate(result);
    }
  }

  String geFormattedDate() => DateFormat.yMMMMd().format(_pickedDate!);

  @override
  FocusNode getNextFocusNode() => _phoneFocusNode;
}

const double _kPickerSheetHeight = 216.0;
