import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/dtos/auth/register_account_dto/register_account_dto.dart';
import 'package:varenya_professionals/exceptions/auth/user_already_exists_exception.dart';
import 'package:varenya_professionals/exceptions/general.exception.dart';
import 'package:varenya_professionals/exceptions/server.exception.dart';
import 'package:varenya_professionals/models/doctor/doctor.model.dart';
import 'package:varenya_professionals/pages/auth/login_page.dart';
import 'package:varenya_professionals/pages/home_page.dart';
import 'package:varenya_professionals/providers/doctor.provider.dart';
import 'package:varenya_professionals/providers/user_provider.dart';
import 'package:varenya_professionals/services/auth_service.dart';
import 'package:varenya_professionals/services/doctor.service.dart';
import 'package:varenya_professionals/utils/display_bottom_sheet.dart';
import 'package:varenya_professionals/utils/image_picker.dart';
import 'package:varenya_professionals/utils/logger.util.dart';
import 'package:varenya_professionals/utils/snackbar.dart';
import 'package:varenya_professionals/utils/upload_image_generate_url.dart';
import 'package:varenya_professionals/validators/value_validator.dart';
import 'package:varenya_professionals/widgets/common/custom_field_widget.dart';
import 'package:varenya_professionals/widgets/common/profile_picture_widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  static const routeName = "/register";

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _imageUrl = '';

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  late final AuthService _authService;
  late final UserProvider _userProvider;
  late final DoctorProvider _doctorProvider;
  late final DoctorService _doctorService;

  late String _emailAddress;

  final TextEditingController _nameFieldController =
      new TextEditingController();
  final TextEditingController _passwordFieldController =
      new TextEditingController();
  final TextEditingController _passwordAgainFieldController =
      new TextEditingController();

  @override
  void initState() {
    super.initState();

    this._authService = Provider.of<AuthService>(context, listen: false);
    this._userProvider = Provider.of<UserProvider>(context, listen: false);
    this._doctorProvider = Provider.of<DoctorProvider>(context, listen: false);
    this._doctorService = Provider.of<DoctorService>(context, listen: false);
  }

  /*
   * Handle form submission for registering the user in.
   */
  Future<void> _onFormSubmit() async {
    // Check the validity of the form.
    if (!this._formKey.currentState!.validate()) {
      return;
    }

    // Create a DTO object for signing in the user.
    RegisterAccountDto registerAccountDto = new RegisterAccountDto(
      fullName: this._nameFieldController.text,
      imageUrl: this._imageUrl,
      emailAddress: this._emailAddress,
      password: this._passwordFieldController.text,
    );

    try {
      // Try registering the user in with given credentials.
      User user = await this
          ._authService
          .registerWithEmailAndPassword(registerAccountDto);

      // Save the user details in memory.
      this._userProvider.user = user;

      Doctor createdDoctor = await this._doctorService.createPlaceholderData();

      this._doctorProvider.doctor = createdDoctor;

      // Push them to the home page.
      Navigator.of(context).pushReplacementNamed(HomePage.routeName);
    }

    // Handle errors gracefully.
    on UserAlreadyExistsException catch (error) {
      displaySnackbar(error.message, context);
    } on ServerException catch (error) {
      displaySnackbar(error.message, context);
    } on GeneralException catch (error) {
      displaySnackbar(error.message, context);
    } catch (error, stackTrace) {
      log.e("RegisterPage:_onFormSubmit", error, stackTrace);
      displaySnackbar("Something went wrong, please try again later.", context);
    }
  }

  @override
  void dispose() {
    super.dispose();

    this._nameFieldController.dispose();
    this._passwordFieldController.dispose();
    this._passwordAgainFieldController.dispose();
  }

  /*
   * Method for uploading images from gallery.
   */
  Future<void> _uploadFromGallery() async {
    // Open the gallery and get the selected image.
    XFile? imageXFile = await openGallery();

    // Run if there is an image selected.
    if (imageXFile != null) {
      // Prepare the file from the selected image.
      File imageFile = new File(imageXFile.path);

      // Upload the image to firebase and generate a URL.
      String uploadedUrl =
          await uploadImageAndGenerateUrl(imageFile, "profile-pictures");

      setState(() {
        this._imageUrl = uploadedUrl;
      });

      // Display a success snackbar.
      displaySnackbar(
        "Profile picture updated!",
        context,
      );
    }
  }

  /*
   * Method for uploading images from camera.
   */
  Future<void> _uploadFromCamera() async {
    // Open the gallery and get the selected image.
    XFile? imageXFile = await openCamera();

    // Run if there is an image selected.
    if (imageXFile != null) {
      // Prepare the file from the selected image.
      File imageFile = new File(imageXFile.path);

      // Upload the image to firebase and generate a URL.
      String uploadedUrl =
          await uploadImageAndGenerateUrl(imageFile, "profile-pictures");

      setState(() {
        this._imageUrl = uploadedUrl;
      });

      // Display a success snackbar.
      displaySnackbar(
        "Profile picture uploaded!",
        context,
      );
    }
  }

  /*
   * Method to open up camera or gallery on user's selection.
   */
  void _onUploadImage() {
    displayBottomSheet(
      context,
      Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt_rounded),
            title: Text('Upload from camera'),
            onTap: this._uploadFromCamera,
          ),
          ListTile(
            leading: Icon(Icons.photo_album_sharp),
            title: Text('Upload from storage'),
            onTap: this._uploadFromGallery,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    this._emailAddress = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProfilePictureWidget(
                  imageUrl: this._imageUrl,
                  size: 200.0,
                ),
                TextButton(
                  onPressed: this._onUploadImage,
                  child: Text('Upload Picture'),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomFieldWidget(
                        textFieldController: this._nameFieldController,
                        label: 'Full Name',
                        validators: [
                          RequiredValidator(
                            errorText: 'Please enter your name here.',
                          ),
                          MinLengthValidator(
                            5,
                            errorText:
                                'Your name should be at least 5 characters long.',
                          )
                        ],
                        textInputType: TextInputType.name,
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
      ),
    );
  }
}
