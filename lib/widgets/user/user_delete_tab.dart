import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/exceptions/auth/not_logged_in_exception.dart';
import 'package:varenya_professionals/exceptions/auth/weak_password_exception.dart';
import 'package:varenya_professionals/exceptions/auth/wrong_password_exception.dart';
import 'package:varenya_professionals/exceptions/general.exception.dart';
import 'package:varenya_professionals/pages/auth/auth_page.dart';
import 'package:varenya_professionals/providers/doctor.provider.dart';
import 'package:varenya_professionals/providers/user_provider.dart';
import 'package:varenya_professionals/services/doctor.service.dart';
import 'package:varenya_professionals/services/user_service.dart';
import 'package:varenya_professionals/utils/logger.util.dart';
import 'package:varenya_professionals/utils/snackbar.dart';
import 'package:varenya_professionals/widgets/common/custom_field_widget.dart';
import 'package:varenya_professionals/widgets/common/loading_icon_button.widget.dart';

class UserDeleteTab extends StatefulWidget {
  const UserDeleteTab({Key? key}) : super(key: key);

  @override
  _UserDeleteTabState createState() => _UserDeleteTabState();
}

class _UserDeleteTabState extends State<UserDeleteTab> {
  TextEditingController _passwordController = new TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late UserService _userService;

  late UserProvider _userProvider;
  late final DoctorProvider _doctorProvider;
  bool _loading = false;

  @override
  void initState() {
    super.initState();

    // Initializing the user provider.
    this._userProvider = Provider.of<UserProvider>(context, listen: false);
    this._doctorProvider = Provider.of<DoctorProvider>(context, listen: false);

    // Initializing the user service.
    this._userService = Provider.of<UserService>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();

    // Dispose off the controller.
    this._passwordController.dispose();
  }

  /*
   * Form submission method for user delete.
   */
  Future<void> _onFormSubmit() async {
    try {
      // Validate the form.
      if (this._formKey.currentState!.validate()) {
        setState(() {
          this._loading = true;
        });
        // Delete the account from the server.
        await this._userService.deleteAccount(this._passwordController.text);

        // Clear off the provider state.
        this._userProvider.removeUser();
        this._doctorProvider.removeDoctor();

        // Log out to the authentication page.
        Navigator.of(context).pushReplacementNamed(AuthPage.routeName);
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
      log.e("UserDeleteTab:_onFormSubmit", error, stackTrace);
      displaySnackbar("Something went wrong, please try again later", context);
    }

    setState(() {
      this._loading = false;
    });
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
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Image.asset(
                  'assets/logo/app_logo.png',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Please note that deleting your account ',
                      ),
                      TextSpan(
                        text: 'deletes all of your data from Varenya. ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text:
                            'This action is irreversible and no data is recoverable after deleting your account.',
                      ),
                    ],
                  ),
                ),
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
              OfflineBuilder(
                connectivityBuilder:
                    (BuildContext context, ConnectivityResult result, _) {
                  final bool connected = result != ConnectivityResult.none;

                  return connected
                      ? LoadingIconButton(
                          connected: true,
                          loading: this._loading,
                          onFormSubmit: this._onFormSubmit,
                          text: 'Delete Account',
                          loadingText: 'Deleting',
                          icon: Icon(Icons.delete_outline),
                        )
                      : LoadingIconButton(
                          connected: false,
                          loading: this._loading,
                          onFormSubmit: this._onFormSubmit,
                          text: 'Delete Account',
                          loadingText: 'Deleting',
                          icon: Icon(Icons.delete_outline),
                        );
                },
                child: SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
