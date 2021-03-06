import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:varenya_professionals/enum/post_type.enum.dart';
import 'package:varenya_professionals/enum/roles.enum.dart';
import 'package:varenya_professionals/models/appointment/appointment/appointment.model.dart';
import 'package:varenya_professionals/models/appointment/doctor_appointment_response/doctor_appointment_response.model.dart';
import 'package:varenya_professionals/models/doctor/doctor.model.dart';
import 'package:varenya_professionals/models/patient/patient.model.dart';
import 'package:varenya_professionals/models/post/post_category/post_category.model.dart';
import 'package:varenya_professionals/models/post/post_image/post_image.model.dart';
import 'package:varenya_professionals/models/server_user/random_name/random_name.model.dart';
import 'package:varenya_professionals/models/server_user/server_user.model.dart';
import 'package:varenya_professionals/utils/logger.util.dart';

import 'constants/hive_boxes.constant.dart';
import 'models/post/post.model.dart';
import 'models/specialization/specialization.model.dart';

Future<void> openHiveBoxes() async {
  await Hive.openBox<List<dynamic>>(VARENYA_DOCTORS_BOX);
  await Hive.openBox<Doctor>(VARENYA_LOGGED_IN_DOCTOR_BOX);
  await Hive.openBox<List<dynamic>>(VARENYA_POSTS_BOX);
  await Hive.openBox<List<dynamic>>(VARENYA_POST_CATEGORY_BOX);
  await Hive.openBox<List<dynamic>>(VARENYA_APPOINTMENT_BOX);
  await Hive.openBox<List<dynamic>>(VARENYA_SPECIALIZATION_BOX);
  await Hive.openBox<List<dynamic>>(VARENYA_JOB_BOX);
  await Hive.openBox<List<dynamic>>(VARENYA_PATIENT_RECORD_BOX);
}

void registerHiveAdapters() {
  Hive.registerAdapter<Specialization>(new SpecializationAdapter());
  Hive.registerAdapter<Doctor>(new DoctorAdapter());
  Hive.registerAdapter<RandomName>(new RandomNameAdapter());
  Hive.registerAdapter<Roles>(new RolesAdapter());
  Hive.registerAdapter<ServerUser>(new ServerUserAdapter());
  Hive.registerAdapter<Appointment>(new AppointmentAdapter());
  Hive.registerAdapter<Patient>(new PatientAdapter());
  Hive.registerAdapter<DoctorAppointmentResponse>(
      new DoctorAppointmentResponseAdapter());
  Hive.registerAdapter<PostImage>(new PostImageAdapter());
  Hive.registerAdapter<PostCategory>(new PostCategoryAdapter());
  Hive.registerAdapter<PostType>(new PostTypeAdapter());
  Hive.registerAdapter<Post>(new PostAdapter());
}

Future<void> registerFCMService() async {
  NotificationSettings settings =
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  log.i("FCM Authorization Status: ${settings.authorizationStatus}");
}

Future<void> fullSetup() async {
  log.i("Firebase and Hive Initializing");

  await Firebase.initializeApp();
  await Hive.initFlutter();

  log.i("Firebase and Hive Initialized");

  log.i("Registering Hive Adapters");

  registerHiveAdapters();

  log.i("Registered Hive Adapters");

  log.i("Opening Hive Boxes");

  await openHiveBoxes();

  log.i("Opened Hive Boxes");

  await registerFCMService();
}