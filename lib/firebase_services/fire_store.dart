

// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:instgram_responsive_app/firebase_services/storage.dart';
import 'package:instgram_responsive_app/models/posts.dart';
import 'package:instgram_responsive_app/shared/snack_bar.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  uploadPostsData({
    required imgName,
    required imgPath,
    required description,
    required profileImage,
    required username,
    required context,
  }) async {
    String message = "ERROR => Not starting the code";

    try {
      String imgUrll = await getImageURL(
          imgName: imgName,
          imgPath: imgPath,
          folderName:
              'UserPosstsImages/${FirebaseAuth.instance.currentUser!.uid}');
// firebase firestore (Database)
      CollectionReference posts =
          FirebaseFirestore.instance.collection('posts');
      //For Randome ID

      String RandomeID = const Uuid().v1();
      PostsData alldata = PostsData(
        datePublished: DateTime.now(),
        description: description,
        imgPost: imgUrll,
        likes: [],
        profileImage: profileImage,
        //For Randome ID
        postId: RandomeID,
        uid: FirebaseAuth.instance.currentUser!.uid,
        username: username,
      );

      posts
          .doc(RandomeID)
          .set(alldata.convert2Map())
          .then((value) => showSnackBar(context, "Post Added"))
          .catchError((error) => showSnackBar(context,"Failed to add Post: $error"));

      message = " Posted Successfully ♥";
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, "ERROR :  ${e.code} ");
    } catch (e) {
      showSnackBar(context, '$e');
    }

    showSnackBar(context, message);
  }

  makeComments(
      {required commentText,
      required postId,
      required profileImg,
      required username,
      required uid}) async {
    if (commentText.isNotEmpty) {
      String commentId = const Uuid().v1();
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .set({
        "profileImage": profileImg,
        "username": username,
        "textComment": commentText,
        "datePublished": DateTime.now(),
        "uid": uid,
        "commentId": commentId
      });

      // Center(
      //   child: CircularProgressIndicator(
      //     color: Colors.white,
      //   ),
      // );
      // SnackBar(content: Text("Done ♥"));
    }
  }

  preesedOnLike({required Map PostData}) async {
    try {
      if (PostData["likes"].contains(FirebaseAuth.instance.currentUser!.uid)) {
      //current DataState =  Liked
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(PostData['postId'])
          .update({
        "likes":
            FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
      });
    } else {
      //current DataState =  Liked
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(PostData['postId'])
          .update({
        "likes": FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
      });
    }
    } catch (e) {
      showSnackBar( context as BuildContext, "$e");
    }
  }
}
