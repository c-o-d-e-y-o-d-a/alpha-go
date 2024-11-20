import 'package:alpha_go/models/const_model.dart';
import 'package:alpha_go/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EventWidget extends StatelessWidget {
  final EventModel event;
  const EventWidget({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Material(
      color: Colors.transparent,
      child: Container(
        height: 60.h,
        width: 80.w,
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xffb4914b),
            )),
        // color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.network(
              event.imageUrl,
              height: 20.h,
            ),
            Text(
              event.eventName,
              style: TextStyle(
                fontSize: 14.px,
                fontFamily: 'Cinzel',
                color: const Color(0xffb4914b),
              ),
            ),
            Text(
              event.description,
              style: TextStyle(
                fontSize: 12.px,
                fontFamily: 'Cinzel',
                color: Colors.white,
              ),
            ),
            Text(event.location.toString()),
            Text(
              "${event.startTime.toString()} to ${event.endTime.toString()}",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.px,
                fontFamily: 'Cinzel',
                color: Colors.white,
              ),
            ),
            Text(
              "100 Sats",
              style: TextStyle(
                fontSize: 12.px,
                fontFamily: 'Cinzel',
                color: Colors.white,
              ),
            ),
            ElevatedButton(
                style: Constants.buttonStyle,
                onPressed: () {},
                child: Text(
                  "Redeem",
                  style: TextStyle(fontSize: 12.px),
                ))
          ],
        ),
      ),
    ));
  }
}
