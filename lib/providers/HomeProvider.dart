import 'package:flutter/cupertino.dart';
import 'package:medialert/services/database.dart';

class HomeProvider with ChangeNotifier {
  Future<void> loadDatabase() async {
    await DatabaseService.getDatabase();
    notifyListeners();
  }
}
