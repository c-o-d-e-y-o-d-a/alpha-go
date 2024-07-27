import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapHomePage extends StatefulWidget {
  MapHomePage({super.key});
  LatLng? userPos;
  Image? pointerImage;

  @override
  State<MapHomePage> createState() => _MapHomePageState();
}

class _MapHomePageState extends State<MapHomePage> {
  Future<Image> downloadImage(String imageUrl) async {
    final File imageFile = await DefaultCacheManager().getSingleFile(imageUrl);
    final img.Image originalImage =
        img.decodeImage(imageFile.readAsBytesSync())!;
    return Image.memory(
      Uint8List.fromList(img.encodePng(originalImage)),
      height: 50,
      width: 50,
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      downloadImage(
              "https://btcinc.notion.site/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F0bb6c9f7-9fea-4e75-9a10-2132b25e6c26%2FB24_glyph_vinyl_black.png?table=block&id=51a413cd-839a-4dfc-98fc-d6ad3c6beff8&spaceId=01e1e793-4fae-46aa-9554-5c27f1b12ad6&width=860&userId=&cache=v2")
          .then((value) {
        setState(() {
          widget.pointerImage = value;
        });
      });
      determinePosition().then((value) {
        setState(() {
          widget.userPos = LatLng(value.latitude, value.longitude);
        });
      });
    });
  }

  final styleUrl =
      "https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}{r}.png";
  final apiKey = "e7ff0aa5-a374-4a61-95d7-7323683d4cfd";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget.userPos == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : FlutterMap(
                options: MapOptions(
                    initialCenter: widget.userPos!,
                    // center: LatLng(59.438484, 24.742595),
                    initialZoom: 14,
                    keepAlive: true),
                children: [
                  TileLayer(
                    urlTemplate: "$styleUrl?api_key={api_key}",
                    additionalOptions: {"api_key": apiKey},
                    maxZoom: 20,
                    maxNativeZoom: 20,
                  ),
                  CurrentLocationLayer(
                      alignPositionOnUpdate: AlignOnUpdate.always,
                      alignDirectionOnUpdate: AlignOnUpdate.always,
                      style: LocationMarkerStyle(
                        marker: DefaultLocationMarker(
                          child: widget.pointerImage,
                        ),
                        markerSize: const Size(30, 30),
                        markerDirection: MarkerDirection.heading,
                      )),
                  MarkerClusterLayerWidget(
                    options: MarkerClusterLayerOptions(
                      maxClusterRadius: 45,
                      size: const Size(40, 40),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(50),
                      maxZoom: 15,
                      markers: [
                        Marker(
                          point: const LatLng(
                              30.65426548694503, 76.85826072220257),
                          child: widget.pointerImage!,
                        ),
                      ],
                      builder: (context, markers) {
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.blue),
                          child: Center(
                            child: Text(
                              markers.length.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            determinePosition().then((value) {
              setState(() {
                widget.userPos = LatLng(value.latitude, value.longitude);
              });
            });
          },
          child: const Icon(Icons.my_location),
        ));
  }
}
