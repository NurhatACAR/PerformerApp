import 'package:flutter/material.dart';
import 'package:users_app/assistants/request_assistant.dart';
import 'package:users_app/global/map_key.dart';
import 'package:users_app/models/predicted_places.dart';

class SearchPlacesScreen extends StatefulWidget {
  const SearchPlacesScreen({super.key});

  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {

    void findPlaceAutoCompleteSearch(String inputText) async
    {
     if(inputText.length > 1){
       String urlAutoCompleteSearch = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$mapKey&components=country:TR";

      var responseAutoCompleteSearch = await RequestAssistant.receiveRequest(urlAutoCompleteSearch);

      if(responseAutoCompleteSearch == "Hata oluştu, yanıt verilemiyor."){
        return;
      }

      if(responseAutoCompleteSearch["search"]== "OK")
      {
        var placePredictions = responseAutoCompleteSearch["predictions"];

        var placePredictionsList = (placePredictions as List).map((jsonData) => PredictedPlaces.fromJson(jsonData)).toList();
      }
     }

    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(children: [
        Container(
          height: 180,
          decoration: const BoxDecoration(
            color: Colors.black54,
            boxShadow: [
              BoxShadow(
                color: Colors.white54,
                blurRadius: 8,
                spreadRadius: 0.5,
                offset: Offset(0.7, 0.7),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 25.0,
                ),
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.grey,
                      ),
                    ),
                    const Center(
                      child: Text(
                        "Gitmek istediğiniz yeri seçiniz.",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.adjust_sharp,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      height: 18.0,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          onChanged: (valueTyped) 
                          {
                            findPlaceAutoCompleteSearch(valueTyped);

                          },
                          decoration: const InputDecoration(
                              hintText: "Ara...",
                              fillColor: Colors.white54,
                              filled: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                left: 11.0,
                                top: 8.0,
                                bottom: 8.0,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
