class MedicationStatus {
  int? id;
  String name;
  String code;

  MedicationStatus({this.id, required this.name, required this.code});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'code': code};
  }

  factory MedicationStatus.fromMap(Map<String, dynamic> map) {
    return MedicationStatus(
      id: map['id'],
      name: map['name'],
      code: map['code'],
    );
  }
}
