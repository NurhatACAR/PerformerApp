import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:legend_performer_2/authentication/login_screen.dart';
import 'package:legend_performer_2/authentication/performer_info_screen.dart';
import 'package:legend_performer_2/global/global.dart';
import 'package:legend_performer_2/widgets/progress_dialog.dart';

//'SIGN-UP' SAYFASI
class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

//burda kayıt bilgillerin kontrollerini sağlıyoruz.
class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validateForm() {
    //eğer isim uzunluğu 3 ten küçükse şart çalışacak.
    if (nameTextEditingController.text.length < 3) {
      Fluttertoast.showToast(msg: "isim en az 3 karakter olmalıdır");
    } else if (!emailTextEditingController.text.contains("@")) {
      Fluttertoast.showToast(msg: "geçerli bir eposta adresi değil");
    } else if (phoneTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Lütfen telefon numarasını giriniz");
    } else if (passwordTextEditingController.text.length < 6) {
      Fluttertoast.showToast(msg: "şifre en az 6 karakter olmalı");
    } else {
      savePerformerInfoNow();
    }
  }

  savePerformerInfoNow() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDialog(
            message: "Bilgiler işleniyor, lütfen bekleyin",
          );
        });

    final User? firebaseUser = (await fAuth
            .createUserWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    )
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Hoop kardeşim hata var: " + msg.toString());
    }))
        .user;

    //eğer null değilse
    if (firebaseUser != null) {
      Map performerMap = {
        "id": firebaseUser.uid,
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };

      DatabaseReference performersRef =
          FirebaseDatabase.instance.ref().child("Sanatçı");
      performersRef.child(firebaseUser.uid).set(performerMap);

      currentFirebaseUser = firebaseUser;
       Fluttertoast.showToast(msg: "Hesap oluşturuldu.");
      Navigator.push(
          context, MaterialPageRoute(builder: (c) => PerformerInfoScreen()));
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Hesap oluşturulmadı.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Arka plan rengini siyah yapıyoruz.
      body: SingleChildScrollView(
        //uygulama boyut hatası almanın önüne geçiyoruz.
        child: Padding(
          padding: const EdgeInsets.all(16.0), // boyutu ayarlıyoruz.
          child: Column(
            children: [
              const SizedBox(
                // satır boşluğu bırakır.
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0), // boyut ayarlıyoruz
                child: Image.asset(
                    "images/logo2.jpg"), // ekrana fotoğraf ekliyoruz
              ),
              const SizedBox(
                // satır boşluğu bırakır
                height: 10,
              ),
              const Text(
                // yazı yazar const kullanmamın amacı sonradan değişiklilik yapılmaması
                "Kayıt Ol!",
                style: TextStyle(
                    // yazı sitili düzenlemesi
                    fontSize: 26,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
              TextField(
                // text alanı açtık.
                controller: nameTextEditingController, //kontrol sağlar
                keyboardType: TextInputType
                    .text, // klavyeden girilen değer text türünden olacak
                style: const TextStyle(
                  // tipini düzenliyoruz
                  color: Colors.grey,
                ),
                decoration: const InputDecoration(
                  labelText: "isim", //text alanını üstüne yazar
                  hintText: "ismimizi giriniz", //text alanı içine yazar
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintStyle: TextStyle(
                    //text kutusunun içine yazan metni düzenler
                    color: Colors.grey, //yazı stilini düzenlemeler yapıldı
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    //text kutusu üstündeki yazıları düzenler
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
              TextField(
                controller: emailTextEditingController, // kontrol sağlar
                keyboardType: TextInputType
                    .emailAddress, //klavyeden girilen değer e-mail girdisi olacak.
                style: const TextStyle(
                  //text tipini düzenliyoruz
                  color: Colors.grey,
                ),
                decoration: const InputDecoration(
                  // girdi dekorasyonu
                  labelText: "E-mail", //text kutusu üstüne yazar
                  hintText: "Ör:şarkı@örnek.com", //kutu içine yazar
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
              TextField(
                controller: phoneTextEditingController, // kontrol sağlar
                keyboardType: TextInputType
                    .phone, //klavyede girilen tip telefon cinsiden olacak
                style: const TextStyle(
                  //text tipini düzenliyoruz
                  color: Colors.grey,
                ),
                decoration: const InputDecoration(
                  //girdi yerleri
                  labelText: "Telefon", //text üzerine yazar
                  hintText: "Telefon Numarası", //girdi içine yazar
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintStyle: TextStyle(
                    //kutu içine yazı tipini düzenler
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    //kutu üstünde yazılan yazı tipini düzenler
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
              TextField(
                controller: passwordTextEditingController, //kontrol sağlar
                keyboardType: TextInputType
                    .text, //klavyeden girilen değer text tipinde olacak
                obscureText: true, //girilen değer gözükmeyecek
                style: const TextStyle(
                  //girilen değerin renk sitilini düzenler
                  color: Colors.grey,
                ),
                decoration: const InputDecoration(
                  //girdi yeri
                  labelText: "Şifre", //text üstüne şifre yazar
                  hintText:
                      "Şifrenizi Giriniz", //kutu içine şifrenizi girin yazacak
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintStyle: TextStyle(
                    //kutu içine yazılan yazı rengini düzenler
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    //kutu üstüne yazılan yazı stilini düzenler
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
                //zeminden yükseltilmiş button
                onPressed: () {
                  validateForm();
                  //tıklanma özelliği verdik
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (c) =>
                  //             PerformerInfoScreen())); //buttona tıklanınca başka sayfaya geçmemizi sağlar
                },
                style: ElevatedButton.styleFrom(
                  //zeminden yükseltilmiş button stilini ayarlar
                  primary: Colors.lightGreenAccent,
                ),
                child: const Text(
                  //buton içine yazılan text ve sitili.
                  "Hesap oluştur!",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                  ),
                ),
              ),
              TextButton(
                //tıklanabilir yazı
                child: const Text(
                  "Hesabınız zaten var mı? Giriş Yap!",
                  style: TextStyle(color: Colors.grey), //yazılan textin sitili
                ),
                onPressed: () {
                  //tıklanma özelliği verilir
                  //basılınca 'LoginScreen' sayfasına yönlendirilir
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => LoginScreen()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
