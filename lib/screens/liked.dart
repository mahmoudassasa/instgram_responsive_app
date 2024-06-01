import 'package:flutter/material.dart';
import 'package:instgram_responsive_app/shared/colors.dart';

class Liked extends StatefulWidget {
  const Liked({super.key});

  @override
  State<Liked> createState() => _LikedState();
}

class _LikedState extends State<Liked> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: mobileBackgroundColor,
        body: Center(
          child:  Text("Liked ❤️",style:TextStyle(fontSize: 40) ,)
        ));
  }
}
