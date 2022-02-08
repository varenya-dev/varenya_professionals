import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:varenya_professionals/utils/palette.util.dart';

class CustomTextArea extends StatelessWidget {
  final String label;
  final String helperText;
  final TextEditingController textFieldController;
  final List<FieldValidator> validators;
  final TextInputType textInputType;
  final int minLines;
  final int? maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  CustomTextArea({
    Key? key,
    required this.textFieldController,
    this.label = '',
    this.helperText = '',
    required this.validators,
    required this.textInputType,
    this.minLines = 1,
    this.maxLines,
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
        style: TextStyle(
          color: Colors.black,
        ),
        minLines: this.minLines,
        maxLines: this.maxLines,
        keyboardType: textInputType,
        decoration: InputDecoration(
          hintStyle: TextStyle(
            color: Palette.secondary,
          ),
          hintText: this.helperText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          filled: true,
          fillColor: Colors.white,
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              15.0,
            ),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
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
