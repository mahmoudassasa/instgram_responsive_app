import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instgram_responsive_app/screens/profile.dart';
import 'package:instgram_responsive_app/shared/colors.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final searchController = TextEditingController();

  showUser() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    searchController.addListener(showUser);
  }

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mobileBackgroundColor,
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: TextFormField(
            // onChanged: (value) {
            //   setState(() {});
            // },
            controller: searchController,
            decoration:
                const InputDecoration(labelText: 'Search for a user...'),
          ),
        ),
        body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('users')
              .where("username", isEqualTo: searchController.text)
              .get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return const Text("Something went wrong");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                      onTap: () { Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Profile(userUID: snapshot.data!.docs[index]["uid"],
                                  
                                  )),
                        );},
                      title: Text(
                          // "Osama"
                          snapshot.data!.docs[index]["username"]),
                      leading: CircleAvatar(
                        radius: 33,
                        backgroundImage: NetworkImage(
                            // "https://i.pinimg.com/564x/94/df/a7/94dfa775f1bad7d81aa9898323f6f359.jpg"
                            snapshot.data!.docs[index]["profileImage"]),
                      ));
                },
              );
            }

            return const Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            ));
          },
        ));
  }
}
