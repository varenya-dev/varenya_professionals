import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class CustomTextArea extends StatelessWidget {
  final String label;
  final TextEditingController textFieldController;
  final List<FieldValidator> validators;
  final TextInputType textInputType;
  final int minLines;
  final int? maxLines;

  CustomTextArea({
    Key? key,
    required this.textFieldController,
    required this.label,
    required this.validators,
    required this.textInputType,
    this.minLines = 1,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 10.0,
      ),
      child: TextFormField(
        minLines: this.minLines,
        maxLines: this.maxLines,
        keyboardType: textInputType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderSide: BorderSide(),
          ),
        ),
        controller: this.textFieldController,
        validator: MultiValidator(validators),
      ),
    );
  }
}
