import 'package:medialert/db/db_helper.dart';
import 'package:medialert/models/alert.dart';

class AlertDao {
  Future<int> insertAlert(Alert alert) async {
    final db = await DBHelper.getDatabase();
    return await db.insert('alerts', alert.toMap());
  }

  Future<List<Alert>> getAlertsForMedication(int medId) async {
    final db = await DBHelper.getDatabase();
    final maps = await db.query('alerts', where: 'medicationId = ?', whereArgs: [medId]);
    return maps.map((map) => Alert.fromMap(map)).toList();
  }
}
