import '../database/db_helper.dart';
import '../models/medication.dart';

class MedicationService {
  Future<List<Medication>> getAllMedications() async {
    final db = await DBHelper.getDatabase();
    final result = await db.query('medications');

    return result.map((map) => Medication.fromMap(map)).toList();
  }

  Future<void> insertMedication(Medication medication) async {
    final db = await DBHelper.getDatabase();
    await db.insert('medications', medication.toMap());
  }

  Future<void> deleteMedication(int id) async {
    final db = await DBHelper.getDatabase();
    await db.delete('medications', where: 'id = ?', whereArgs: [id]);
  }
}
