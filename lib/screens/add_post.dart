import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instgram_responsive_app/firebase_services/fire_store.dart';
import 'package:instgram_responsive_app/provider/user_provider.dart';

import 'package:instgram_responsive_app/shared/colors.dart';
import 'package:instgram_responsive_app/shared/snack_bar.dart';
import 'dart:math';
import 'dart:typed_data';

import 'package:path/path.dart' show basename;
import 'package:provider/provider.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  //for web & mobile file bath
  Uint8List? imgPath;

  String? imgName;
  bool isLoading = false;
  final descriptionController = TextEditingController();

  // showmodel() {
  //   return showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Container(
  //         padding: const EdgeInsets.all(22),
  //         height: 170,
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             GestureDetector(
  //               onTap: () async {
  //                 await uploadImage2Screen(ImageSource.camera);
  //               },
  //               child: const Row(
  //                 children: [
  //                   Icon(
  //                     Icons.camera,
  //                     size: 30,
  //                   ),
  //                   SizedBox(
  //                     width: 11,
  //                   ),
  //                   Text(
  //                     "From Camera",
  //                     style: TextStyle(fontSize: 20),
  //                   )
  //                 ],
  //               ),
  //             ),
  //             const SizedBox(
  //               height: 22,
  //             ),
  //             GestureDetector(
  //               onTap: () {
  //                 uploadImage2Screen(ImageSource.gallery);
  //               },
  //               child: const Row(
  //                 children: [
  //                   Icon(
  //                     Icons.photo_outlined,
  //                     size: 30,
  //                   ),
  //                   SizedBox(
  //                     width: 11,
  //                   ),
  //                   Text(
  //                     "From Gallery",
  //                     style: TextStyle(fontSize: 20),
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
  showmodel() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: [
            SimpleDialogOption(
              onPressed: () async {
                // Navigator.of(context).pop();
                await uploadImage2Screen(ImageSource.camera);
              },
              padding: const EdgeInsets.all(20),
              child: const Text(
                "From Camera",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            SimpleDialogOption(
              onPressed: () async {
                // Navigator.of(context).pop();
                await uploadImage2Screen(ImageSource.gallery);
              },
              padding: const EdgeInsets.all(20),
              child: const Text(
                "From Gallary",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  uploadImage2Screen(ImageSource source) async {
    Navigator.pop(context);

    final XFile? pickedImg = await ImagePicker().pickImage(source: source);
    try {
      if (pickedImg != null) {
        imgPath = await pickedImg.readAsBytes();
        setState(() {
          //  imgPath = File(pickedImg.path);
          imgName = basename(pickedImg.path);
          int random = Random().nextInt(9999999);
          imgName = "$random$imgName";
          showSnackBar(context, "$imgName");
        });
      } else {
        if (!context.mounted) return;
        showSnackBar(context,"NO img selected");
      }
    } catch (e) {
      if (!context.mounted) return;
      showSnackBar(context,"Error => $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final allDataFromDB = Provider.of<UserProvider>(context).getUser;

    return imgPath == null
        ? Scaffold(
            backgroundColor: mobileBackgroundColor,
            body: Center(
              child: IconButton(
                  onPressed: () {
                    showmodel();
                  },
                  icon: const Icon(
                    Icons.upload,
                    size: 55,
                  )),
            ))
        : Scaffold(
            backgroundColor: mobileBackgroundColor,
            appBar: AppBar(
              actions: [
                TextButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });

                      await FirestoreMethods().uploadPostsData(
                          imgName: imgName,
                          imgPath: imgPath,
                          description: descriptionController.text,
                          profileImage: allDataFromDB!.profileImage,
                          username: allDataFromDB.username,
                          context: context);

                      setState(() {
                        isLoading = false;
                        imgPath = null;
                      });
                    },
                    child: const Text(
                      "Post",
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 19,
                          fontWeight: FontWeight.bold),
                    )),
              ],
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                  onPressed: () {
                    setState(() {
                      imgPath = null;
                    });
                  },
                  icon: const Icon(Icons.arrow_back)),
            ),
            body: Column(
              children: [
                isLoading
                    ? const LinearProgressIndicator(
                        color: Colors.blue,
                      )
                    : const Divider(
                        thickness: 1,
                        height: 30,
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(125, 78, 91, 110),
                      ),
                      child: CircleAvatar(
                        radius: 33,
                        backgroundImage: NetworkImage(
                            allDataFromDB!.profileImage

                            //  "https://static-ai.asianetnews.com/images/01e42s5h7kpdte5t1q9d0ygvf7/1-jpeg.jpg"

                            ),

                        // MemoryImage(imgPath!),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextField(
                        controller: descriptionController,
                        maxLines: 8,
                        decoration: const InputDecoration(
                            hintText: "write a caption...",
                            border: InputBorder.none),
                      ),
                    ),
                    Container(
                      width: 66,
                      height: 74,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: MemoryImage(imgPath!), fit: BoxFit.cover)),
                    )
                  ],
                ),
              ],
            ),
          );
  }
}
