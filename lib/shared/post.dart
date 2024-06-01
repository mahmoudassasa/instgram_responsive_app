import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instgram_responsive_app/firebase_services/fire_store.dart';
import 'package:instgram_responsive_app/screens/comments.dart';
import 'package:instgram_responsive_app/shared/colors.dart';
import 'package:instgram_responsive_app/shared/heart_animation.dart';
import 'package:instgram_responsive_app/shared/snack_bar.dart';
import 'package:intl/intl.dart';

class RepeatPost extends StatefulWidget {
  const RepeatPost({super.key, required this.data});

  @override
  State<RepeatPost> createState() => _RepeatPostState();
//current post
  final Map data;
}

class _RepeatPostState extends State<RepeatPost> {
  int commentCount = 0;
  int likesCount = 0;
  bool showHeart = false;
  bool isLikeAnimating = false;

  getCommentsCount() async {
    try {
      QuerySnapshot commentsData = await FirebaseFirestore.instance
          .collection("posts")
          .doc(widget.data['postId'])
          .collection('comments')
          .get();
      setState(() {
        //converted to List
        commentCount = commentsData.docs.length;
      });
    } catch (e) {
      if (!context.mounted) return;
      showSnackBar(context, "e");
    }
  }

  showmodel() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: [
            FirebaseAuth.instance.currentUser!.uid == widget.data['uid']
                ? SimpleDialogOption(
                    onPressed: () async {
                      Navigator.of(context).pop();

                      await FirebaseFirestore.instance
                          .collection('posts')
                          .doc(widget.data['postId'])
                          //to  delete the comments
                          .delete();
                    },
                    padding: const EdgeInsets.all(20),
                    child: const Text(
                      "Delete Post",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  )
                : const SimpleDialogOption(
                    // onPressed: () async {
                    //   Navigator.of(context).pop();
                    // },
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "You Can't Delete This Post ✋",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
            SimpleDialogOption(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              padding: const EdgeInsets.all(20),
              child: const Text(
                "Cancel",
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

  onTapHeartEffect() async {
    setState(() {
      isLikeAnimating = true;
    });
    await FirebaseFirestore.instance
        .collection("posts")
        .doc(widget.data['postId'])
        .update({
      "likes": FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
    });
  }

  @override
  void initState() {
    super.initState();
    getCommentsCount();
  }

  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
          color: mobileBackgroundColor,
          borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(
          vertical: 11, horizontal: widthScreen > 600 ? widthScreen / 6 : 0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(125, 78, 91, 110),
                      ),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          // "https://images.unsplash.com/photo-1602233158242-3ba0ac4d2167?q=80&w=1472&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
                          widget.data["profileImage"],
                        ),
                        radius: 36,
                      ),
                    ),
                    const SizedBox(
                      width: 17,
                    ),
                    Text(
                      // "Mazen Galal",
                      widget.data["username"].toString(),
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                IconButton(
                    onPressed: () async {
                      showmodel();

                      //  await showSnackBar(context, 'Post Successfully Deleted ♥');
                    },
                    icon: const Icon(Icons.more_vert_rounded))
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await onTapHeartEffect();
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  // widget.snap["postUrl"],
                  // "https://cdn1-m.alittihad.ae/store/archive/image/2021/10/22/6266a092-72dd-4a2f-82a4-d22ed9d2cc59.jpg?width=1300",
                  widget.data["imgPost"],

                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  loadingBuilder: (context, child, progress) {
                    return progress == null
                        ? child
                        : SizedBox(
                            height: MediaQuery.of(context).size.height * 0.45,
                            child: const Center(
                                child: CircularProgressIndicator(
                              color: Colors.white,
                            )));
                  },
                ),
                // big_heart_animation_widget
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(
                      milliseconds: 400,
                    ),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 111,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 11),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    LikeAnimation(
                      isAnimating: widget.data['likes']
                          .contains(FirebaseAuth.instance.currentUser!.uid),
                      smallLike: true,
                      child: IconButton(
                        onPressed: () async {
                          await FirestoreMethods()
                              .preesedOnLike(PostData: widget.data);
                        },
                        icon: widget.data['likes'].contains(
                                FirebaseAuth.instance.currentUser!.uid)
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.favorite_border,
                              ),
                      ),
                    ),
                    // IconButton(
                    //     onPressed: () async {
                    //       await FirestoreMethods()
                    //           .preesedOnLike(PostData: widget.data);
                    //     },
                    //     icon: widget.data["likes"].contains(
                    //             FirebaseAuth.instance.currentUser!.uid)
                    //         ? const Icon(
                    //             Icons.favorite,
                    //             color: Colors.red,
                    //           )
                    //         : const Icon(Icons.favorite_border)),

                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CommentsScreen(
                                        data: widget.data,
                                        showCommentsField: true,
                                      )));
                        },
                        icon: const Icon(Icons.comment_outlined)),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.send)),
                  ],
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.bookmark_border_rounded)),
              ],
            ),
          ),
          Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 0, 10),
              width: double.infinity,
              child: Text(
                "${widget.data["likes"].length} ${widget.data["likes"].length > 1 ? "Like" : "Likes"}",
                textAlign: TextAlign.start,
                style: const TextStyle(
                    fontSize: 18, color: Color.fromARGB(214, 157, 157, 165)),
              )),
          Row(
            children: [
              const SizedBox(
                width: 9,
              ),
              Text(
                // "${widget.snap["username"]}",
                widget.data["username"].toString(),
                textAlign: TextAlign.start,
                style: const TextStyle(
                    fontSize: 20, color: Color.fromARGB(255, 189, 196, 199)),
              ),
              const SizedBox(
                width: 12,
              ),
              Text(
                // " ${widget.snap["description"]}",
                widget.data["description"].toString(),
                textAlign: TextAlign.start,
                style: const TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 189, 196, 199)),
              ),
            ],
          ),
          //like GestureDetector but less of widgets
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CommentsScreen(
                            data: widget.data,
                            showCommentsField: false,
                          )));
            },
            child: Container(
                margin: const EdgeInsets.fromLTRB(10, 13, 9, 10),
                width: double.infinity,
                child: Text(
                  "view all $commentCount comments",
                  style: const TextStyle(
                      fontSize: 18, color: Color.fromARGB(214, 157, 157, 165)),
                  textAlign: TextAlign.start,
                )),
          ),
          Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 9, 10),
              width: double.infinity,
              child: Text(
                DateFormat('MMM d, ' 'y')
                    .format(widget.data["datePublished"].toDate()),
                style: const TextStyle(
                    fontSize: 18, color: Color.fromARGB(214, 157, 157, 165)),
                textAlign: TextAlign.start,
              )),
        ],
      ),
    );
  }

  
}
