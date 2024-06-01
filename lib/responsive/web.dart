import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instgram_responsive_app/screens/add_post.dart';
import 'package:instgram_responsive_app/screens/home.dart';
import 'package:instgram_responsive_app/screens/liked.dart';
import 'package:instgram_responsive_app/screens/profile.dart';
import 'package:instgram_responsive_app/screens/search.dart';
import 'package:instgram_responsive_app/shared/colors.dart';

class WebScreen extends StatefulWidget {
  const WebScreen({super.key});

  @override
  State<WebScreen> createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {
//This is page controller
  final PageController _pageController = PageController();
  int currentPage = 0;

  navigateToScreen(int index) {
    setState(() {
      // navigate to the tabed page
      _pageController.jumpToPage(index);
      currentPage = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        actions: [
          IconButton(
            icon: Icon(
              Icons.home,
              color: currentPage == 0 ? primaryColor : secondaryColor,
            ),
            onPressed: () {
              navigateToScreen(0);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              color: currentPage == 1 ? primaryColor : secondaryColor,
            ),
            onPressed: () {
              navigateToScreen(1);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.add_circle,
              color: currentPage == 2 ? primaryColor : secondaryColor,
            ),
            onPressed: () {
              navigateToScreen(2);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: currentPage == 3 ? primaryColor : secondaryColor,
            ),
            onPressed: () {
              navigateToScreen(3);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.person,
              color: currentPage == 4 ? primaryColor : secondaryColor,
            ),
            onPressed: () {
              navigateToScreen(4);
            },
          ),
        ],
        title: SvgPicture.asset(
          "assets/img/instagram.svg",
          // ignore: deprecated_member_use
          color: primaryColor,
          height: 32,
        ),
      ),
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
