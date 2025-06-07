import 'package:medialert/database/db_helper.dart';
import 'package:medialert/models/user.dart';

class UserDao {
  Future<int> insertUser(User user) async {
    final db = await DBHelper.getDatabase();
    return await db.insert('users', user.toMap());
  }

  Future<List<User>> getUsers() async {
    final db = await DBHelper.getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('users');
    return maps.map((map) => User.fromMap(map)).toList();
  }
}
