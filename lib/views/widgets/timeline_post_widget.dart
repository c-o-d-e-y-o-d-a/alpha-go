import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TimelineItem extends StatelessWidget {
  final int index;
  final String imageUrl;
  final String timestamp;

  const TimelineItem({
    Key? key,
    required this.index,
    required this.imageUrl,
    required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3.h, horizontal: 2.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffb4914b), width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 40.h,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffb4914b)),
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: CachedNetworkImageProvider(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Text(
              timestamp,
              style: TextStyle(
                color: const Color(0xffb4914b),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
