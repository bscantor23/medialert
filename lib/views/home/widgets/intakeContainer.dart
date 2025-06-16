import 'package:flutter/material.dart';
import 'package:medialert/models/intake_log.dart';
import 'package:medialert/providers/IntakeProvider.dart';
import 'package:medialert/providers/StatusProvider.dart';
import 'package:medialert/views/home/widgets/statusButtons.dart';

Container buildIntakeContainer({
  required IntakeLog intakeLog,
  required StatusProvider statusProvider,
  required IntakeProvider intakeProvider,
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
    margin: EdgeInsets.only(top: 10, bottom: 10),
    child: LayoutBuilder(
      builder: (context, constraints) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              SizedBox(
                width: constraints.maxWidth * 0.6,
                height: constraints.maxHeight * 0.68,
                child: Padding(
                  padding: EdgeInsets.only(top: 5, left: 10, bottom: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        intakeLog.name,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${intakeLog.quantity} ${intakeLog.massUnitSymbol}',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 5),
              SizedBox(
                width: constraints.maxWidth * 0.35,
                height: constraints.maxHeight * 0.6,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.white,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (context) => buildStatusButtons(
                          context: context,
                          statusProvider: statusProvider,
                          intakeProvider: intakeProvider,
                          intakeLog: intakeLog,
                        ),
                      );
                    },
                    child: buildStatusIntakeButton(constraints, intakeLog),
                  ),
                ),
              ),
            ],
          ),
          // Second row: Time and dosage
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Text(
                  intakeLog.time,
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
                SizedBox(width: 10),
                Text(
                  intakeLog.getDosageText(),
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
