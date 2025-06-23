import 'package:flutter/material.dart';

import 'package:medialert/models/medication.dart';
import 'package:medialert/views/home/HomeView.dart';

import '../views/add/addView.dart';
import '../views/list/listMedicationsView.dart';
import '../views/record/recordView.dart';
class BaseScreenProvider with ChangeNotifier {
  Widget _vista = const HomeView();
  String _name ='Home';

  Widget get vista => _vista;
  String get name=>_name;

  void updateNameItem(String name, [Medication? medication]) {

    _name=name;
    switch (name) {
      case 'Home':
        _vista = const HomeView();
        break;
      case 'Agregar':
        _vista = AddView(medication: medication); // pasa el parámetro opcional
        break;
      case 'Lista':
        _vista = const ListMedicationsView();
        break;
      case 'Historial':
        _vista = const RecordView();
        break;
      default:
        _vista = const Center(child: Text('Página no encontrada'));
        break;
    }

    notifyListeners();
  }
}