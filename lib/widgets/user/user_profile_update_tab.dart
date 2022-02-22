import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/dtos/doctor/create_update_doctor.dto.dart';
import 'package:varenya_professionals/exceptions/auth/not_logged_in_exception.dart';
import 'package:varenya_professionals/exceptions/general.exception.dart';
import 'package:varenya_professionals/exceptions/server.exception.dart';
import 'package:varenya_professionals/models/doctor/doctor.model.dart';
import 'package:varenya_professionals/models/specialization/specialization.model.dart';
import 'package:varenya_professionals/providers/doctor.provider.dart';
import 'package:varenya_professionals/providers/user_provider.dart';
import 'package:varenya_professionals/services/doctor.service.dart';
import 'package:varenya_professionals/services/user_service.dart';
import 'package:varenya_professionals/utils/display_bottom_sheet.dart';
import 'package:varenya_professionals/utils/image_picker.dart';
import 'package:varenya_professionals/utils/logger.util.dart';
import 'package:varenya_professionals/utils/snackbar.dart';
import 'package:varenya_professionals/utils/upload_image_generate_url.dart';
import 'package:varenya_professionals/widgets/common/custom_field_widget.dart';
import 'package:varenya_professionals/widgets/common/loading_icon_button.widget.dart';
import 'package:varenya_professionals/widgets/common/profile_picture_widget.dart';
import 'package:varenya_professionals/widgets/doctor/job_selector.widget.dart';
import 'package:varenya_professionals/widgets/doctor/shift_selector.widget.dart';
import 'package:varenya_professionals/widgets/doctor/specialization_selector.widget.dart';

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
  late List<Specialization> _specializations;
  late String _job;

  bool _loading = false;

  @override
  void initState() {
    super.initState();

    // Initializing the user provider.
    this._userProvider = Provider.of<UserProvider>(context, listen: false);
    this._doctorProvider = Provider.of<DoctorProvider>(context, listen: false);
    this._userService = Provider.of<UserService>(context, listen: false);
    this._doctorService = Provider.of<DoctorService>(context, listen: false);

    this._doctor = this._doctorProvider.doctor;
    this._fullNameController.text = this._doctor.fullName;
    this._costController.text = this._doctor.cost.toString();
    this._addressController.text = this._doctor.clinicAddress;

    this._specializations = this._doctor.specializations;
    this._job = this._doctor.jobTitle;
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
    try {
      // Open the gallery and get the selected image.
      XFile? imageXFile = await openGallery();

      // Run if there is an image selected.
      if (imageXFile != null) {
        // Prepare the file from the selected image.
        File imageFile = new File(imageXFile.path);

        // Upload the image to firebase and generate a URL.
        String uploadedUrl =
            await uploadImageAndGenerateUrl(imageFile, "profile-pictures");

        CreateOrUpdateDoctorDto createOrUpdateDoctorDto =
            new CreateOrUpdateDoctorDto(
          fullName: this._doctor.fullName,
          imageUrl: uploadedUrl,
          jobTitle: this._doctor.jobTitle,
          clinicAddress: this._doctor.clinicAddress,
          cost: this._doctor.cost,
          specializations: this
              ._doctor
              .specializations
              .map((s) => s.specialization)
              .toList(),
          shiftStartTime: this._doctor.shiftStartTime,
          shiftEndTime: this._doctor.shiftEndTime,
        );

        Doctor updatedDoctor =
            await this._doctorService.updateDoctor(createOrUpdateDoctorDto);

        this._doctorProvider.doctor = updatedDoctor;

        setState(() {
          this._doctor = updatedDoctor;
        });

        // Update the user details
        User user = await this._userService.updateProfilePicture(uploadedUrl);
        //
        // Save the updated state.
        this._userProvider.user = user;

        // Display a success snackbar.
        displaySnackbar(
          "Profile picture updated!",
          context,
        );
      }
    }
    // Handle errors gracefully.
    on NotLoggedInException catch (error) {
      displaySnackbar(error.message, context);
    } on GeneralException catch (error) {
      displaySnackbar(error.message, context);
    } on ServerException catch (error) {
      displaySnackbar(error.message, context);
    } catch (error, stackTrace) {
      log.e("UserProfileUpdateTab:_uploadFromGallery", error, stackTrace);
      displaySnackbar("Something went wrong, please try again later", context);
    }
  }

  /*
   * Method for uploading images from camera.
   */
  Future<void> _uploadFromCamera() async {
    try {
      // Open the gallery and get the selected image.
      XFile? imageXFile = await openCamera();

      // Run if there is an image selected.
      if (imageXFile != null) {
        // Prepare the file from the selected image.
        File imageFile = new File(imageXFile.path);

        // Upload the image to firebase and generate a URL.
        String uploadedUrl =
            await uploadImageAndGenerateUrl(imageFile, "profile-pictures");

        CreateOrUpdateDoctorDto createOrUpdateDoctorDto =
            new CreateOrUpdateDoctorDto(
          fullName: this._doctor.fullName,
          imageUrl: uploadedUrl,
          jobTitle: this._doctor.jobTitle,
          clinicAddress: this._doctor.clinicAddress,
          cost: this._doctor.cost,
          specializations: this
              ._doctor
              .specializations
              .map((s) => s.specialization)
              .toList(),
          shiftStartTime: this._doctor.shiftStartTime,
          shiftEndTime: this._doctor.shiftEndTime,
        );

        Doctor updatedDoctor =
            await this._doctorService.updateDoctor(createOrUpdateDoctorDto);

        this._doctorProvider.doctor = updatedDoctor;

        setState(() {
          this._doctor = updatedDoctor;
        });

        // Update the user details
        User user = await this._userService.updateProfilePicture(uploadedUrl);
        //
        // Save the updated state.
        this._userProvider.user = user;

        // Display a success snackbar.
        displaySnackbar(
          "Profile picture updated!",
          context,
        );
      }
    }
    // Handle errors gracefully.
    on NotLoggedInException catch (error) {
      displaySnackbar(error.message, context);
    } on GeneralException catch (error) {
      displaySnackbar(error.message, context);
    } on ServerException catch (error) {
      displaySnackbar(error.message, context);
    } catch (error, stackTrace) {
      log.e("UserProfileUpdateTab:_uploadFromCamera", error, stackTrace);
      displaySnackbar("Something went wrong, please try again later", context);
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
        setState(() {
          this._loading = true;
        });

        // Update it on server and also update the state as well.
        User user = await this
            ._userService
            .updateFullName(this._fullNameController.text);

        this._userProvider.user = user;

        CreateOrUpdateDoctorDto createOrUpdateDoctorDto =
            new CreateOrUpdateDoctorDto(
          fullName: this._fullNameController.text,
          imageUrl: this._doctor.imageUrl,
          jobTitle: this._job,
          clinicAddress: this._addressController.text,
          cost: double.parse(this._costController.text),
          specializations:
              this._specializations.map((e) => e.specialization).toList(),
          shiftStartTime: this._doctor.shiftStartTime,
          shiftEndTime: this._doctor.shiftEndTime,
        );

        Doctor updatedDoctor =
            await this._doctorService.updateDoctor(createOrUpdateDoctorDto);

        this._doctorProvider.doctor = updatedDoctor;

        setState(() {
          this._doctor = updatedDoctor;
          this._specializations = this._doctor.specializations;
          this._job = this._doctor.jobTitle;
        });

        // Display success snackbar.
        displaySnackbar("Your profile has been updated!", context);
      }
    }
    // Handle errors gracefully.
    on NotLoggedInException catch (error) {
      displaySnackbar(error.message, context);
    } on GeneralException catch (error) {
      displaySnackbar(error.message, context);
    } catch (error, stackTrace) {
      log.e("UserProfileUpdateTab:_onFormSubmit", error, stackTrace);
      displaySnackbar("Something went wrong, please try again later", context);
    }

    setState(() {
      this._loading = false;
    });
  }

  void _setShiftStartTime() async {
    TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(this._doctor.shiftStartTime),
    );

    if (timeOfDay != null) {
      DateTime dateTime = new DateTime(
        2000,
        1,
        1,
        timeOfDay.hour,
        timeOfDay.minute,
      );

      setState(() {
        this._doctor.shiftStartTime = dateTime;
      });
    }
  }

  void _setShiftEndTime() async {
    TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(this._doctor.shiftEndTime),
    );

    if (timeOfDay != null) {
      DateTime dateTime = new DateTime(
        2000,
        1,
        1,
        timeOfDay.hour,
        timeOfDay.minute,
      );

      setState(() {
        this._doctor.shiftEndTime = dateTime;
      });
    }
  }

  void _addOrRemoveSpecialization(Specialization specialization) {
    bool check = this
        ._specializations
        .where((element) => element.id == specialization.id)
        .isNotEmpty;

    if (check) {
      setState(() {
        this
            ._specializations
            .removeWhere((element) => element.id == specialization.id);
      });
    } else {
      setState(() {
        this._specializations.add(specialization);
      });

      return;
    }
  }

  void _addOrRemoveJob(String job) {
    setState(() {
      this._job = job;
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  ProfilePictureWidget(
                    imageUrl: this._doctor.imageUrl,
                    size: MediaQuery.of(context).size.height * 0.3,
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
                label: "Name",
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
              JobSelector(
                job: this._job,
                addOrRemoveJob: this._addOrRemoveJob,
              ),
              SpecializationSelector(
                selectedSpecializations: this._specializations,
                addOrRemoveSpecialization: this._addOrRemoveSpecialization,
              ),
              ShiftSelector(
                startTime: this._doctor.shiftStartTime,
                endTime: this._doctor.shiftEndTime,
                onShiftStartSelect: this._setShiftStartTime,
                onShiftEndSelect: this._setShiftEndTime,
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
                          text: 'Update Profile',
                          loadingText: 'Updating',
                        )
                      : LoadingIconButton(
                          connected: false,
                          loading: this._loading,
                          onFormSubmit: this._onFormSubmit,
                          text: 'Update Profile',
                          loadingText: 'Updating',
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
