import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:legend_performer_2/global/global.dart';
import 'package:legend_performer_2/splashScreen/splash_screen.dart';

import '../assistants/assistant_methods.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  GoogleMapController? newGoogleMapController;
  Completer<GoogleMapController> _controllerGoogleMap = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Position? performerCurrentPosition;
  var geoLocator = Geolocator();
  LocationPermission? _locationPermission;

  String statusText = "Aktif değil";
  Color buttonColor = Colors.grey;
  bool isPerformerActive = false;

  blackThemeGoogleMap() {
    newGoogleMapController!.setMapStyle('''
                    [
                      {
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "featureType": "administrative.locality",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#263c3f"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#6b9a76"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#38414e"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#212a37"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#9ca5b3"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#1f2835"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#f3d19c"
                          }
                        ]
                      },
                      {
                        "featureType": "transit",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#2f3948"
                          }
                        ]
                      },
                      {
                        "featureType": "transit.station",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#515c6d"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      }
                    ]
                ''');
  }

  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  locatePerformerPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    performerCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(performerCurrentPosition!.latitude,
        performerCurrentPosition!.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    String humanReadableAddress =
        await AssistantMethods.searchAddressForGeographicCoOrdinates(
            performerCurrentPosition!, context);

    print("addresiniz = $humanReadableAddress");
    // userName = userModelCurrentInfo.name;
    // userEmail = userModelCurrentInfo!.email!;
  }

  @override
  void initState() {
    super.initState();
    checkIfLocationPermissionAllowed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              //siyah temalı google haritası
              blackThemeGoogleMap();

              locatePerformerPosition();
            },
          ),

          //sanatçı aktif mi değil mi
          statusText != "Aktif et!"
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  color: Colors.black87,
                )
              : Container(),

          //aktif durumlu button
          Positioned(
            top: statusText != "Aktif et!"
                ? MediaQuery.of(context).size.height * 0.50
                : 25,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (isPerformerActive != true) {
                      performerIsOnlineNow();
                      updatePerformersLocationAtRealTime();

                      setState(() {
                        statusText = "Aktif et!";
                        isPerformerActive = true;
                        buttonColor = Colors.transparent;
                      });

                      Fluttertoast.showToast(msg: "Şuan Aktifsiniz");
                    } else {
                      performerIsOfflineNow();
                      setState(() {
                        statusText = "Şuan aktif değilsiniz";
                        isPerformerActive = false;
                        buttonColor = Colors.grey;
                      });
                      Fluttertoast.showToast(msg: "Şuan aktif değilsiniz.");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      primary: buttonColor,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26))),
                  child: statusText != "Aktif et!"
                      ? Text(
                          statusText,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(
                          Icons.phonelink_ring,
                          color: Colors.white,
                          size: 26,
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  performerIsOnlineNow() async {
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    performerCurrentPosition = pos;

    Geofire.initialize("activePerformers");
    Geofire.setLocation(
        currentFirebaseUser!.uid,
        performerCurrentPosition!.latitude,
        performerCurrentPosition!.longitude);
    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child("Sanatçı")
        .child(currentFirebaseUser!.uid)
        .child("Şimdi başlat");

    ref.set("başladı");
    ref.onValue.listen((event) {});
  }

  updatePerformersLocationAtRealTime() {
    streamSubscriptionPosition =
        Geolocator.getPositionStream().listen((Position position) {
      performerCurrentPosition = position;
      if (isPerformerActive == true) {
        Geofire.setLocation(
            currentFirebaseUser!.uid,
            performerCurrentPosition!.latitude,
            performerCurrentPosition!.longitude);
      }

      LatLng latLng = LatLng(performerCurrentPosition!.latitude,
          performerCurrentPosition!.longitude);
      newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  performerIsOfflineNow() {
    Geofire.removeLocation(currentFirebaseUser!.uid);
    DatabaseReference? ref = FirebaseDatabase.instance
        .ref()
        .child("Sanatçı")
        .child(currentFirebaseUser!.uid)
        .child("Şimdi başlat");

    ref.onDisconnect();
    ref.remove();
    ref = null;

    Future.delayed(const Duration(microseconds: 2000), () {
      // SystemChannels.platform.invokeMethod("SystemNavigator.pop");
      // SystemNavigator.pop();
      Navigator.push(
          context, MaterialPageRoute(builder: (c) => MySplashScreen()));
    });
  }
}
