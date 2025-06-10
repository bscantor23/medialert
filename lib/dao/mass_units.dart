import 'package:medialert/models/mass_unit.dart';
import 'package:medialert/services/database.dart';

class MassUnitDao {
  MassUnitDao();

  Future<List<MassUnit>> getAll() async {
    final db = await DatabaseService.getDatabase();
    final maps = await db.query('mass_units');
    return maps.map((map) => MassUnit.fromMap(map)).toList();
  }
}
