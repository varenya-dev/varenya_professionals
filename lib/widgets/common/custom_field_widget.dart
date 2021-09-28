import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class CustomFieldWidget extends StatelessWidget {
  final String label;
  final TextEditingController textFieldController;
  final List<FieldValidator> validators;
  final bool obscureText;
  final TextInputType textInputType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  CustomFieldWidget({
    Key? key,
    required this.textFieldController,
    required this.label,
    required this.validators,
    this.obscureText = false,
    required this.textInputType,
    this.prefixIcon,
    this.suffixIcon,
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
          fillColor: Colors.grey[800],
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          prefixIcon: this.prefixIcon,
          suffixIcon: this.suffixIcon,
        ),
        controller: this.textFieldController,
        validator: MultiValidator(validators),
      ),
    );
  }
}
