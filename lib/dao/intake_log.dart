import 'dart:convert';

import 'package:medialert/services/database.dart';
import 'package:medialert/dao/medication_status.dart';
import 'package:medialert/models/intake_log.dart';

class IntakeLogDao {
  IntakeLogDao();

  Future<void> populateDay() async {
    final db = await DatabaseService.getDatabase();

    final now = DateTime.now();
    final dateString = now.toIso8601String().split('T')[0];
    final weekday = now.weekday; // 1 = Monday, 7 = Sunday

    final medications = await db.rawQuery('''
      SELECT m.id, m.mass_unit_id as massUnitId, mu.symbol AS massUnitSymbol,
      m.quantity, m.name, m.instructions, m.dosage, m.time
      FROM medications m
      JOIN mass_units mu ON m.mass_unit_id = mu.id
    ''');

    final batch = db.batch();
    for (var medication in medications) {
      final medId = medication['id'] as int;
      final medName = medication['name'] as String;
      final medDosage =
          jsonDecode(medication['dosage'] as String) as List<dynamic>;

      if (medDosage.contains(weekday)) {
        final medStatus = await MedicationStatusDao().getByCode('P');
        batch.insert('intake_logs', {
          'medication_id': medId,
          'medication_status_id': medStatus.id,
          'mass_unit_id': medication['massUnitId'] as int,
          'name': medName,
          'quantity': medication['quantity'] as double,
          'instructions': medication['instructions'] as String,
          'dosage': medication['dosage'] as String,
          'time': medication['time'] as String,
          'intake_day': dateString,
        });
      }
    }

    await batch.commit(noResult: true);
  }

  Future<List<IntakeLog>> getDayLogs() async {
    final db = await DatabaseService.getDatabase();
    List<Map<String, dynamic>> maps;
    do {
      maps = await db.rawQuery(
        '''
      SELECT i.id, i.medication_id as medicationId, i.medication_status_id as medicationStatusId, 
      ms.name as statusName, i.mass_unit_id as massUnitId, mu.symbol AS massUnitSymbol,
      i.quantity, i.name, i.instructions, i.dosage, i.time, i.intake_day as intakeDay
      FROM intake_logs i
      JOIN mass_units mu ON i.mass_unit_id = mu.id
      JOIN medication_statuses ms ON i.medication_status_id = ms.id
      WHERE i.intake_day = ?
      ''',
        [DateTime.now().toIso8601String().split('T')[0]],
      );
      if (maps.isEmpty) {
        await populateDay();
      }
    } while (maps.isEmpty);

    return maps.map((map) => IntakeLog.fromMap(map)).toList();
  }

  Future<void> update(int id, String statusCode) async {
    final db = await DatabaseService.getDatabase();
    final medStatus = await MedicationStatusDao().getByCode(statusCode);

    await db.update(
      'intake_logs',
      {'medication_status_id': medStatus.id},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
