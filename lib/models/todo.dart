import 'package:flutter/cupertino.dart';

String todoTable = 'Todotable';

class TodoFields {
  static final String username = 'username';
  static final String title = 'title';
  static final String done = 'done';
  static final String created = 'created';
  static final List<String> allFields = [username, title, done, created];
}

class Todo {
  final String username;
  final String title;
  bool done;
  final DateTime created;

  Todo({
    required this.username,
    required this.title,
    this.done = false,
    required this.created,
  });

  Map <String, Object?> toMap() => {
    TodoFields.username: username,
    TodoFields.title: title,
    TodoFields.done: done ? 1 : 0,
    TodoFields.created: created.toIso8601String()
  };
   
  static Todo fromMap (Map <String, Object?> map) => Todo(
    username: map[TodoFields.username] as String, 
    title: map[TodoFields.title] as String, 
    created: DateTime.parse(map[TodoFields.created] as String),
    done: map[TodoFields.done] == 1 ? true : false
  );

  @override 
  bool operator == (covariant Todo todo) {
    return (this.username == todo.username) && (this.title.toUpperCase().compareTo(todo.title.toUpperCase()) == 0);
  }

  @override
  int get hashCode {
    return hashValues(username, title);
  }

}


