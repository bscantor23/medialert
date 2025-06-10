import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseService {
  static Database? _db;

  static final String _medicationsTableName = 'medications';
  static final String _massUnitsTableName = 'mass_units';
  static final String _intakeLogsTableName = 'intake_logs';
  static final String _medicationStatusTableName = 'medication_statuses';

  DatabaseService._constructor();

  static Future<Database> getDatabase() async {
    if (_db != null) return _db!;
    await initDatabase();
    return _db!;
  }

  static Future<Database> initDatabase() async {
    var databaseDirPath = await getDatabasesPath();
    String databasePath = join(databaseDirPath, 'medialert.db');

    await deleteDatabase(databasePath);

    _db = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $_massUnitsTableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            symbol TEXT NOT NULL
          )
          ''');

        await db.execute('''
          CREATE TABLE $_medicationStatusTableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            code TEXT NOT NULL
          )
          ''');

        await db.execute('''
          CREATE TABLE $_medicationsTableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            mass_unit_id INTEGER NOT NULL,
            quantity REAL NOT NULL,
            name TEXT NOT NULL,
            instructions TEXT NOT NULL,
            dosage TEXT NOT NULL,
            time TEXT NOT NULL,
            FOREIGN KEY(mass_unit_id) REFERENCES $_massUnitsTableName(id)
          )
        ''');

        await db.execute('''
          CREATE TABLE $_intakeLogsTableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            medication_id INTEGER NOT NULL,
            medication_status_id INTEGER NOT NULL,
            FOREIGN KEY(medication_id) REFERENCES medications(id)
            FOREIGN KEY(medication_status_id) REFERENCES medication_statuses(id)
          )
        ''');
      },
    );

    // Populate the database with initial data
    await populateDatabase();

    return _db!;
  }

  static Future<void> populateDatabase() async {
    await _db!.transaction((txn) async {
      await txn.rawInsert(
        'INSERT INTO $_massUnitsTableName (name, symbol) VALUES (?, ?)',
        ['Gramos', 'g'],
      );
      await txn.rawInsert(
        'INSERT INTO $_massUnitsTableName (name, symbol) VALUES (?, ?)',
        ['Miligramos', 'mg'],
      );
      await txn.rawInsert(
        'INSERT INTO $_massUnitsTableName (name, symbol) VALUES (?, ?)',
        ['Kilogramos', 'kg'],
      );
      await txn.rawInsert(
        'INSERT INTO $_massUnitsTableName (name, symbol) VALUES (?, ?)',
        ['Libras', 'lb'],
      );
      await txn.rawInsert(
        'INSERT INTO $_massUnitsTableName (name, symbol) VALUES (?, ?)',
        ['Onzas', 'oz'],
      );
      await txn.rawInsert(
        'INSERT INTO $_massUnitsTableName (name, symbol) VALUES (?, ?)',
        ['Mililitros', 'ml'],
      );
      await txn.rawInsert(
        'INSERT INTO $_massUnitsTableName (name, symbol) VALUES (?, ?)',
        ['Litros', 'l'],
      );

      await txn.rawInsert(
        'INSERT INTO $_medicationStatusTableName (name, code) VALUES (?, ?)',
        ['Espera', 'P'],
      );
      await txn.rawInsert(
        'INSERT INTO $_medicationStatusTableName (name, code) VALUES (?, ?)',
        ['Tomado', 'T'],
      );
      await txn.rawInsert(
        'INSERT INTO $_medicationStatusTableName (name, code) VALUES (?, ?)',
        ['Saltado', 'S'],
      );

      await txn.rawInsert(
        'INSERT INTO $_medicationsTableName (mass_unit_id, quantity, name, instructions, dosage, time) VALUES (?, ?, ?, ?, ?, ?)',
        [1, 500.0, 'Paracetamol', 'Tomar cada 8 horas', '[0, 1, 2]', '08:00'],
      );
      await txn.rawInsert(
        'INSERT INTO $_medicationsTableName (mass_unit_id, quantity, name, instructions, dosage, time) VALUES (?, ?, ?, ?, ?, ?)',
        [2, 250.0, 'Ibuprofeno', 'Tomar cada 6 horas', '[3, 4]', '12:00'],
      );

      await txn.rawInsert(
        'INSERT INTO $_medicationsTableName (mass_unit_id, quantity, name, instructions, dosage, time) VALUES (?, ?, ?, ?, ?, ?)',
        [
          3,
          1000.0,
          'Amoxicilina',
          'Tomar cada 24 horas',
          '[0,1,2,3,4,5,6]',
          '09:00',
        ],
      );
      await txn.rawInsert(
        'INSERT INTO $_medicationsTableName (mass_unit_id, quantity, name, instructions, dosage, time) VALUES (?, ?, ?, ?, ?, ?)',
        [
          4,
          750.0,
          'Metformina',
          'Tomar cada 12 horas',
          '[0,1,2,3,4,5]',
          '20:00',
        ],
      );
    });
  }
}
