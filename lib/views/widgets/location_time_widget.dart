import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EventLocationTimeWidget extends StatelessWidget {
  const EventLocationTimeWidget(
      {super.key,
      required this.startTime,
      required this.endTime,
      required this.location,
      required this.locationName});
  final DateTime startTime;
  final DateTime endTime;
  final GeoPoint location;
  final String locationName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 12.h,
      width: 90.w,
      child: Column(
        children: [
          SizedBox(
            height: 6.h,
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 5.w),
                  child: Container(
                    height: 5.h,
                    width: 5.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 1.8.h,
                          width: 5.h,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.5),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                          ),
                          child: Text(
                            DateFormat('MMM')
                                .format(startTime.toLocal())
                                .toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.px,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            DateFormat('d').format(startTime.toLocal()),
                            style: TextStyle(
                              fontSize: 16.px,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('EEEE, MMMM d').format(startTime.toLocal()),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.px),
                    ),
                    Text(
                      "${DateFormat('HH:mm').format(startTime.toLocal())} - ${DateFormat('MMM d, HH:mm').format(endTime.toLocal())}",
                      style: TextStyle(
                          fontSize: 14.px, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.left,
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 6.h,
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 5.w),
                  child: Container(
                      height: 5.h,
                      width: 5.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.5),
                        ),
                      ),
                      child: Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                      )),
                ),
                SizedBox(
                  height: 6.h,
                  width: 70.w,
                  child: Text(
                    locationName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.px),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
