import 'package:medialert/models/medication_status.dart';
import 'package:medialert/services/database.dart';

class MedicationStatusDao {
  MedicationStatusDao();

  Future<List<MedicationStatus>> getAll() async {
    final db = await DatabaseService.getDatabase();
    final maps = await db.query('medication_statuses', orderBy: 'id');

    return maps.map((map) => MedicationStatus.fromMap(map)).toList();
  }

  Future<MedicationStatus> getById(String id) async {
    final db = await DatabaseService.getDatabase();
    final maps = await db.query(
      'medication_statuses',
      where: 'id = ?',
      whereArgs: [id],
    );
    return maps.map((map) => MedicationStatus.fromMap(map)).toList()[0];
  }

  Future<MedicationStatus> getByCode(String code) async {
    final db = await DatabaseService.getDatabase();
    final maps = await db.query(
      'medication_statuses',
      where: 'code = ?',
      whereArgs: [code],
    );
    return maps.map((map) => MedicationStatus.fromMap(map)).toList()[0];
  }
}
