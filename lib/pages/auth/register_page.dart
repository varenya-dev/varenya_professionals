import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/dtos/auth/register_account_dto/register_account_dto.dart';
import 'package:varenya_professionals/exceptions/auth/user_already_exists_exception.dart';
import 'package:varenya_professionals/pages/auth/login_page.dart';
import 'package:varenya_professionals/pages/auth/user_details_page.dart';
import 'package:varenya_professionals/services/auth_service.dart';
import 'package:varenya_professionals/utils/snackbar.dart';
import 'package:varenya_professionals/validators/value_validator.dart';
import 'package:varenya_professionals/widgets/common/custom_field_widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  static const routeName = "/register";

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  late AuthService _authService;

  final TextEditingController _emailFieldController =
      new TextEditingController();
  final TextEditingController _passwordFieldController =
      new TextEditingController();
  final TextEditingController _passwordAgainFieldController =
      new TextEditingController();

  @override
  void initState() {
    super.initState();
    this._authService = Provider.of<AuthService>(context, listen: false);
  }

  Future<void> _onFormSubmit() async {
    if (!this._formKey.currentState!.validate()) {
      return;
    }

    RegisterAccountDto registerAccountDto = new RegisterAccountDto(
      emailAddress: this._emailFieldController.text,
      password: this._passwordFieldController.text,
    );

    try {
      await this._authService.registerWithEmailAndPassword(registerAccountDto);

      Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
    } on UserAlreadyExistsException catch (error) {
      displaySnackbar(error.message, context);
    }
  }

  @override
  void dispose() {
    super.dispose();

    this._emailFieldController.dispose();
    this._passwordFieldController.dispose();
    this._passwordAgainFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Register'),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomFieldWidget(
                      textFieldController: this._emailFieldController,
                      label: 'Email Address',
                      validators: [
                        RequiredValidator(
                          errorText: 'Please enter your email address here.',
                        ),
                        EmailValidator(
                          errorText: 'Please enter a valid email address.',
                        )
                      ],
                      textInputType: TextInputType.emailAddress,
                    ),
                    CustomFieldWidget(
                      textFieldController: this._passwordFieldController,
                      label: 'Password',
                      validators: [
                        RequiredValidator(
                          errorText: 'Please enter your password here.',
                        ),
                        MinLengthValidator(
                          5,
                          errorText:
                              'Your password should be at least 5 characters long.',
                        )
                      ],
                      textInputType: TextInputType.text,
                      obscureText: true,
                    ),
                    CustomFieldWidget(
                      textFieldController: this._passwordAgainFieldController,
                      label: 'Password Again',
                      validators: [
                        RequiredValidator(
                          errorText: 'Please enter your password here.',
                        ),
                        MinLengthValidator(
                          5,
                          errorText:
                              'Your password should be at least 5 characters long.',
                        ),
                        ValueValidator(
                          checkAgainstTextController:
                              this._passwordFieldController,
                          errorText: 'Passwords don\'t match.',
                        ),
                      ],
                      textInputType: TextInputType.text,
                      obscureText: true,
                    ),
                    ElevatedButton(
                      onPressed: _onFormSubmit,
                      child: Text('Register'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context)
                          .pushReplacementNamed(LoginPage.routeName),
                      child: Text('Already have an account? Login here!'),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
