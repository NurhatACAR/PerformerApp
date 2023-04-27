import 'package:flutter/material.dart';
import 'package:legend_performer_2/global/global.dart';
import 'package:legend_performer_2/splashScreen/splash_screen.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({super.key});

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
      child: const Text(
        "Çıkış Yap",
      ),
      onPressed: () {
        fAuth.signOut();
        //Kullanıcıyı Login screen'e gönder.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (c) => const MySplashScreen(),
        ),
      );
      },
    ));
  }
}
