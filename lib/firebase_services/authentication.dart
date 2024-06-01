
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instgram_responsive_app/firebase_services/storage.dart';
import 'package:instgram_responsive_app/models/users_data.dart';
import 'package:instgram_responsive_app/shared/snack_bar.dart';

class AuthenticationMethod {
  register({
    required email,
    required password,
    required context,
    required dusername,
    required dtitle,
    required imgPath,
    required imgName,

  }) async {
    String message = "ERROR => Not starting the code";

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      message = "ERROR => Registered only";

      String imgUrll = await getImageURL(imgName: imgName, imgPath: imgPath, folderName: 'UserProfileImages');
// firebase firestore (Database)
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      UsersData alldata = UsersData(
        email: email,
        username: dusername,
        title: dtitle,
        password: password,
        profileImage: imgUrll,
        uid: credential.user!.uid,
        followers:[],
        following:[],
      );

      users
          .doc(credential.user!.uid)
          .set(alldata.convert2Map())
          .then((value) => showSnackBar(context, 'User Added'))
          .catchError((error) => showSnackBar(context, "Failed to add user: $error"));

      message = " Registered & User Added 2 DB ♥";
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, "ERROR :  ${e.code} ");
    } catch (e) {
      showSnackBar(context, "$e");
    }

    showSnackBar(context, message);
  }

  signIn({
    required logInemailAddress,
    required logInpassword,
    required context,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: logInemailAddress, password: logInpassword);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, "ERROR :  ${e.code} ");
    } catch (e) {
      showSnackBar(context, '$e');
    }
  }
 // functoin to get user details from Firestore (Database)
Future<UsersData> getUserDetails() async {
   DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get(); 
   return UsersData.convertSnap2Model(snap);
 }





}
