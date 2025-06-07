import 'package:medialert/database/db_helper.dart';
import 'package:medialert/models/intake_log.dart';

class IntakeLogDao {
  Future<int> insertLog(IntakeLog log) async {
    final db = await DBHelper.getDatabase();
    return await db.insert('intake_logs', log.toMap());
  }

  Future<List<IntakeLog>> getLogsByMedication(int medId) async {
    final db = await DBHelper.getDatabase();
    final maps = await db.query('intake_logs', where: 'medicationId = ?', whereArgs: [medId]);
    return maps.map((map) => IntakeLog.fromMap(map)).toList();
  }
}
