import 'dart:developer';

import 'package:alpha_go/controllers/event_controller.dart';
import 'package:alpha_go/models/const_model.dart';
import 'package:alpha_go/models/event_model.dart';
import 'package:alpha_go/models/user_model.dart';
import 'package:alpha_go/views/screens/event_details_screen.dart';
import 'package:avatar_stack/avatar_stack.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EventWidget extends StatelessWidget {
  final EventModel event;
  final List<WalletUser> hosts;
  const EventWidget({super.key, required this.event, required this.hosts});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Material(
      color: Colors.transparent,
      child: Container(
        height: 70.h,
        width: 80.w,
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xffb4914b),
            )),
        // color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: event.imageUrl,
                  width: 74.w,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xffb4914b),
                    ),
                  ),
                ),
              ),
              Text(
                event.eventName,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 22.px,
                  fontFamily: 'Cinzel',
                  color: const Color(0xffb4914b),
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10.w,
                    child: AvatarStack(
                      height: 2.5.h,
                      borderWidth: 0.5,
                      avatars: [
                        for (var n = 0; n < event.hostId.length; n++)
                          NetworkImage(hosts[n].pfpUrl),
                      ],
                    ),
                  ),
                  Text(
                    "Hosted by: ${hosts.map((e) => e.accountName).join(", ")}",
                    style: TextStyle(
                      fontSize: 10.px,
                      fontFamily: 'Cinzel',
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Text(
                event.locationName,
                style: TextStyle(
                  fontSize: 12.px,
                  fontFamily: 'Cinzel',
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "${DateFormat('d MMM yyyy, HH:mm').format(event.startTime.toLocal())} to ${DateFormat('d MMM yyyy, HH:mm').format(event.endTime.toLocal())}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.px,
                  fontFamily: 'Cinzel',
                  color: Colors.white,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: Constants.buttonStyle,
                      onPressed: () {
                        Get.to(EventDetailsScreen(
                          event: event,
                          hosts: hosts,
                        ));
                      },
                      child: Text(
                        "Details",
                        style: TextStyle(
                            fontSize: 12.px, fontWeight: FontWeight.bold),
                      )),
                  ElevatedButton(
                      style: Constants.buttonStyle,
                      onPressed: () {},
                      child: Text(
                        "Register",
                        style: TextStyle(
                            fontSize: 12.px, fontWeight: FontWeight.bold),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
