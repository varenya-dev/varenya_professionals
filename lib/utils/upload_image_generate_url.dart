import 'dart:io';

import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<String> uploadImageAndGenerateUrl(
  File imageFile,
  String folderName,
) async {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  Uuid uuid = new Uuid();

  String imageUuid = uuid.v4();

  await firebaseStorage.ref("$folderName/$imageUuid.png").putFile(imageFile);

  return await firebaseStorage
      .ref("$folderName/$imageUuid.png")
      .getDownloadURL();
}
