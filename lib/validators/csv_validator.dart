import 'package:form_field_validator/form_field_validator.dart';

class CSVValidator extends TextFieldValidator {
  final int csvLength;

  CSVValidator({
    String errorText = 'The length of items is incorrect',
    required this.csvLength,
  }) : super(errorText);

  @override
  bool isValid(String? value) {
    if (value != null) {
      List<String> element = value.split(", ");

      if (element.length >= this.csvLength) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }
}
