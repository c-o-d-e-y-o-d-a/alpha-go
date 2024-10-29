import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image/image.dart' as img;
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mb;
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:searchfield/searchfield.dart';

class MapHomePage extends StatefulWidget {
  const MapHomePage({super.key});

  @override
  State<MapHomePage> createState() => _MapHomePageState();
}

class _MapHomePageState extends State<MapHomePage> {
  LatLng? userPos;
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

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      mb.MapboxOptions.setAccessToken(apiKey);

      downloadImage(FirebaseAuth.instance.currentUser!.photoURL ??
              "https://via.placeholder.com/150")
          .then((value) {
        setState(() {
          pointerImage = value;
        });
      });
      mapboxMap?.location.updateSettings(mb.LocationComponentSettings(
          locationPuck: mb.LocationPuck(
              locationPuck3D: mb.LocationPuck3D(
        modelUri:
            "https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/Duck/glTF-Embedded/Duck.gltf",
      ))));
      // mapboxMap?.style.addLayer(mb.ModelLayer(id: id, sourceId: sourceId))
      determinePosition().then((value) {
        setState(() {
          userPos = LatLng(value.latitude, value.longitude);
        });
      });
    });
  }

  _onMapCreated(mb.MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
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
                styleUri: styleUrl,
                cameraOptions: mb.CameraOptions(
                    pitch: 90,
                    center: mb.Point(
                        coordinates:
                            mb.Position(userPos!.longitude, userPos!.latitude)),
                    zoom: 12.0),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            determinePosition().then((value) {
              setState(() async {
                await mapboxMap?.flyTo(
                    mb.CameraOptions(
                        pitch: 90,
                        center: mb.Point(
                            coordinates:
                                mb.Position(value.longitude, value.latitude)),
                        zoom: 12.0),
                    mb.MapAnimationOptions());
              });
            });
          },
          child: const Icon(Icons.my_location),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      ),
    );
  }
}
