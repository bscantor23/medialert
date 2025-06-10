import 'dart:convert';

class IntakeLog {
  int? id;
  int medicationId;
  int medicationStatusId;
  String statusName = '';
  int massUnitId;
  String massUnitSymbol = '';
  String name;
  double quantity;
  String instructions;
  String dosage;
  String time;
  String intakeDay;

  IntakeLog({
    this.id,
    required this.medicationId,
    required this.medicationStatusId,
    this.statusName = '',
    required this.massUnitId,
    this.massUnitSymbol = '',
    required this.name,
    required this.quantity,
    required this.instructions,
    required this.dosage,
    required this.time,
    required this.intakeDay,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'medicationId': medicationId,
    'medicationStatusId': medicationStatusId,
    'massUnitId': massUnitId,
    'quantity': quantity,
    'name': name,
    'instructions': instructions,
    'dosage': dosage,
    'time': time,
    'intakeDay': intakeDay,
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

  factory IntakeLog.fromMap(Map<String, dynamic> map) => IntakeLog(
    id: map['id'],
    medicationId: map['medicationId'],
    medicationStatusId: map['medicationStatusId'],
    statusName: map['statusName'] ?? '',
    massUnitId: map['massUnitId'],
    massUnitSymbol: map['massUnitSymbol'] ?? '',
    quantity: map['quantity'],
    name: map['name'],
    instructions: map['instructions'],
    dosage: map['dosage'],
    time: map['time'],
    intakeDay: map['intakeDay'],
  );
}
