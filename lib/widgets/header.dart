import 'package:flutter/material.dart';
import 'package:medialert/widgets/waveClipper.dart';

ClipPath buildHeader(
  double widthView,
  double heightView,
  String title,
  double minHeight,
) {
  return ClipPath(
    clipper: WaveClipper(),
    child: Container(
      width: widthView,
      height: heightView * 0.25,
      padding: EdgeInsets.only(top: 20),
      constraints: BoxConstraints(minHeight: minHeight),
      color: Color.fromRGBO(7, 170, 151, 1),
      child: Padding(
        padding: EdgeInsets.only(right: 20, left: 20, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SafeArea(
                  child: SizedBox(
                    width: (widthView / 1.5),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        height: 1.05,
                      ),
                    ),
                  ),
                ),
                ClipOval(
                  child: Container(
                    color: Colors.white,
                    width: widthView * 0.13,
                    height: widthView * 0.13,
                    child: Center(
                      child: Icon(
                        Icons.notifications_none,
                        color: Colors.black,
                        size: widthView * 0.09,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    ),
  );
}
