import 'package:alpha_go/models/event_model.dart';
import 'package:alpha_go/models/firebase_model.dart';
import 'package:get/get.dart';

class EventController extends GetxController {
  final List<EventModel> events = [];

  Future<void> getEvents() async {
    await FirebaseUtils.events.get().then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        events.add(EventModel.fromMap(doc.data()));
      }
    });
  }

  Future<void> addEvent(EventModel event) async {
    await FirebaseUtils.events.add(event.toMap());
    events.add(event);
  }
}
