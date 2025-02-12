import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

getImageURL({required String imgName, required Uint8List imgPath,required folderName}) async {
// Upload image to firebase storage
  final storageRef = FirebaseStorage.instance.ref("$folderName/$imgName");
  // use this code if u are using flutter web
  UploadTask uploadTask = storageRef.putData(imgPath);
  TaskSnapshot snap = await uploadTask;

// Get img url
  String imgUrl = await snap.ref.getDownloadURL();
  return imgUrl;
}
