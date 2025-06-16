import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medialert/providers/IntakeProvider.dart';

class Constants {
  static const String nextIntakeTitle = 'Próxima toma';
  static const String takenState = 'tomas registradas';
  static const String noResults = 'No hay resultados';
  static const String completed = 'Medicación completada';
}

Container buildCardNextMedication(IntakeProvider intakeProvider) {
  final waitingLogs = intakeProvider.intakeLogs
      .where((log) => log.medicationStatus!.code == 'P')
      .toList();

  final registeredLogs = intakeProvider.intakeLogs
      .where((log) => log.medicationStatus!.code != 'P')
      .toList();

  final nextLog = waitingLogs.isNotEmpty ? waitingLogs.first : null;

  final percentage = (registeredLogs.length / intakeProvider.intakeLogs.length)
      .clamp(0.0, 1.0);

  String name = '';
  if (nextLog == null) {
    name = Constants.noResults;
    if (registeredLogs.isNotEmpty) {
      name = Constants.completed;
    }
  } else {
    name = nextLog.name;
  }

  return Container(
    width: double.infinity,
    height: 140,
    constraints: BoxConstraints(minHeight: 140),
    decoration: BoxDecoration(
      color: Color.fromRGBO(7, 170, 151, 1),
      borderRadius: BorderRadius.circular(10),
    ),
    child: LayoutBuilder(
      builder: (context, constraints) => Column(
        children: [
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(
                width: constraints.maxWidth * 0.25,
                height: constraints.maxHeight - 20,
                child: Center(
                  child: SvgPicture.asset('assets/icons/add-black.svg'),
                ),
              ),
              SizedBox(
                width: constraints.maxWidth * 0.70,
                height: constraints.maxHeight - 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      Constants.nextIntakeTitle,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    SizedBox(height: 5),
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    LinearProgressIndicator(
                      value: percentage, // 60% de progreso
                      color: Colors.tealAccent,
                      borderRadius: BorderRadius.circular(10),
                      backgroundColor: Colors.teal.shade100,
                    ),
                    SizedBox(height: 5),
                    Text(
                      '${(percentage * 100).toStringAsFixed(0)} % completado',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      '${registeredLogs.length}/${intakeProvider.intakeLogs.length} ${Constants.takenState}',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
