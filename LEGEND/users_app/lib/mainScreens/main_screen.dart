import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:users_app/assistants/assistant_methods.dart';
import 'package:users_app/assistants/geofire_assistant.dart';
import 'package:users_app/authentication/login_screen.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/infoHandler/app_info.dart';
import 'package:users_app/main.dart';
import 'package:users_app/mainScreens/search_places_screen.dart';
import 'package:users_app/models/active_nearby_available_performers.dart';
import 'package:users_app/widgets/my_drawer.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();

  double searchLocationContainerHeight = 220;

  Position? userCurrentPosition;
  var geoLocator = Geolocator();

  LocationPermission? _locationPermission;
  double bottomPaddingOfMap = 0;

    List<LatLng> pLineCoOrdinatesList = [];
  Set<Polyline> polyLineSet = {};

  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};

  bool activeNearbyPerformerKeysLoaded = false;
  BitmapDescriptor? activeNearbyIcon;

  String userName = "isminiz";
  String userEmail = "mailiniz";

  List<ActiveNearbyAvailablePerformers> onlineNearByAvailablePerformersList = [];

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

  locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    userCurrentPosition = cPosition;

    LatLng latLngPosition =
        LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    String humanReadableAddress =
        await AssistantMethods.searchAddressForGeographicCoOrdinates(
            userCurrentPosition!, context);
    // ignore: avoid_print
    print("addresiniz = $humanReadableAddress");

    // userName = userModelCurrentInfo.name;
    // userEmail = userModelCurrentInfo!.email!;

    InitializeGeoFireListener();
    
  }

  @override
  void initState() {
    super.initState();
    checkIfLocationPermissionAllowed();
  }

  savePerformersRequestInformation(){
    //sanatçı bilgileri bu sayfaya gelecek.

    onlineNearByAvailablePerformersList = GeoFireAssistant.activeNearbyAvailablePerformersList;
    searchNearestOnlinePerformers();
  }

  searchNearestOnlinePerformers() async {
    if(onlineNearByAvailablePerformersList.length == 0){
      //sanatçı bilgilerini sil.
      setState(() {
        polyLineSet.clear();
        markerSet.clear();
        circleSet.clear();
        pLineCoOrdinatesList.clear();
      });

      Fluttertoast.showToast(msg: "Yakınlarda etkinlik bulunmamaktadır.");
      Fluttertoast.showToast(msg: "Uygulama yeniden başlatılıyor, Lütfen sonra tekrar deneyiniz.");

      Future.delayed(const Duration(milliseconds: 4000), ()
       {
        MyApp.restartApp(context);
       });

      return;
    }
    await retrieveOnlinePerformersInformation(onlineNearByAvailablePerformersList);
  }

  retrieveOnlinePerformersInformation(List onlineNearestPerformersList) async
  {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child("Sanatçı");
    for(int i=0; i<onlineNearestPerformersList.length;i++){
      await ref.child(onlineNearestPerformersList[i].key.toString()).once().then((DataSnapshot) 
      {
        var performersKeyInfo = DataSnapshot.snapshot.value; 
      }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    createActiveNearByPerformerIconMarker();
    return Scaffold(
      key: sKey,
      drawer: Container(
        width: 260,
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.black,
          ),
          child: MyDrawer(
            name: userModelCurrentInfo?.name, //değiştirilecek
            // ? userModelCurrentInfo!.name
            // : "İsmim",
            email: userModelCurrentInfo?.email, //değiştirilecek
            // ? userModelCurrentInfo!.email
            // : "Email",
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            markers: markerSet,
            zoomControlsEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              //siyah temalı harita
              blackThemeGoogleMap();

              setState(() {
                bottomPaddingOfMap = 240;
              });

              locateUserPosition();
            },
          ),
          Positioned(
            top: 30,
            left: 14,
            child: GestureDetector(
              onTap: () {
                sKey.currentState!.openDrawer();
              },
              child: const CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.menu,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedSize(
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 120),
              child: Container(
                height: searchLocationContainerHeight,
                decoration: const BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Column(
                    children: [
                      //from
                      Row(
                        children: [
                          const Icon(
                            Icons.add_location_alt_outlined,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 12.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Yer",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                              Text(
                                Provider.of<AppInfo>(context)
                                            .userPickUpLocation !=
                                        null
                                    ? (Provider.of<AppInfo>(context)
                                                .userPickUpLocation!
                                                .locationName!)
                                            .substring(0, 24) +
                                        "..."
                                    : "Konum Alınmadı",
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 10.0),

                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey,
                      ),

                      const SizedBox(height: 16.0),

                      //to
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => SearchPlacesScreen()));
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.add_location_alt_outlined,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 12.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "nereye",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12),
                                ),
                                Text(
                                  "nereye gitmek istiyorsunuz?",
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10.0),

                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey,
                      ),

                      const SizedBox(height: 16.0),

                      ElevatedButton(
                        child: const Text(
                          "Sanatçı nerde",
                        ),
                        onPressed: () {
                        if(Provider.of<AppInfo>(context,listen: false).userDropOffLocation==null){
                          savePerformersRequestInformation();
                        }
                        // else{
                        //   Fluttertoast.showToast(msg: "Lütfen gideceğiniz yeri seçiniz");
                        // }
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            textStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InitializeGeoFireListener() {
    Geofire.initialize("activePerformers");
    Geofire.queryAtLocation(
            userCurrentPosition!.latitude, userCurrentPosition!.longitude, 10)!
        .listen((map) {
      print(map);
      if (map != null) {
        var callBack = map['callBack'];

        switch (callBack) {
          //sanatçı aktif olunca
          case Geofire.onKeyEntered:
            ActiveNearbyAvailablePerformers activeNearbyAvailablePerformer =
                ActiveNearbyAvailablePerformers();
            activeNearbyAvailablePerformer.locationLatitude = map['latitude'];
            activeNearbyAvailablePerformer.locationLongitude = map['longitude'];
            activeNearbyAvailablePerformer.performersId = map['key'];
            GeoFireAssistant.activeNearbyAvailablePerformersList
                .add(activeNearbyAvailablePerformer);
            if (activeNearbyPerformerKeysLoaded == true) {
              displayActivePerformersOnUsersMap();
            }
            break;
          //sanatcı aktif olmayınca
          case Geofire.onKeyExited:
            GeoFireAssistant.deleteOfflinePerformerFromList(map['key']);
            displayActivePerformersOnUsersMap();
            break;

          //sanatçı hareket edince-lokasyon güncellemesi
          case Geofire.onKeyMoved:
            ActiveNearbyAvailablePerformers activeNearbyAvailablePerformer =
                ActiveNearbyAvailablePerformers();
            activeNearbyAvailablePerformer.locationLatitude = map['latitude'];
            activeNearbyAvailablePerformer.locationLongitude = map['longitude'];
            activeNearbyAvailablePerformer.performersId = map['key'];
            GeoFireAssistant.updateActiveNearbyAvailablePerformersLocation(
                activeNearbyAvailablePerformer);
            displayActivePerformersOnUsersMap();
            break;
          //aktif sanatçıları kullanıcı haritasında görmek
          case Geofire.onGeoQueryReady:
            activeNearbyPerformerKeysLoaded = true;
            displayActivePerformersOnUsersMap();
            break;
        }
      }

      setState(() {});
    });
  }

  displayActivePerformersOnUsersMap() {
    setState(() {
      markerSet.clear();
      circleSet.clear();

      Set<Marker> performersMarkerSet = Set<Marker>();

      for (ActiveNearbyAvailablePerformers eachPerformer
          in GeoFireAssistant.activeNearbyAvailablePerformersList) {
        LatLng eachPerformerActivePosition = LatLng(
            eachPerformer.locationLatitude!, eachPerformer.locationLongitude!);

        Marker marker = Marker(
          markerId: MarkerId("Performer" + eachPerformer.performersId!),
          position: eachPerformerActivePosition,
          icon: activeNearbyIcon!,
          rotation: 360,
        );

        performersMarkerSet.add(marker);
      }

      setState(() {
        markerSet = performersMarkerSet;
      });
    });
  }

  createActiveNearByPerformerIconMarker() {
    if (activeNearbyIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/nn.png")
          .then((value) {
        activeNearbyIcon = value;
      });
    }
  }
}
