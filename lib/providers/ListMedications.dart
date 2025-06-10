import 'package:flutter/cupertino.dart';
import 'package:medialert/dao/medication.dart';
import 'package:medialert/models/medication.dart';

class ListMedicationsProvider with ChangeNotifier {
  final MedicationDao medicationDao = MedicationDao();

  List<Medication> _medications = [];
  List<Medication> get medications => _medications;

  Future<void> loadMedications() async {
    _medications = await medicationDao.getAll();
    notifyListeners();
  }
}
