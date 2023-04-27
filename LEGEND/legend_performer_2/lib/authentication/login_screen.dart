import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:legend_performer_2/authentication/signup_screen.dart';
import 'package:legend_performer_2/mainScreen/main_screen.dart';
import 'package:legend_performer_2/splashScreen/splash_screen.dart';
import 'package:legend_performer_2/tabPages/profile_tab.dart';

import '../global/global.dart';
import '../widgets/progress_dialog.dart';

//'LOGIN' sayfası
class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController =
      TextEditingController(); //text cinsinden kontrol(emailTe...)bir değişkendir
  TextEditingController passwordTextEditingController = TextEditingController();

  validateForm() {
    if (!emailTextEditingController.text.contains("@")) {
      Fluttertoast.showToast(msg: "geçerli bir eposta adresi girmediniz");
    } else if (passwordTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "şifrenizi giriniz.");
    } else {
      loginPerformerNow();
    }
  }

  loginPerformerNow() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDialog(
            message: "Bilgiler işleniyor, lütfen bekleyin",
          );
        });

    final User? firebaseUser = (await fAuth
            .signInWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    )
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Hoop kardeşim hata var: " + msg.toString());
    }))
        .user;

    if (firebaseUser != null) {
      DatabaseReference performersRef =
          FirebaseDatabase.instance.ref().child("Sanatçı");
      performersRef.child(firebaseUser.uid).once().then((performerKey) {
        final snap = performerKey.snapshot;
        if (snap.value != null) {
          currentFirebaseUser = firebaseUser;
          Fluttertoast.showToast(msg: "Giriş başarıllı.");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (c) => const MySplashScreen(),
            ),
          );
        } else {
          Fluttertoast.showToast(msg: "Bu e-posta kayıtlı değil");
          fAuth.signOut();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (c) => const MySplashScreen(),
            ),
          );
        }
      });
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Oturum açma sırasında, hata oluştu.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        //uzunluk hakkında hata almamızı ortadan kaldırır
        child: Padding(
          padding: const EdgeInsets.all(20.0), //boyutu ayarlar
          child: Column(
            children: [
              const SizedBox(
                //boşluk bırakır
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0), //boyut ayarlar
                child: Image.asset("images/logo7.jpg"), //fotoğraf ekler
              ),
              const SizedBox(
                //boşluk bırakır
                height: 10,
              ),
              const Text(
                //Yazı yazıp sitilini tanımladık
                "Giriş Yap",
                style: TextStyle(
                    fontSize: 26,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: emailTextEditingController, //kontrol sağlıyoruz
                keyboardType: TextInputType
                    .emailAddress, //klavyeden girilen değer e-mail türünde olacak
                style: const TextStyle(
                  //değerin sitilini ayarlıyoruz
                  color: Colors.grey,
                ),
                decoration: const InputDecoration(
                  //girilen değerin dekorasyonunu yapıyoruz
                  labelText: "E-mail", //girilen alan üstüne e-mail yazar
                  hintText: "Ör:şarkı@örnek.com", //içine bunu yazar
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintStyle: TextStyle(
                    //içine yazan yazının sitilini düzenler
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    //girilen yerin üstüne yazan değeri düzenler
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
              TextField(
                controller:
                    passwordTextEditingController, //kontrol sağlanılıyor
                keyboardType: TextInputType
                    .text, //klavyeden girilen değer text cinsinden olacak
                obscureText: true, //girilen değer gizlenecek
                style: const TextStyle(
                  color: Colors.grey,
                ),
                decoration: const InputDecoration(
                  //giriş dekorasyonu
                  labelText: "Şifre", //üstte yazılan yazı
                  hintText: "Şifrenizi Giriniz", //kutunun içine yazılan  değer
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintStyle: TextStyle(
                    //kutunun içinde yazılan yazıyı düzenler
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    //kutu üstüne yazan yeri düzenler
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(
                //boşluk bırakır
                height: 20,
              ),
              ElevatedButton(
                //tabandan yükseltilmiş button
                onPressed: () {
                  validateForm();
                }, //tıklanabilir olmasını sağlıyoruz
                style: ElevatedButton.styleFrom(
                  //buttonun stilini düzenliyoruz
                  primary: Colors.lightGreenAccent,
                ),
                child: const Text(
                  //içine yazı yazıp stilini yapıyoruz
                  "Giriş Yap",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                  ),
                ),
              ),
              TextButton(
                child: const Text(
                  //button cinsinden text yazıyoruz sitilini düzenliyoruz
                  "Hesabınız halen yok mu? Kayıt Ol!",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () {
                  //tıklanılabilir hale getiriyoruz
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (c) =>
                              SignUpScreen())); //basınca'SignUpScreen'e yollar
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
