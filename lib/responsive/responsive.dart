

import 'package:flutter/material.dart';
import 'package:instgram_responsive_app/provider/user_provider.dart';
import 'package:instgram_responsive_app/responsive/mobile.dart';
import 'package:instgram_responsive_app/responsive/web.dart';
import 'package:provider/provider.dart';

class Responsive extends StatefulWidget {
  const Responsive(
      {super.key, required this.myMobileScreen, required this.myWebScreen});

  @override
  State<Responsive> createState() => _ResponsiveState();

  final MobileScreen myMobileScreen;
  final WebScreen myWebScreen;
}

class _ResponsiveState extends State<Responsive> {


  // To get data from DB using provider
 getDataFromDB() async {
 UserProvider userProvider = Provider.of(context, listen: false);
 await userProvider.refreshUser();
 }
 
 
 @override
 void initState() {
    super.initState();
    getDataFromDB();
 }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext buildContext , BoxConstraints boxConstraints) {
        if (boxConstraints.maxWidth > 600) {
          return widget.myWebScreen;
        } else {
          return widget.myMobileScreen;
        }
      },
    );
  }
}
