import 'package:medialert/models/medication_status.dart';

class Historic {
  int? id;
  String name;
  String time;
  MedicationStatus? medicationStatus;

  Historic({
    this.id,
    required this.name,
    required this.time,
    this.medicationStatus,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'time': time,
    'medicationStatus': medicationStatus?.toMap(),
  };

  factory Historic.fromMap(
    Map<String, dynamic> map,
    MedicationStatus? medicationStatus,
  ) => Historic(
    id: map['id'],
    name: map['name'],
    time: map['time'],
    medicationStatus: medicationStatus,
  );
}
