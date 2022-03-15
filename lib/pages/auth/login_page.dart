import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/dtos/auth/login_account_dto/login_account_dto.dart';
import 'package:varenya_professionals/exceptions/auth/user_not_found_exception.dart';
import 'package:varenya_professionals/exceptions/auth/wrong_password_exception.dart';
import 'package:varenya_professionals/exceptions/general.exception.dart';
import 'package:varenya_professionals/exceptions/server.exception.dart';
import 'package:varenya_professionals/models/doctor/doctor.model.dart';
import 'package:varenya_professionals/pages/auth/register_page.dart';
import 'package:varenya_professionals/pages/home_page.dart';
import 'package:varenya_professionals/providers/doctor.provider.dart';
import 'package:varenya_professionals/providers/user_provider.dart';
import 'package:varenya_professionals/services/auth_service.dart';
import 'package:varenya_professionals/services/doctor.service.dart';
import 'package:varenya_professionals/utils/logger.util.dart';
import 'package:varenya_professionals/utils/responsive_config.util.dart';
import 'package:varenya_professionals/utils/snackbar.dart';
import 'package:varenya_professionals/widgets/common/custom_field_widget.dart';
import 'package:varenya_professionals/widgets/common/loading_icon_button.widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const routeName = "/login";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  late final AuthService _authService;
  late final DoctorService _doctorService;

  final TextEditingController _emailFieldController =
      new TextEditingController();
  final TextEditingController _passwordFieldController =
      new TextEditingController();

  bool _loading = false;

  @override
  void initState() {
    super.initState();

    // Injecting the required services.
    this._authService = Provider.of<AuthService>(context, listen: false);
    this._doctorService = Provider.of<DoctorService>(context, listen: false);
  }

  /*
   * Handle form submission for logging the user in.
   */
  Future<void> _onFormSubmit() async {
    setState(() {
      this._loading = true;
    });
    // Check the validity of the form.
    if (!this._formKey.currentState!.validate()) {
      setState(() {
        this._loading = false;
      });
      return;
    }

    // Create a DTO object for logging in the user.
    LoginAccountDto loginAccountDto = new LoginAccountDto(
      emailAddress: this._emailFieldController.text,
      password: this._passwordFieldController.text,
    );

    try {
      // Try logging the user in with given credentials.
      User user =
          await this._authService.loginWithEmailAndPassword(loginAccountDto);

      // Fetching doctor details on successful login.
      Doctor doctor = await this._doctorService.fetchDoctorDetails();

      // Save the user details in memory.
      Provider.of<UserProvider>(context, listen: false).user = user;

      // Save the doctor details in memory.
      Provider.of<DoctorProvider>(context, listen: false).doctor = doctor;

      // Push them to the home page.
      Navigator.of(context).pushReplacementNamed(HomePage.routeName);
    }

    // Handle errors gracefully.
    on UserNotFoundException catch (error) {
      displaySnackbar(error.message, context);
    } on WrongPasswordException catch (error) {
      displaySnackbar(error.message, context);
    } on ServerException catch (error) {
      displaySnackbar(error.message, context);
    } on GeneralException catch (error) {
      displaySnackbar(error.message, context);
    } catch (error, stackTrace) {
      log.e("LoginPage:_onFormSubmit", error, stackTrace);
      displaySnackbar("Something went wrong, please try again later.", context);
    }

    setState(() {
      this._loading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();

    // Disposing off the text controllers.
    this._emailFieldController.dispose();
    this._passwordFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the email address from the previous screen.
    this._emailFieldController.text =
        ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: responsiveConfig(
                  context: context,
                  large: MediaQuery.of(context).size.height * 0.5,
                  medium: MediaQuery.of(context).size.height * 0.5,
                  small: MediaQuery.of(context).size.height * 0.5,
                ),
                child: Image.asset(
                  'assets/logo/app_logo.png',
                  scale: 0.5,
                ),
              ),
              Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: responsiveConfig(
                      context: context,
                      large: MediaQuery.of(context).size.width * 0.3,
                      medium: MediaQuery.of(context).size.width * 0.1,
                      small: 10.0,
                    ),
                  ),
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
                      OfflineBuilder(
                        connectivityBuilder: (BuildContext context,
                            ConnectivityResult value, Widget child) {
                          bool connected = value != ConnectivityResult.none;

                          return connected
                              ? LoadingIconButton(
                                  connected: true,
                                  loading: this._loading,
                                  onFormSubmit: this._onFormSubmit,
                                  text: 'Login',
                                  loadingText: 'Logging In',
                                  icon: Icon(
                                    Icons.login,
                                  ),
                                )
                              : LoadingIconButton(
                                  connected: false,
                                  loading: this._loading,
                                  onFormSubmit: this._onFormSubmit,
                                  text: 'Login',
                                  loadingText: 'Logging In',
                                  icon: Icon(
                                    Icons.login,
                                  ),
                                );
                        },
                        child: SizedBox(),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
