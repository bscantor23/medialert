class Alert {
  int? id;
  int medicationId;
  String alertTime;
  String frequency;
  int isActive;

  Alert({
    this.id,
    required this.medicationId,
    required this.alertTime,
    required this.frequency,
    required this.isActive,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'medicationId': medicationId,
    'alertTime': alertTime,
    'frequency': frequency,
    'isActive': isActive,
  };

  factory Alert.fromMap(Map<String, dynamic> map) => Alert(
    id: map['id'],
    medicationId: map['medicationId'],
    alertTime: map['alertTime'],
    frequency: map['frequency'],
    isActive: map['isActive'],
  );
}
