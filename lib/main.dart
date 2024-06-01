import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instgram_responsive_app/firebase_options.dart';
import 'package:instgram_responsive_app/provider/user_provider.dart';
import 'package:instgram_responsive_app/responsive/mobile.dart';
import 'package:instgram_responsive_app/responsive/responsive.dart';
import 'package:instgram_responsive_app/responsive/web.dart';
import 'package:instgram_responsive_app/screens/sign_in.dart';
import 'package:instgram_responsive_app/shared/snack_bar.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAAEcj2loqYk8vavXCd8aujNxcfDM4BXRY",
            authDomain: "flutter-responsive-instagram.firebaseapp.com",
            projectId: "flutter-responsive-instagram",
            storageBucket: "flutter-responsive-instagram.appspot.com",
            messagingSenderId: "838823515600",
            appId: "1:838823515600:web:bfdbb305409eca461d55d5"));
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {return UserProvider();},
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF202020),
          ),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.white,
              ));
            } else if (snapshot.hasError) {
              return showSnackBar(context, "Something went wrong");
            } else if (snapshot.hasData) {
              return const Responsive(
                myMobileScreen: MobileScreen(),
                myWebScreen: WebScreen(),
              );
            } else {
              return const SignIn();
            }
          },
        ),
        // home: const Responsive(
        //   myMobileScreen: MobileScreen(),
        //   myWebScreen: WebScreen(),
        // ),
      ),
    );
  }
}
