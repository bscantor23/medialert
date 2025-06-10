import 'package:medialert/models/medication_status.dart';
import 'package:medialert/services/database.dart';

class MedicationStatusDao {
  MedicationStatusDao();

  Future<List<MedicationStatus>> getAll() async {
    final db = await DatabaseService.getDatabase();
    final maps = await db.query('medication_statuses');
    return maps.map((map) => MedicationStatus.fromMap(map)).toList();
  }
}
