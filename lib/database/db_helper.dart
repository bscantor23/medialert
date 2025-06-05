import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DBHelper {
  static Database? _db;

  static Future<Database> getDatabase() async {
    if (_db != null) return _db!;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'medialert.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );

    return _db!;
  }

static Future _createDb(Database db, int version) async {
  await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      age INTEGER,
      email TEXT
    )
  ''');

  await db.execute('''
    CREATE TABLE medications (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      dosage TEXT,
      instructions TEXT,
      userId INTEGER,
      FOREIGN KEY(userId) REFERENCES users(id)
    )
  ''');

  await db.execute('''
    CREATE TABLE alerts (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      medicationId INTEGER,
      alertTime TEXT,       -- formato: "08:00", "13:30"
      frequency TEXT,       -- Ej: "Diario", "Cada 8 horas"
      isActive INTEGER,     -- 0 o 1
      FOREIGN KEY(medicationId) REFERENCES medications(id)
    )
  ''');

  await db.execute('''
    CREATE TABLE intake_logs (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      medicationId INTEGER,
      intakeTime TEXT,      -- fecha y hora: "2025-06-04 08:00"
      wasTaken INTEGER,     -- 0 o 1
      FOREIGN KEY(medicationId) REFERENCES medications(id)
    )
  ''');


  // crear usuario
  int userId = await db.insert('users', {
    'name': 'María González',
    'age': 45,
    'email': 'maria@example.com',
  });

  // crear medicamento
  int medId = await db.insert('medications', {
    'name': 'Ibuprofeno',
    'dosage': '200 mg',
    'instructions': 'Tomar después de las comidas',
    'userId': userId,
  });

  // Precargar una alerta para ese medicamento
  await db.insert('alerts', {
    'medicationId': medId,
    'alertTime': '08:00',
    'frequency': 'Cada 8 horas',
    'isActive': 1,
  });

}

}
