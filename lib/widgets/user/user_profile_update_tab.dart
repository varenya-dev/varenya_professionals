import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/enum/job.enum.dart';
import 'package:varenya_professionals/enum/specialization.enum.dart';
import 'package:varenya_professionals/models/doctor/doctor.model.dart';
import 'package:varenya_professionals/providers/doctor.provider.dart';
import 'package:varenya_professionals/providers/user_provider.dart';
import 'package:varenya_professionals/services/doctor.service.dart';
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
  final TextEditingController _fullNameController = new TextEditingController();
  final TextEditingController _costController = new TextEditingController();
  final TextEditingController _addressController = new TextEditingController();

  late final UserProvider _userProvider;
  late final DoctorProvider _doctorProvider;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final UserService _userService;
  late final DoctorService _doctorService;

  late Doctor _doctor;

  @override
  void initState() {
    super.initState();

    // Initializing the user provider.
    this._userProvider = Provider.of<UserProvider>(context, listen: false);
    this._doctorProvider = Provider.of<DoctorProvider>(context, listen: false);
    this._userService = Provider.of<UserService>(context, listen: false);
    this._doctorService = Provider.of<DoctorService>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();

    // Disposing off the controllers
    this._fullNameController.dispose();
    this._costController.dispose();
    this._addressController.dispose();
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

      Doctor newDoctor = this._doctor;
      newDoctor.imageUrl = uploadedUrl;

      Doctor updatedDoctor = await this._doctorService.updateDoctor(newDoctor);
      this._doctorProvider.doctor = updatedDoctor;

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

      Doctor newDoctor = this._doctor;
      newDoctor.imageUrl = uploadedUrl;

      Doctor updatedDoctor = await this._doctorService.updateDoctor(newDoctor);
      this._doctorProvider.doctor = updatedDoctor;

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

        Doctor newDoctor = this._doctor;
        newDoctor.cost = double.parse(this._costController.text);
        newDoctor.fullName = this._fullNameController.text;
        newDoctor.clinicAddress = this._addressController.text;

        Doctor updatedDoctor =
            await this._doctorService.updateDoctor(newDoctor);
        this._doctorProvider.doctor = updatedDoctor;

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
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 10.0,
        ),
        child: Consumer<DoctorProvider>(
          builder: (BuildContext context, DoctorProvider state, _) {
            this._doctor = state.doctor;

            this._fullNameController.text = this._doctor.fullName;
            this._costController.text = this._doctor.cost.toString();
            this._addressController.text = this._doctor.clinicAddress;
            return Form(
              key: this._formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      ProfilePictureWidget(
                        imageUrl: state.doctor.imageUrl,
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
                  CustomFieldWidget(
                    textFieldController: this._costController,
                    label: "Cost",
                    validators: [
                      RequiredValidator(errorText: "Cost is required"),
                    ],
                    textInputType: TextInputType.number,
                  ),
                  CustomFieldWidget(
                    textFieldController: this._addressController,
                    label: "Clinic Address",
                    validators: [
                      RequiredValidator(errorText: "Address is required"),
                    ],
                    textInputType: TextInputType.streetAddress,
                  ),
                  Text(
                    'Your Job',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildJobs(state),
                  Text(
                    'Your Specialization',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildSpecialization(state),
                  ElevatedButton(
                    onPressed: this._onFormSubmit,
                    child: Text('Update Profile'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildJobs(DoctorProvider state) {
    return Flexible(
      fit: FlexFit.loose,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: Job.values
            .map(
              (job) => ListTile(
                title: Text(
                  job.toString().split(".")[1],
                ),
                leading: Radio(
                  value: job,
                  groupValue: this._doctor.jobTitle,
                  onChanged: (Job? jobValue) {
                    if (jobValue != null) {
                      this._doctor.jobTitle = jobValue;
                      state.doctor = this._doctor;
                    }
                  },
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildSpecialization(DoctorProvider state) {
    return Flexible(
      fit: FlexFit.loose,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: Specialization.values
            .map(
              (s) => ListTile(
                title: Text(
                  s.toString().split(".")[1],
                ),
                leading: Checkbox(
                  value: this._doctor.specializations.contains(s),
                  onChanged: (bool? value) {
                    if (value! == true) {
                      this._doctor.specializations.add(s);
                    } else {
                      this._doctor.specializations.remove(s);
                    }
                    state.doctor = this._doctor;
                  },
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
