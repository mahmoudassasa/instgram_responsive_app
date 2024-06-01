import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instgram_responsive_app/screens/add_post.dart';
import 'package:instgram_responsive_app/screens/home.dart';
import 'package:instgram_responsive_app/screens/liked.dart';
import 'package:instgram_responsive_app/screens/profile.dart';
import 'package:instgram_responsive_app/screens/search.dart';
import 'package:instgram_responsive_app/shared/colors.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({super.key});

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  //This is page controller
  final PageController _pageController = PageController();
  int currentPage = 0;
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   //backgroundColor: Colors.blue,
      //   title: const Text(
      //     "mobile screen",
      //     //  style: TextStyle(color: Colors.white),
      //   ),
      // ),

      bottomNavigationBar: CupertinoTabBar(
          onTap: (index) {
            // navigate to the tabed page
            _pageController.jumpToPage(index);
            setState(() {
              currentPage = index;
            });
          },
          backgroundColor: mobileBackgroundColor,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: currentPage == 0 ? primaryColor : secondaryColor,
                ),
                label: ""),
             BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                  color: currentPage == 1 ? primaryColor : secondaryColor,
                ),
                label: ""),
             BottomNavigationBarItem(
                icon: Icon(
                  Icons.add_circle,
                  color: currentPage == 2 ? primaryColor : secondaryColor,
                ),
                label: ""),
             BottomNavigationBarItem(
                icon: Icon(
                  Icons.favorite,
                  color: currentPage == 3 ? primaryColor : secondaryColor,
                ),
                label: ""),
             BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_circle,
                  color: currentPage == 4 ? primaryColor : secondaryColor,
                ),
                label: ""),
          ]),
      body: PageView(
          onPageChanged: (index) {},
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children:  [
            const Home(),
            const Search(),
            const AddPost(),
            const Liked(),
            Profile(userUID: FirebaseAuth.instance.currentUser!.uid,),
          ]),
    );
  }
}
