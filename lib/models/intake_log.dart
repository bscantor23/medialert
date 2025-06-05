class IntakeLog {
  int? id;
  int medicationId;
  String intakeTime;
  int wasTaken;

  IntakeLog({
    this.id,
    required this.medicationId,
    required this.intakeTime,
    required this.wasTaken,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'medicationId': medicationId,
    'intakeTime': intakeTime,
    'wasTaken': wasTaken,
  };

  factory IntakeLog.fromMap(Map<String, dynamic> map) => IntakeLog(
    id: map['id'],
    medicationId: map['medicationId'],
    intakeTime: map['intakeTime'],
    wasTaken: map['wasTaken'],
  );
}
