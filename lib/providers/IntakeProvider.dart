import 'package:flutter/cupertino.dart';
import 'package:medialert/dao/intake_log.dart';
import 'package:medialert/models/intake_log.dart';

class IntakeProvider with ChangeNotifier {
  final IntakeLogDao intakeLogDao = IntakeLogDao();

  List<IntakeLog> _intakeLogs = [];
  List<IntakeLog> get intakeLogs => _intakeLogs;

  Future<void> loadIntakeLogs() async {
    _intakeLogs = await intakeLogDao.getDayLogs();
    notifyListeners();
  }

  Future<void> updateIntakeLog(int id, int statusId) async {
    await intakeLogDao.update(id, statusId);
    _intakeLogs = await intakeLogDao.getDayLogs();
    notifyListeners();
  }

  Future<void> searchIntakeLogs(String search) async {
    if (search.isEmpty) {
      _intakeLogs = await intakeLogDao.getDayLogs();
    } else {
      _intakeLogs = await intakeLogDao.search(search);
    }
    notifyListeners();
  }
}
