import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/dtos/user/update_email_dto/update_email_dto.dart';
import 'package:varenya_professionals/exceptions/auth/not_logged_in_exception.dart';
import 'package:varenya_professionals/exceptions/auth/user_already_exists_exception.dart';
import 'package:varenya_professionals/exceptions/auth/wrong_password_exception.dart';
import 'package:varenya_professionals/providers/user_provider.dart';
import 'package:varenya_professionals/services/user_service.dart';
import 'package:varenya_professionals/utils/snackbar.dart';
import 'package:varenya_professionals/widgets/common/custom_field_widget.dart';

class UserEmailUpdateTab extends StatefulWidget {
  const UserEmailUpdateTab({Key? key}) : super(key: key);

  @override
  _UserEmailUpdateTabState createState() => _UserEmailUpdateTabState();
}

class _UserEmailUpdateTabState extends State<UserEmailUpdateTab> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  late UserProvider _userProvider;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late UserService _userService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Initializing the user provider.
    this._userProvider = Provider.of<UserProvider>(context, listen: false);

    // Initializing the user service
    this._userService = Provider.of<UserService>(context, listen: false);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    // Dispose off the controllers.
    this._emailController.dispose();
    this._passwordController.dispose();
  }

  /*
   * Form submission method for user email update.
   */
  Future<void> _onFormSubmit() async {
    try {
      // Validate the form.
      if (this._formKey.currentState!.validate()) {
        // Prepare DTO for updating password.
        UpdateEmailDto updateEmailDto = new UpdateEmailDto(
          newEmailAddress: this._emailController.text,
          password: this._passwordController.text,
        );

        // Update it on server and also update the state as well.
        User user = await this._userService.updateEmailAddress(
              updateEmailDto,
            );

        this._userProvider.user = user;

        // Display success snackbar.
        displaySnackbar("Email updated!", context);
      }
    }
    // Handle errors gracefully.
    on UserAlreadyExistsException catch (error) {
      displaySnackbar(error.message, context);
    } on WrongPasswordException catch (error) {
      displaySnackbar(error.message, context);
    } on NotLoggedInException {
      print("NOT LOGGED IN");
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
        child: Consumer<UserProvider>(
          builder: (context, state, child) {
            User user = state.user;
            this._emailController.text = user.email != null ? user.email! : '';
            return Form(
              key: this._formKey,
              child: Column(
                children: [
                  CustomFieldWidget(
                    textFieldController: this._emailController,
                    label: "Email Address",
                    validators: [
                      RequiredValidator(
                        errorText: "Please enter your email address.",
                      ),
                      EmailValidator(
                        errorText: "Please enter a valid email address.",
                      ),
                    ],
                    textInputType: TextInputType.emailAddress,
                  ),
                  CustomFieldWidget(
                    textFieldController: this._passwordController,
                    label: "Password",
                    validators: [
                      RequiredValidator(
                        errorText: "Please enter your password.",
                      ),
                      MinLengthValidator(
                        5,
                        errorText:
                            "Your password should be at least 5 characters long.",
                      )
                    ],
                    textInputType: TextInputType.visiblePassword,
                    obscureText: true,
                  ),
                  ElevatedButton(
                    onPressed: this._onFormSubmit,
                    child: Text('Update Email Address'),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
