import 'package:flutter/cupertino.dart';
import 'package:medialert/dao/historic.dart';
import 'package:medialert/models/Historic.dart';

class HistoricProvider with ChangeNotifier {
  final HistoricDao historicDao = HistoricDao();

  List<Historic> _historics = [];
  List<Historic> get historics => _historics;

  Future<void> loadHistorics(DateTime selectedDay) async {
    _historics = await historicDao.getHistoric(selectedDay);
    notifyListeners();
  }
}
