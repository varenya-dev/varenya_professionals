import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class CustomFieldWidget extends StatelessWidget {
  final String label;
  final TextEditingController textFieldController;
  final List<FieldValidator> validators;
  final bool obscureText;
  final TextInputType textInputType;

  CustomFieldWidget({
    Key? key,
    required this.textFieldController,
    required this.label,
    required this.validators,
    this.obscureText = false,
    required this.textInputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 10.0,
      ),
      child: TextFormField(
        obscureText: this.obscureText,
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
