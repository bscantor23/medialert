import 'package:flutter/material.dart';
import 'package:medialert/models/intake_log.dart';
import 'package:medialert/models/medication_status.dart';
import 'package:medialert/providers/IntakeProvider.dart';
import 'package:medialert/providers/StatusProvider.dart';
import 'package:provider/provider.dart';

class Constants {
  static const String modalTitle = 'Selecciona el nuevo estado';
  static const String noStatuses = 'No hay estados disponibles';
}

Container buildStatusButtons({
  required BuildContext context,
  required StatusProvider statusProvider,
  required IntakeProvider intakeProvider,
  required IntakeLog intakeLog,
}) {
  statusProvider.loadStatuses();

  return Container(
    height: MediaQuery.of(context).size.height / 2.5,

    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    ),
    child: LayoutBuilder(
      builder: (context, constraints) => Column(
        children: [
          SizedBox(height: 10),
          Container(
            height: 5,
            width: 50,
            decoration: BoxDecoration(
              color: Color.fromRGBO(133, 200, 193, 1),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          SizedBox(height: 10),
          Text(
            Constants.modalTitle,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),

          Consumer<StatusProvider>(
            builder: (context, provider, child) {
              if (provider.statuses.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      Constants.noStatuses,
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                  ),
                );
              }else{
                
              }
              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: provider.statuses.length,
                itemBuilder: (context, index) {
                  final status = provider.statuses[index];
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        intakeProvider.updateIntakeLog(
                          intakeLog.id!,
                          status.id!,
                        );
                      },
                      child: Container(
                        height: constraints.minHeight * 0.2,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(status.backgroundColor),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5, right: 10),
                          child: Row(
                            children: [
                              ClipOval(
                                child: Container(
                                  width: constraints.maxHeight * 0.15,
                                  height: constraints.maxHeight * 0.15,
                                  color: Color(status.circleIconColor),
                                  child: Center(
                                    child: Icon(
                                      IconData(
                                        status.icon,
                                        fontFamily: 'MaterialIcons',
                                      ),
                                      color: Color(status.iconColor),
                                      size: constraints.maxHeight * 0.14,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(width: 20),

                              Text(
                                status.name,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(status.textColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    ),
  );
}

Container buildStatusIntakeButton(
  BoxConstraints constraints,
  IntakeLog intakeLog,
) {
  MedicationStatus status = intakeLog.medicationStatus!;

  return Container(
    height: constraints.minHeight * 0.5,
    width: double.infinity,
    decoration: BoxDecoration(
      color: Color(status.backgroundColor),
      borderRadius: BorderRadius.circular(30),
    ),
    child: Padding(
      padding: const EdgeInsets.only(left: 5, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipOval(
            child: Container(
              width: constraints.maxHeight * 0.4,
              height: constraints.maxHeight * 0.4,
              color: Color(status.circleIconColor),
              child: Center(
                child: Icon(
                  IconData(status.icon, fontFamily: 'MaterialIcons'),
                  color: Color(status.iconColor),
                  size: constraints.maxHeight * 0.4,
                ),
              ),
            ),
          ),
          SizedBox(width: 20),
          Align(
            child: Text(
              status.name,
              style: TextStyle(fontSize: 15, color: Color(status.textColor)),
            ),
          ),
        ],
      ),
    ),
  );
}
