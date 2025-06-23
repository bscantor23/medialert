import 'dart:convert';

class Medication {
  int? id;
  int massUnitId;
  String massUnitSymbol = '';
  String name;
  double quantity;
  String instructions;
  String dosage;
  String time;

  Medication({
    this.id,
    required this.massUnitId,
    this.massUnitSymbol = '',
    required this.name,
    required this.quantity,
    required this.instructions,
    required this.dosage,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mass_unit_id': massUnitId,
      'quantity': quantity,
      'name': name,
      'instructions': instructions,
      'dosage': dosage,
      'time': time,
    };
  }

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

  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      id: map['id'],
      massUnitId: map['massUnitId'],
      massUnitSymbol: map['massUnitSymbol'] ?? '',
      quantity: map['quantity'],
      name: map['name'],
      instructions: map['instructions'],
      dosage: map['dosage'],
      time: map['time'],
    );
  }
}
