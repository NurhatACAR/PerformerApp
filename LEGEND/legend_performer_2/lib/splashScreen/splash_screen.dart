import 'dart:async';

import 'package:flutter/material.dart';
import 'package:legend_performer_2/authentication/login_screen.dart';
import 'package:legend_performer_2/authentication/signup_screen.dart';
import 'package:legend_performer_2/global/global.dart';
import 'package:legend_performer_2/mainScreen/main_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  startTimer() {
    Timer(const Duration(seconds: 6), () async {
      if (await fAuth.currentUser != null) {
        currentFirebaseUser = fAuth.currentUser;
        //Kullanıcıyı Main screen'e gönder.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (c) => MainScreen(),
          ),
        );
      } else {
        //Kullanıcıyı Login screen'e gönder.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (c) => LoginScreen(),
          ),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.black,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/logo1.jpg"),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Legend Performer App",
              style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        )),
      ),
    );
  }
}
