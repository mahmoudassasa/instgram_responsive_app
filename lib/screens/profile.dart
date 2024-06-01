import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instgram_responsive_app/shared/colors.dart';
import 'package:instgram_responsive_app/shared/snack_bar.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.userUID});
  final String userUID;
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map userData = {};
  bool isLoading = true;

  late int followers;
  late int following;
  late int postsCount;
  late bool followState;
  getData() async {
//Get Data from DB
    setState(() {
      isLoading = true;
    });
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(widget.userUID)
          .get();
      //converted to Map
      userData = snapshot.data()!;

      followers = userData["followers"].length;
      following = userData["following"].length;
      //check follow state
      followState = userData["followers"]
          .contains(FirebaseAuth.instance.currentUser!.uid);

      //to get posts length
      var snapshotPosts = await FirebaseFirestore.instance
          .collection('posts')
          .where("uid", isEqualTo: widget.userUID)
          .get();
      postsCount = snapshotPosts.docs.length;
    } catch (e) {
      if (!context.mounted) return;
      showSnackBar(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;

    return isLoading
        ? const Scaffold(
            backgroundColor: mobileBackgroundColor,
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ))
        : Scaffold(
            backgroundColor: mobileBackgroundColor,
            appBar: AppBar(
                backgroundColor: mobileBackgroundColor,
                title: Text(
                  userData["username"],
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.start,
                )),
            body: Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 22),
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(125, 78, 91, 110),
                      ),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                            // widget.snap["profileImg"],
                            // "https://i.pinimg.com/564x/94/df/a7/94dfa775f1bad7d81aa9898323f6f359.jpg"

                            userData["profileImage"]),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                postsCount.toString(),
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text(
                                "Posts",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 17,
                          ),
                          Column(
                            children: [
                              Text(
                                following.toString(),
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text(
                                "Following",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 17,
                          ),
                          Column(
                            children: [
                              Text(
                                followers.toString(),
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text(
                                "Followers",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(33, 21, 0, 0),
                  width: double.infinity,
                  child: Text(
                    userData["title"],
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Divider(
                  color: Colors.white,
                  thickness: widthScreen > 600 ? 0.08 : 0.44,
                ),
                const SizedBox(
                  height: 9,
                ),

                // _________________________________________________________________________________________
                widget.userUID == FirebaseAuth.instance.currentUser!.uid
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.grey,
                              size: 24.0,
                            ),
                            label: const Text(
                              "Edit Profile",
                              style: TextStyle(fontSize: 17),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(0, 90, 103, 223)),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      vertical: widthScreen > 600 ? 19 : 10,
                                      horizontal: 33)),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                  side: const BorderSide(
                                      color: Color.fromARGB(109, 255, 255, 255),
                                      // width: 1,
                                      style: BorderStyle.solid),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.logout,
                              size: 24.0,
                            ),
                            label: const Text(
                              "Logout",
                              style: TextStyle(fontSize: 17),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(143, 255, 55, 112)),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      vertical: widthScreen > 600 ? 19 : 10,
                                      horizontal: 33)),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : followState
                        ? ElevatedButton(
                            onPressed: () async {
                              followers--;
                              setState(() {
                                followState = false;
                              });
                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(widget.userUID)
                                  .update({
                                "followers": FieldValue.arrayRemove(
                                    [FirebaseAuth.instance.currentUser!.uid])
                              });
                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .update({
                                "following":
                                    FieldValue.arrayRemove([widget.userUID])
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(143, 255, 55, 112)),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      vertical: 9, horizontal: 66)),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                              ),
                            ),
                            child: const Text(
                              "unfollow",
                              style: TextStyle(fontSize: 17),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              followers++;
                              setState(() {
                                followState = true;
                              });
                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(widget.userUID)
                                  .update({
                                "followers": FieldValue.arrayUnion(
                                    [FirebaseAuth.instance.currentUser!.uid])
                              });
                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .update({
                                "following":
                                    FieldValue.arrayUnion([widget.userUID])
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(blueColor),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      vertical: 9, horizontal: 77)),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                              ),
                            ),
                            child: const Text(
                              "Follow",
                              style:
                                  TextStyle(fontSize: 17, color: Colors.white),
                            ),
                          ),

                // _________________________________________________________________________________________

                const SizedBox(
                  height: 9,
                ),
                Divider(
                  color: Colors.white,
                  thickness: widthScreen > 600 ? 0.08 : 0.44,
                ),
                const SizedBox(
                  height: 19,
                ),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where("uid", isEqualTo: widget.userUID)
                      .get(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError) {
                      return const Text("Something went wrong");
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      return Expanded(
                          child: Padding(
                        padding: widthScreen > 600
                            ? const EdgeInsets.all(10.0)
                            : const EdgeInsets.all(3.0),
                        child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 3 / 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.network(
                                    snapshot.data!.docs[index]["imgPost"],
                                    // "https://cdn1-m.alittihad.ae/store/archive/image/2021/10/22/6266a092-72dd-4a2f-82a4-d22ed9d2cc59.jpg?width=1300",
                                    // height: 333,
                                    // width: 100,

                                    fit: BoxFit.cover,
loadingBuilder: (context, child, progress){
   return progress == null
       ? child
       : const Center(child: CircularProgressIndicator(color: Colors.white,));
},
                                    
                                    
                                  ));
                            }),
                      ));
                    }

                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.white,
                    ));
                  },
                )
              ],
            ),
          );
  }
}
