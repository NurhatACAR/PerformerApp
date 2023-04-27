import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:legend_performer_2/global/global.dart';
import 'package:legend_performer_2/splashScreen/splash_screen.dart';

//performer info Sayası
class PerformerInfoScreen extends StatefulWidget {
  @override
  State<PerformerInfoScreen> createState() => _PerformerInfoScreenState();
}

class _PerformerInfoScreenState extends State<PerformerInfoScreen> {
  //kontrolleri alıyoruz
  TextEditingController enstrumanTextEditingController =
      TextEditingController();
  TextEditingController turTextEditingController = TextEditingController();
  TextEditingController sayiTextEditingController = TextEditingController();
  TextEditingController tanitTextEditingController = TextEditingController();
//mekanSecList adında liste oluşturuyoruz(değer metin olacak)
  List<String> neredeSecList = [
    "Sokak sanatçısı",
    "İşletme sahnesi",
    "Şiir Dinletisi",
    "Kitap okuma saati",
  ];
  String? selectedNeredeSec; //null değer girilebilir bir değer oluşturduk

  savePerformerInfo() {
    Map performerMekanInfoMap = {
      "calinan_enstruman": enstrumanTextEditingController.text.trim(),
      "sarki_tur": turTextEditingController.text.trim(),
      "grup_sayisi": sayiTextEditingController.text.trim(),
      "nerede": selectedNeredeSec,
    };

    DatabaseReference performersRef =
        FirebaseDatabase.instance.ref().child("Sanatçı");
    performersRef
        .child(currentFirebaseUser!.uid)
        .child("sanatçı detayı")
        .set(performerMekanInfoMap);

    Fluttertoast.showToast(
        msg: "Sanatçı ayrıntıları kaydedildi, Hayırlı olsun.");
    Navigator.push(
        context, MaterialPageRoute(builder: (c) => const MySplashScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        //uzunluk hatası almamak için
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("images/logo1.jpg"),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Kullancı Ayrıntıları",
                style: TextStyle(
                    fontSize: 26,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: enstrumanTextEditingController,
                keyboardType: TextInputType.text,
                style: const TextStyle(
                  color: Colors.grey,
                ),
                decoration: const InputDecoration(
                  labelText: "Çalınan enstrümanlar",
                  hintText: "ör:Bağlama, Gitar...",
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
                controller: turTextEditingController,
                keyboardType: TextInputType.text,
                style: const TextStyle(
                  color: Colors.grey,
                ),
                decoration: const InputDecoration(
                  labelText: "Hangi Tür",
                  hintText: "ör:Türk Sanat Müziği",
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
                controller: tanitTextEditingController,
                keyboardType: TextInputType.text,
                style: const TextStyle(
                  color: Colors.grey,
                ),
                decoration: const InputDecoration(
                  labelText: "Kendinizi tanıtın",
                  hintText: "Tanıtma metni",
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
                controller: sayiTextEditingController,
                keyboardType: TextInputType.text,
                style: const TextStyle(
                  color: Colors.grey,
                ),
                decoration: const InputDecoration(
                  labelText: "Grup sayısı kaç kişi",
                  hintText: "ör:1,2,3",
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
              const SizedBox(
                height: 20,
              ),
              DropdownButton(
                //Basıldığında açılır kapanir alt menu açan buton.
                iconSize: 26,
                dropdownColor: Color.fromARGB(255, 76, 111, 35),
                hint: const Text(
                  //alt menü içinde default biçimde yazı yazar
                  "Aktivite seçiniz.",
                  style: TextStyle(fontSize: 14.0, color: Colors.grey),
                ),
                value: selectedNeredeSec,
                onChanged: (newValue) {
                  setState(() {
                    selectedNeredeSec = newValue.toString();
                  });
                },
                items: neredeSecList.map((mekan) {
                  return DropdownMenuItem(
                    child: Text(
                      mekan,
                      style: TextStyle(color: Colors.grey),
                    ),
                    value: mekan,
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  if (enstrumanTextEditingController.text.isNotEmpty &&
                      sayiTextEditingController.text.isNotEmpty &&
                      turTextEditingController.text.isNotEmpty &&
                      selectedNeredeSec != null) {
                    savePerformerInfo();
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.lightGreenAccent,
                ),
                child: const Text(
                  "Şimdi kaydet",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
