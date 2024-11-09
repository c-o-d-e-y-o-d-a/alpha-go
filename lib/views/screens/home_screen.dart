import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image/image.dart' as img;
import 'package:geolocator/geolocator.dart' as geo;
import 'package:latlong2/latlong.dart' as ltlng;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mb;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:searchfield/searchfield.dart';

class MapHomePage extends StatefulWidget {
  const MapHomePage({super.key});

  @override
  State<MapHomePage> createState() => _MapHomePageState();
}

class _MapHomePageState extends State<MapHomePage> {
  ltlng.LatLng? userPos;
  Image? pointerImage;
  mb.MapboxMap? mapboxMap;
  final styleUrl = "mapbox://styles/powerclubglobal/cm2tx1qrp00fy01qw4oga0dqk";
  static final List<String> countries = ['India', 'China', 'Russia'];

  final apiKey =
      "pk.eyJ1IjoicG93ZXJjbHViZ2xvYmFsIiwiYSI6ImNtMW1mNm52aTBmOGgybG9ranJ5bHEwOW4ifQ.kZ-f73h8hk0CXzjy08OSyg";

  Future<Image> downloadImage(String imageUrl) async {
    final File imageFile = await DefaultCacheManager().getSingleFile(imageUrl);
    final img.Image originalImage =
        img.decodeImage(imageFile.readAsBytesSync())!;
    return Image.memory(
      Uint8List.fromList(img.encodePng(originalImage)),
      fit: BoxFit.cover,
    );
  }

  Future<geo.Position> determinePosition() async {
    bool serviceEnabled;
    geo.LocationPermission permission;

    serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await geo.Geolocator.checkPermission();
    if (permission == geo.LocationPermission.denied) {
      permission = await geo.Geolocator.requestPermission();
      if (permission == geo.LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == geo.LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.best);
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await requestLocationPermission();
      mb.MapboxOptions.setAccessToken(apiKey);

      downloadImage(FirebaseAuth.instance.currentUser!.photoURL ??
              "https://via.placeholder.com/150")
          .then((value) {
        setState(() {
          pointerImage = value;
        });
      });
      determinePosition().then((value) {
        setState(() {
          userPos = ltlng.LatLng(value.latitude, value.longitude);
        });
      });
      //mapboxMap?.style.addLayer(mb.LocationIndicatorLayer(id: 'location-main'));

      // mapboxMap?.style.addLayer(mb.ModelLayer(id: id, sourceId: sourceId))
    });
  }

  addModelLayer() async {
    var value = mb.Point(
        coordinates: mb.Position(76.85278280979402, 30.659204869650807));
    if (mapboxMap == null) {
      throw Exception("MapboxMap is not ready yet");
    }

    await mapboxMap?.style
        .addSource(mb.GeoJsonSource(id: "sourceId", data: json.encode(value)));

    final carModelId = "model-car-id";
    final carModelUri =
        "https://github.com/M4dhav/alpha-go/raw/dev/assets/rossiya_hotel/scene.gltf";
    await mapboxMap?.style.addStyleModel(carModelId, carModelUri);

    var modelLayer1 = ModelLayer(id: "modelLayer-car", sourceId: "sourceId");
    modelLayer1.modelId = carModelId;
    modelLayer1.modelScale = [5, 5, 5];
    modelLayer1.modelRotation = [0, 0, 90];
    modelLayer1.modelType = ModelType.COMMON_3D;
    mapboxMap?.style.addLayer(modelLayer1);
  }

  _onMapCreated(mb.MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    mapboxMap.location.updateSettings(mb.LocationComponentSettings(
        enabled: true,
        puckBearing: mb.PuckBearing.HEADING,
        puckBearingEnabled: true,
        pulsingEnabled: true,
        pulsingMaxRadius: 20,
        locationPuck: mb.LocationPuck(
            locationPuck3D: mb.LocationPuck3D(
          modelUri:
              "https://github.com/M4dhav/alpha-go/raw/dev/assets/man/scene.gltf",
          modelScale: [70, 70, 70],
          position: [userPos!.longitude, userPos!.latitude],
        ))));
    log('puck added');
  }

  _onStyleLoaded(StyleLoadedEventData data) async {
    await addModelLayer();
    log('style loaded');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/bg.jpg"), fit: BoxFit.cover)),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          shape: RoundedRectangleBorder(
              side: const BorderSide(color: Color(0xffb4914b)),
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(20.sp))),
          leadingWidth: 17.w,
          leading: Padding(
            padding: EdgeInsets.only(left: 3.w),
            child: Image.asset(
              'assets/alpha.jpg',
              fit: BoxFit.contain,
            ),
          ),
          backgroundColor: Colors.black,
          //bottom: Constants.appBarBottom,
          automaticallyImplyLeading: false,
          title: SearchField<String>(
            searchInputDecoration: SearchInputDecoration(
                hintText: 'Search',
                cursorColor: Colors.white,
                hintStyle: const TextStyle(
                  color: Color(0xffb4914b),
                )),
            marginColor: const Color(0xffb4914b),
            suggestions: countries
                .map(
                  (e) => SearchFieldListItem<String>(e,
                      item: e,
                      // Use child to show Custom Widgets in the suggestions
                      // defaults to Text widget
                      child: Text(e)),
                )
                .toList(),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.only(
                right: 3.w,
              ),
              child: Center(
                child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.menu,
                      color: const Color(0xffb4914b),
                      size: 29.sp,
                    )),
              ),
            )
          ],
        ),
        body: userPos == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : mb.MapWidget(
                key: const ValueKey("mapWidget"),
                onMapCreated: _onMapCreated,
                onStyleLoadedListener: _onStyleLoaded,
                styleUri: styleUrl,
                cameraOptions: mb.CameraOptions(
                    pitch: 80,
                    center: mb.Point(
                        coordinates:
                            mb.Position(userPos!.longitude, userPos!.latitude)),
                    zoom: 12.0),
              ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     determinePosition().then((value) {
        //       setState(() async {
        //         await mapboxMap?.flyTo(
        //             mb.CameraOptions(
        //                 pitch: 90,
        //                 center: mb.Point(
        //                     coordinates:
        //                         mb.Position(value.longitude, value.latitude)),
        //                 zoom: 12.0),
        //             mb.MapAnimationOptions());
        //       });
        //     });
        //   },
        //   child: const Icon(Icons.my_location),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      ),
    );
  }
}
