import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class EventModel {
  final String imageUrl;
  final String eventName;
  final String description;
  final GeoPoint location;
  final DateTime startTime;
  final DateTime endTime;
  final String ownerId;
  final int cost;

  EventModel({
    required this.imageUrl,
    required this.eventName,
    required this.description,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.ownerId,
    required this.cost,
  });

  EventModel.fromMap(Map<String, dynamic> map)
      : imageUrl = map['imageUrl'],
        eventName = map['eventName'],
        description = map['description'],
        location = map['location'],
        startTime = DateTime.parse(map['startTime']),
        endTime = DateTime.parse(map['endTime']),
        ownerId = map['ownerId'],
        cost = map['cost'];
  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'eventName': eventName,
      'description': description,
      'location': GeoPoint(location.latitude, location.longitude),
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'ownerId': ownerId,
      'cost': cost,
    };
  }
}
