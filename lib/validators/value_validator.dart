import 'package:flutter/cupertino.dart';
import 'package:form_field_validator/form_field_validator.dart';

class ValueValidator extends TextFieldValidator {
  final TextEditingController checkAgainstTextController;

  ValueValidator({
    String errorText = 'This field does not match the given value',
    required this.checkAgainstTextController,
  }) : super(errorText);

  @override
  bool isValid(String? value) {
    return value! == checkAgainstTextController.text;
  }
}
