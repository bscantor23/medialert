import 'package:flutter/cupertino.dart';
import 'package:medialert/dao/medication_status.dart';
import 'package:medialert/models/medication_status.dart';

class StatusProvider with ChangeNotifier {
  final MedicationStatusDao medicationStatusDao = MedicationStatusDao();
  List<MedicationStatus> _statuses = [];
  List<MedicationStatus> get statuses => _statuses;

  Future<void> loadStatuses() async {
    _statuses = (await medicationStatusDao.getAll()).toList();
    notifyListeners();
  }
}
