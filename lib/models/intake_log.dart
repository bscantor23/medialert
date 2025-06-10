class IntakeLog {
  int? id;
  int medicationId;
  int medicationStatusId;

  IntakeLog({
    this.id,
    required this.medicationId,
    required this.medicationStatusId,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'medicationId': medicationId,
    'medicationStatusId': medicationStatusId,
  };

  factory IntakeLog.fromMap(Map<String, dynamic> map) => IntakeLog(
    id: map['id'],
    medicationId: map['medicationId'],
    medicationStatusId: map['medicationStatusId'],
  );
}
