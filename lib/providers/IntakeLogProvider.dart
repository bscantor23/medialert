import 'package:flutter/cupertino.dart';
import 'package:medialert/dao/intake_log.dart';
import 'package:medialert/models/intake_log.dart';

class IntakeLogProvider with ChangeNotifier {
  final IntakeLogDao intakeLogDao = IntakeLogDao();

  List<IntakeLog> _intakeLogs = [];
  List<IntakeLog> get intakeLogs => _intakeLogs;

  Future<void> loadIntakeLogs() async {
    _intakeLogs = await intakeLogDao.getDayLogs();
    notifyListeners();
  }

  Future<void> updateIntakeLog(int id, String statusCode) async {
    await intakeLogDao.update(id, statusCode);
    _intakeLogs = await intakeLogDao.getDayLogs();
    notifyListeners();
  }
}
