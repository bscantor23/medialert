import 'package:medialert/database/db_helper.dart';
import 'package:medialert/models/medication.dart';

class MedicationDao {
  Future<int> insertMedication(Medication med) async {
    final db = await DBHelper.getDatabase();
    return await db.insert('medications', med.toMap());
  }

  Future<List<Medication>> getMedicationsByUser(int userId) async {
    final db = await DBHelper.getDatabase();
    final maps = await db.query('medications', where: 'userId = ?', whereArgs: [userId]);
    return maps.map((map) => Medication.fromMap(map)).toList();
  }

  /**
   * final MedicationDao dao = MedicationDao();

      final newMedication = Medication(
      name: 'Acetaminofen',
      dosage: '500mg',
      instructions: 'Tomar cada 8 horas después de comer',
      userId: 1,
      );

      await dao.insertMedication(newMedication);
   *
   */
}





