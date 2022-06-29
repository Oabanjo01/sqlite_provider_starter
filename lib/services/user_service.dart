import 'package:flutter/material.dart';
import 'package:sqlite_provider_starter/database/todo_database.dart';
import 'package:sqlite_provider_starter/models/user.dart';

class UserService with ChangeNotifier {
  late User _currentUser;
  bool _busyCreate = false;
  bool _userExists = false;

  User get currentUser => _currentUser;
  bool get busyCreate => _busyCreate;
  bool get userExists => _userExists;

  set userExists (bool value) {
    _userExists = value;
    notifyListeners();
  }

  Future <String> getUsers (String username) async {
    String result = 'OK!';

    try {
      _currentUser = await TodoDatabase.instance.queryUser(username);
      notifyListeners();
    } catch (e) {
      result = getHumanReadableError(e.toString());
    }

    return result;
  }

  Future <String> checkifUserExists (String username) async {
    String result = 'OK!';

    try {
      await TodoDatabase.instance.queryUser(username);
      // if it throws an exception in this case, its fine, since we know the user does not exist
    } catch (e) {
      result = getHumanReadableError(e.toString());
    }
    return result;
  }

  Future <String> updateUser (String name) async {
    String result = 'OK!';
    _currentUser.name = name;
    notifyListeners(); 
    try {
      await TodoDatabase.instance.update(_currentUser);
    } catch (e) {
      result = getHumanReadableError(e.toString());
    }
    return result;
  }

  Future <String> createUser (User user) async {
    String result = 'OK!';
    _busyCreate = true;
     notifyListeners();
     try {
       await TodoDatabase.instance.createDB(user);
       await Future.delayed(Duration(seconds: 2));
     } catch (e) {
       result = getHumanReadableError(e.toString());
     }
     _busyCreate = false;
     return result;
  }



}

String getHumanReadableError(String message) {
  if (message.contains('UNIQUE constraint failed')) {
    return 'This user already exists in the database. Please choose a new one.';
  }
  if (message.contains('not found in the database')) {
    return 'The user does not exist in the database. Please register first.';
  }
  return message;
}
