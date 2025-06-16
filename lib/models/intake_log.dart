import 'dart:convert';
import 'package:medialert/models/medication_status.dart';

class IntakeLog {
  int? id;
  int medicationId;
  int medicationStatusId;
  int massUnitId;
  String massUnitSymbol = '';
  String name;
  double quantity;
  String instructions;
  String dosage;
  String time;
  String intakeDay;
  MedicationStatus? medicationStatus;

  IntakeLog({
    this.id,
    required this.medicationId,
    required this.medicationStatusId,
    required this.massUnitId,
    this.massUnitSymbol = '',
    required this.name,
    required this.quantity,
    required this.instructions,
    required this.dosage,
    required this.time,
    required this.intakeDay,
    this.medicationStatus,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'medicationId': medicationId,
    'massUnitId': massUnitId,
    'quantity': quantity,
    'name': name,
    'instructions': instructions,
    'dosage': dosage,
    'time': time,
    'intakeDay': intakeDay,
    'medicationStatus': medicationStatus?.toMap(),
  };

  String getDosageText() {
    List<dynamic> dosageList = jsonDecode(dosage);
    List<String> days = dosageList.map<String>((d) {
      switch (d) {
        case 1:
          return 'LUN';
        case 2:
          return 'MAR';
        case 3:
          return 'MIE';
        case 4:
          return 'JUE';
        case 5:
          return 'VIE';
        case 6:
          return 'SAB';
        case 7:
          return 'DOM';
        default:
          return '';
      }
    }).toList();

    return days.isEmpty || days.length == 7 ? 'DIARIO' : days.join(' - ');
  }

  factory IntakeLog.fromMap(
    Map<String, dynamic> map,
    MedicationStatus? medicationStatus,
  ) => IntakeLog(
    id: map['id'],
    medicationId: map['medication_id'],
    medicationStatusId: map['medication_status_id'],
    massUnitId: map['mass_unit_id'],
    massUnitSymbol: map['mass_unit_symbol'] ?? '',
    quantity: map['quantity'],
    name: map['name'],
    instructions: map['instructions'],
    dosage: map['dosage'],
    time: map['time'],
    intakeDay: map['intake_day'],
    medicationStatus: medicationStatus,
  );
}
