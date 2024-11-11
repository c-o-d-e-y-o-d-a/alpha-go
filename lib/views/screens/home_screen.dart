import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:alpha_go/controllers/event_controller.dart';
import 'package:alpha_go/models/event_model.dart';
import 'package:alpha_go/views/widgets/event_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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
  final EventController eventController = Get.find();
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
          log('userPos: $userPos');
        });
      });
    });
  }

  addModelLayer(EventModel event) async {
    mb.Point location = mb.Point(
        coordinates:
            mb.Position(event.location.longitude, event.location.latitude));
    if (mapboxMap == null) {
      throw Exception("MapboxMap is not ready yet");
    }

    await mapboxMap?.style.addSource(mb.GeoJsonSource(
        id: "location-${event.eventName.split(' ')[0]}",
        data: json.encode(location)));

    final eventModelId = "event-${event.eventName.split(' ')[0]}";
    final eventModelUri =
        "https://github.com/M4dhav/alpha-go/raw/dev/assets/bitcoin/scene.gltf";
    await mapboxMap?.style.addStyleModel(eventModelId, eventModelUri);

    var modelLayer = ModelLayer(
        id: "modelLayer-${event.eventName.split(' ')[0]}",
        sourceId: "location-${event.eventName.split(' ')[0]}");
    modelLayer.modelId = eventModelId;
    modelLayer.modelScale = [3, 3, 3];
    modelLayer.modelType = ModelType.COMMON_3D;
    mapboxMap?.style.addLayer(modelLayer);
  }

  _onMapCreated(mb.MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    mapboxMap.location.updateSettings(mb.LocationComponentSettings(
        enabled: true,
        puckBearing: mb.PuckBearing.HEADING,
        puckBearingEnabled: true,
        locationPuck: mb.LocationPuck(
            locationPuck3D: mb.LocationPuck3D(
          modelUri:
              "https://github.com/M4dhav/alpha-go/raw/dev/assets/pointer.glb",
          modelScale: [2, 2, 2],
          position: [userPos!.longitude, userPos!.latitude],
        ))));
    log('puck added');
  }

  _onTapListener(mb.MapContentGestureContext context) {
    EventModel tappedEvent = eventController.events.firstWhere((element) =>
        element.location.latitude.toStringAsPrecision(5) ==
            context.point.coordinates.lat.toStringAsPrecision(5) &&
        element.location.longitude.toStringAsPrecision(5) ==
            context.point.coordinates.lng.toStringAsPrecision(5));
    Get.dialog(EventWidget(event: tappedEvent));

    log('tapped${tappedEvent.eventName}');
  }

  _onStyleLoaded(StyleLoadedEventData data) async {
    for (EventModel event in eventController.events) {
      await addModelLayer(event);
    }
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
                // mapOptions: mb.MapOptions(
                //     pixelRatio: 1.0, orientation: mb.NorthOrientation.UPWARDS),
                key: const ValueKey("mapWidget"),
                onMapCreated: _onMapCreated,
                onStyleLoadedListener: _onStyleLoaded,
                onTapListener: _onTapListener,
                styleUri: styleUrl,
                cameraOptions: mb.CameraOptions(
                    pitch: 80,
                    center: mb.Point(
                        coordinates: mb.Position(
                            userPos!.longitude, userPos!.latitude + 0.0016)),
                    zoom: 18.0),
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
