import 'package:flutter/material.dart';
import 'package:alpha_go/models/event_model.dart';
import 'package:alpha_go/models/user_model.dart';
import 'package:alpha_go/views/widgets/event_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class EventWidgetTestingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Sample event and hosts data
    //to be deleletd before deployment
    EventModel sampleEvent = EventModel(
      eventName: 'The Fine Art of Money',
      imageUrl: 'https://images.unsplash.com/photo-1610177498573-78deaa4a797b?q=80&w=1780&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      locationName: 'The Gates HOtel South Beach',
      startTime: DateTime.now(),
      endTime: DateTime.now().add(Duration(hours: 2)),
      location: const GeoPoint(78.0, 32.0),
      hostId: ['Jessy Artman', 'PowerClubGloball'],
      description: 'odjfdsof isdoif sdoij  dsoi fods ',
      cost: 20,
    );

    List<WalletUser> sampleHosts = [
      WalletUser(
          accountName: 'Host 1',
          pfpUrl: 'https://via.placeholder.com/50',
          walletAddress: '',
          bio: ''),
      WalletUser(
          accountName: 'Host 2',
          pfpUrl: 'https://via.placeholder.com/50',
          walletAddress: '',
          bio: ''),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Event Widget Testing Screen'),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              Get.dialog(EventWidget(event: sampleEvent, hosts: sampleHosts));
            },
            child: Text('Sex Me')),
      ),
    );
  }
}
