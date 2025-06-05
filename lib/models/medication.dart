class Medication {
  int? id;
  String name;
  String dosage;
  String instructions;
  int userId;

  Medication({
    this.id,
    required this.name,
    required this.dosage,
    required this.instructions,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'instructions': instructions,
      'userId': userId,
    };
  }

  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      id: map['id'],
      name: map['name'],
      dosage: map['dosage'],
      instructions: map['instructions'],
      userId: map['userId'],
    );
  }
}
