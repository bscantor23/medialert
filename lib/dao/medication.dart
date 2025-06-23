import 'package:intl/intl.dart';
import 'package:medialert/services/database.dart';
import 'package:medialert/models/medication.dart';

class MedicationDao {
  MedicationDao();

  Future<int> insertMedication(Medication med) async {
    final db = await DatabaseService.getDatabase();
    return await db.insert('medications', med.toMap());
  }

  Future<List<Medication>> getAll() async {
    final db = await DatabaseService.getDatabase();
    final raw = await db.rawQuery('''
      SELECT m.id, m.mass_unit_id as massUnitId, mu.symbol AS massUnitSymbol,
      m.quantity, m.name, m.instructions, m.dosage, m.time
      FROM medications m
      JOIN mass_units mu ON m.mass_unit_id = mu.id
    ''');

    final DateFormat timeFormat = DateFormat('hh:mm a');

    final results = [...raw];
    results.sort((a, b) {
      DateTime timeA = timeFormat.parse(a['time'] as String);
      DateTime timeB = timeFormat.parse(b['time'] as String);
      return timeA.compareTo(timeB);
    });

    //final results = sortByTime(raw, 'hh:mm a', 'time');
    return results.map((map) => Medication.fromMap(map)).toList();
  }

  Future<void> delete(int id) async {
    final db = await DatabaseService.getDatabase();
    await db.delete('medications', where: 'id = ?', whereArgs: [id]);

    await db.delete(
      'intake_logs',
      where: 'medication_id = ? AND intake_day = ?',
      whereArgs: [id, DateTime.now().toIso8601String().split('T')[0]],
    );
  }
}
