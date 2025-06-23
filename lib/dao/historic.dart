import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:medialert/models/Historic.dart';
import 'package:medialert/services/database.dart';
import 'package:medialert/dao/medication_status.dart';

class HistoricDao {
  HistoricDao();

  Future<List<Map<String, Object?>>> getMedicationsByDate(
    DateTime selectedDay,
  ) async {
    final db = await DatabaseService.getDatabase();
    final weekday = selectedDay.weekday; // 1 = Monday, 7 = Sunday

    final medications = await db.rawQuery(
      '''
      SELECT m.id, m.name, m.time, m.dosage
      FROM medications m
      ''');

    final raw = <Map<String, Object?>>[];
    for (var medication in medications) {
      final medDosage =
          jsonDecode(medication['dosage'] as String) as List<dynamic>;

      if (medDosage.contains(weekday)) {
        raw.add(medication);
      }
    }

    return raw.map((medication) {
      return {
        'id': medication['id'],
        'name': medication['name'],
        'time': medication['time'],
        'medication_status_code': 'P',
      };
    }).toList();
  }

  Future<List<Historic>> getHistoric(DateTime selectedDay) async {
    final db = await DatabaseService.getDatabase();
    List<Map<String, dynamic>> raw;
    raw = await db.rawQuery(
      '''
      SELECT i.id, i.name, ms.code as 'medication_status_code', i.time
      FROM intake_logs i
      JOIN medication_statuses ms ON i.medication_status_id = ms.id
      WHERE i.intake_day = ?
      ''',
      [selectedDay.toIso8601String().split('T')[0]],
    );

    if (raw.isEmpty && selectedDay.isAfter(DateTime.now().subtract(Duration(days: 1)))) {
      raw = await getMedicationsByDate(selectedDay);
    }

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
          (map) => Historic.fromMap(
            map,
            medicationStatuses.firstWhere(
              (status) => status.code == map['medication_status_code'],
            ),
          ),
        )
        .toList();
  }
}
