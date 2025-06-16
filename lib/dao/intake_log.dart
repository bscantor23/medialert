import 'dart:convert';

import 'package:intl/intl.dart';
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
    List<Map<String, dynamic>> raw;
    do {
      raw = await db.rawQuery(
        '''
      SELECT i.id, i.medication_id, i.medication_status_id, i.mass_unit_id, mu.symbol,
      i.quantity, i.name, i.instructions, i.dosage, i.time, i.intake_day
      FROM intake_logs i
      JOIN mass_units mu ON i.mass_unit_id = mu.id
      WHERE i.intake_day = ?
      ''',
        [DateTime.now().toIso8601String().split('T')[0]],
      );
      if (raw.isEmpty) {
        await populateDay();
      }
    } while (raw.isEmpty);

    final results = [...raw];
    final DateFormat timeFormat = DateFormat('hh:mm a');

    results.sort((a, b) {
      DateTime timeA = timeFormat.parse(a['time'] as String);
      DateTime timeB = timeFormat.parse(b['time'] as String);
      return timeA.compareTo(timeB);
    });

    final medicationStatuses = await MedicationStatusDao().getAll();

    return results
        .map(
          (map) => IntakeLog.fromMap(
            map,
            medicationStatuses.firstWhere(
              (status) => status.id == map['medication_status_id'],
            ),
          ),
        )
        .toList();
  }

  Future<List<IntakeLog>> search(String name) async {
    final db = await DatabaseService.getDatabase();
    List<Map<String, dynamic>> raw;
    raw = await db.rawQuery(
      '''
      SELECT i.id, i.medication_id, i.medication_status_id, i.mass_unit_id, mu.symbol,
      i.quantity, i.name, i.instructions, i.dosage, i.time, i.intake_day
      FROM intake_logs i
      JOIN mass_units mu ON i.mass_unit_id = mu.id
      WHERE i.intake_day = ? AND i.name LIKE ?
      ''',
      [DateTime.now().toIso8601String().split('T')[0], '%$name%'],
    );

    final results = [...raw];
    final DateFormat timeFormat = DateFormat('hh:mm a');

    results.sort((a, b) {
      DateTime timeA = timeFormat.parse(a['time'] as String);
      DateTime timeB = timeFormat.parse(b['time'] as String);
      return timeA.compareTo(timeB);
    });

    final medicationStatuses = await MedicationStatusDao().getAll();

    return results
        .map(
          (map) => IntakeLog.fromMap(
            map,
            medicationStatuses.firstWhere(
              (status) => status.id == map['medication_status_id'],
            ),
          ),
        )
        .toList();
  }

  Future<void> update(int id, int statusId) async {
    final db = await DatabaseService.getDatabase();
    await db.update(
      'intake_logs',
      {'medication_status_id': statusId},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
