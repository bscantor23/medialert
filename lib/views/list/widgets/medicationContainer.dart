import 'package:flutter/material.dart';
import 'package:medialert/models/medication.dart';
import 'package:medialert/views/list/widgets/settings.dart';

Container buildContainer({
  required Medication medication,
  required double heightView,
}) {
  return Container(
    width: double.infinity,
    height: heightView * 0.1,
    constraints: BoxConstraints(minHeight: 90),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          spreadRadius: 0,
          blurRadius: 4,
          offset: Offset(0, 4),
        ),
      ],
    ),
    margin: EdgeInsets.only(bottom: 18),

    child: LayoutBuilder(
      builder: (context, constraints) => Row(
        children: [
          SizedBox(
            width: constraints.maxWidth * 0.85,
            height: constraints.maxHeight,

            child: Padding(
              padding: EdgeInsets.only(top: 5, left: 10, bottom: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medication.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${medication.quantity} ${medication.massUnitSymbol}',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  Row(
                    children: [
                      Text(
                        medication.time,
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      SizedBox(width: 10),

                      Text(
                        medication.getDosageText(),
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 5),

          SizedBox(
            width: constraints.maxWidth * 0.1,
            height: constraints.maxHeight,
            child: Center(
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.white,
                      isScrollControlled:
                          true, // Opcional, si quieres usar más altura
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (context) => buildSettings(
                        context: context,
                        medication: medication,
                      ),
                    );
                  },
                  child: SizedBox(
                    height: constraints.minHeight * 0.5,
                    width: 40,
                    child: Center(
                      child: Icon(
                        Icons.more_vert,
                        color: Color.fromRGBO(133, 200, 193, 1),
                        size: constraints.maxHeight * 0.4,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
