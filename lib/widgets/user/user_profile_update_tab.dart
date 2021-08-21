import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/providers/user_provider.dart';
import 'package:varenya_professionals/services/user_service.dart';
import 'package:varenya_professionals/utils/display_bottom_sheet.dart';
import 'package:varenya_professionals/utils/image_picker.dart';
import 'package:varenya_professionals/utils/snackbar.dart';
import 'package:varenya_professionals/utils/upload_image_generate_url.dart';
import 'package:varenya_professionals/widgets/common/custom_field_widget.dart';
import 'package:varenya_professionals/widgets/common/profile_picture_widget.dart';

class UserProfileUpdateTab extends StatefulWidget {
  const UserProfileUpdateTab({Key? key}) : super(key: key);

  @override
  _UserProfileUpdateTabState createState() => _UserProfileUpdateTabState();
}

class _UserProfileUpdateTabState extends State<UserProfileUpdateTab> {
  TextEditingController _fullNameController = new TextEditingController();

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

    // Disposing off the controllers
    this._fullNameController.dispose();
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

      // Update the user details
      User user = await this._userService.updateProfilePicture(uploadedUrl);

      // Save the updated state.
      this._userProvider.user = user;

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

      // Update the user details
      User user = await this._userService.updateProfilePicture(uploadedUrl);

      // Save the updated state.
      this._userProvider.user = user;

      // Display a success snackbar.
      displaySnackbar(
        "Profile picture updated!",
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

  /*
   * Form submission method for user profile update.
   */
  Future<void> _onFormSubmit() async {
    try {
      // Validate the form.
      if (this._formKey.currentState!.validate()) {
        // Update it on server and also update the state as well.
        User user = await this
            ._userService
            .updateFullName(this._fullNameController.text);

        this._userProvider.user = user;

        // Display success snackbar.
        displaySnackbar("Your profile name has been updated!", context);
      }
    }
    // Handle errors gracefully.
    catch (error) {
      print(error);
      displaySnackbar("Something went wrong, please try again later", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<UserProvider>(builder: (context, state, child) {
        User user = state.user;
        String imageUrl = user.photoURL == null ? '' : user.photoURL!;

        this._fullNameController.text =
            user.displayName != null ? user.displayName! : '';

        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 10.0,
          ),
          child: Form(
            key: this._formKey,
            child: Column(
              children: [
                Column(
                  children: [
                    ProfilePictureWidget(
                      imageUrl: imageUrl,
                      size: 200,
                    ),
                    TextButton(
                      onPressed: this._onUploadImage,
                      child: Text(
                        'Upload New Image',
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    )
                  ],
                ),
                CustomFieldWidget(
                  textFieldController: this._fullNameController,
                  label: "First Name",
                  validators: [
                    RequiredValidator(errorText: "Full name is required"),
                  ],
                  textInputType: TextInputType.text,
                ),
                ElevatedButton(
                  onPressed: this._onFormSubmit,
                  child: Text('Update Profile'),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
