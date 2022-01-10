import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/dtos/user/update_password_dto/update_password_dto.dart';
import 'package:varenya_professionals/exceptions/auth/not_logged_in_exception.dart';
import 'package:varenya_professionals/exceptions/auth/weak_password_exception.dart';
import 'package:varenya_professionals/exceptions/auth/wrong_password_exception.dart';
import 'package:varenya_professionals/exceptions/general.exception.dart';
import 'package:varenya_professionals/services/user_service.dart';
import 'package:varenya_professionals/utils/logger.util.dart';
import 'package:varenya_professionals/utils/snackbar.dart';
import 'package:varenya_professionals/validators/value_validator.dart';
import 'package:varenya_professionals/widgets/common/custom_field_widget.dart';

class UserPasswordUpdateTab extends StatefulWidget {
  const UserPasswordUpdateTab({Key? key}) : super(key: key);

  @override
  _UserPasswordUpdateTabState createState() => _UserPasswordUpdateTabState();
}

class _UserPasswordUpdateTabState extends State<UserPasswordUpdateTab> {
  TextEditingController _newPasswordController = new TextEditingController();
  TextEditingController _newPasswordAgainController =
      new TextEditingController();
  TextEditingController _oldPasswordController = new TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late UserService _userService;

  @override
  void initState() {
    super.initState();

    // Initializing the user service
    this._userService = Provider.of<UserService>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();

    // Dispose off the controllers.
    this._newPasswordController.dispose();
    this._newPasswordAgainController.dispose();
    this._oldPasswordController.dispose();
  }

  /*
   * Form submission method for user password update.
   */
  Future<void> _onFormSubmit() async {
    try {
      // Validate the form.
      if (this._formKey.currentState!.validate()) {
        // Prepare DTO for updating password.
        UpdatePasswordDto updatePasswordDto = new UpdatePasswordDto(
          oldPassword: this._oldPasswordController.text,
          newPassword: this._newPasswordController.text,
        );

        // Update it on the server.
        await this._userService.updatePassword(updatePasswordDto);

        // Display success snackbar.
        displaySnackbar("Password updated!", context);
      }
    }
    // Handle errors gracefully.
    on WrongPasswordException catch (error) {
      displaySnackbar(error.message, context);
    } on WeakPasswordException catch (error) {
      displaySnackbar(error.message, context);
    } on NotLoggedInException catch (error) {
      displaySnackbar(error.message, context);
    } on GeneralException catch (error) {
      displaySnackbar(error.message, context);
    } catch (error, stackTrace) {
      log.e("UserPasswordUpdateTab:_onFormSubmit", error, stackTrace);
      displaySnackbar("Something went wrong, please try again later", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 10.0,
        ),
        child: Form(
          key: this._formKey,
          child: Column(
            children: [
              CustomFieldWidget(
                textFieldController: this._oldPasswordController,
                label: "Old Password",
                validators: [
                  RequiredValidator(
                    errorText: "Please enter your old password.",
                  ),
                  MinLengthValidator(
                    5,
                    errorText:
                        "Your old password should be at least 5 characters long.",
                  ),
                ],
                textInputType: TextInputType.visiblePassword,
                obscureText: true,
              ),
              CustomFieldWidget(
                textFieldController: this._newPasswordController,
                label: "New Password",
                validators: [
                  RequiredValidator(
                    errorText: "Please enter your new password.",
                  ),
                  MinLengthValidator(
                    5,
                    errorText:
                        "Your new password should be at least 5 characters long.",
                  )
                ],
                textInputType: TextInputType.visiblePassword,
                obscureText: true,
              ),
              CustomFieldWidget(
                textFieldController: this._newPasswordAgainController,
                label: "New Password Again",
                validators: [
                  RequiredValidator(
                    errorText: "Please enter your new password.",
                  ),
                  MinLengthValidator(
                    5,
                    errorText:
                        "Your new password should be at least 5 characters long.",
                  ),
                  ValueValidator(
                    checkAgainstTextController: this._newPasswordController,
                    errorText: "Passwords don't match",
                  ),
                ],
                textInputType: TextInputType.visiblePassword,
                obscureText: true,
              ),
              ElevatedButton(
                onPressed: this._onFormSubmit,
                child: Text('Update Password'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
