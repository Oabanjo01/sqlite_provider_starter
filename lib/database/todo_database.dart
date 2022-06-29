import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:sqlite_provider_starter/models/todo.dart';
import 'package:sqlite_provider_starter/models/user.dart';

class TodoDatabase {
  static final instance = TodoDatabase._initialize();
  static Database? _database; // add late here to avoid error
  TodoDatabase._initialize();

  Future _createDB(Database db, int version) async {
    final userUsernameType = 'TEXT PRIMARY KEY NOT NULL';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';

    await db.execute('''
      CREATE TABLE $userTable (
        ${UserFields.username} $userUsernameType, 
        ${UserFields.name} $textType
    )
    ''');

    // commas dey cause wahala, lol 

    await db.execute('''CREATE TABLE $todoTable (
      ${TodoFields.username} $textType, 
      ${TodoFields.created} $textType, 
      ${TodoFields.done} $boolType,
      ${TodoFields.title} $textType
      FOREIGN KEY (${TodoFields.username}) REFERENCES $userTable (${UserFields.username})
      )''');
  }

  Future _onConfigure (Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future <Database> _initDB (String filename) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, filename);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: _onConfigure
    );
  }

  Future <Database?> get database async {
    if(_database != null) {
      return _database;
    } else {
      _database = await _initDB('todo.db');
      return _database;
    }
  }

  Future close() async {
    final db = await instance.database;
    db!.close();
  }

  Future <User> createDB (User user) async {
    final db = await instance.database;
    await db!.insert('${userTable}', user.toMap());
    return user;
  }

  // QUerying just one user.
  Future <User> queryUser (String username) async {
    final db = await instance.database;
    final map = await db!.query(
      '$userTable',
      columns: UserFields.allFields,
      where: '${UserFields.username} = ?',
      whereArgs: [username]
    );
    if (map.isNotEmpty) {
      return User.fromMap(map.first);
    } else {
      throw Exception('This $username not found.');
    }
  }

  // Queying all users.
  Future <List<User>> queryAllUsers () async {
    final db = await instance.database;
    final maps = await db!.query(
      '$userTable',
      orderBy: '${UserFields.username} ASC',
    );
    return maps.map((e) => User.fromMap(e)).toList();
  }

  Future <int> update (User user) async {
    final db = await instance.database;
    return db!.update(
      '$userTable', 
      user.toMap(),
      where: '${UserFields.username} = ?'  ,
      whereArgs: [user.username]
    );
  }

  Future <int> delete (String userName) async {
    final db = await instance.database;
    return db!.delete(
      '${userTable}',
      where: '${UserFields.username} = ?',
      whereArgs: ['username']
    );
  }

  Future <Todo> createTodo (Todo todo) async {
    final db = await instance.database;
    await db!.insert('${todoTable}', todo.toMap());
    return todo;
  }

  // We'd be toggling here
  Future <int> updateTodo (Todo todo) async {
    final db = await instance.database;
    todo.done = !todo.done;
    return db!.update(
      '$todoTable', 
      todo.toMap(),
      where: '${TodoFields.username} = ? AND ${TodoFields.title} = ?',
      whereArgs: [todo.username, todo.title]
    );
  }

  Future <List<Todo>> getTodos (String username) async {
    final db = await instance.database;
    final maps = await db!.query(
      '$todoTable',
      orderBy: '${TodoFields.created} DESC',
      where: '${TodoFields.username} = ?',
      whereArgs: [username]
    );
    return maps.map((e) => Todo.fromMap(e)).toList();
  }

  Future <int> deleteTodo (Todo todo) async {
    final db = await instance.database;
    return db!.delete(
      '${todoTable}',
      where: '${TodoFields.username} = ? AND ${TodoFields.title} = ?',
      whereArgs: [todo.username, todo.title]
    );
  }

  
}
