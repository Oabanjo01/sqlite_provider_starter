final String userTable = 'usertable';

class UserFields {
  static final String username = 'username';
  static final String name = 'name';
  static final List<String> allFields = [username, name];
}

class User {
  final String username;
  String name;

  User({
    required this.username,
    required this.name,
  });

  Map <String, Object?> toMap() => {
    UserFields.username: username,
    UserFields.name: name
  };

  static User fromMap(Map <String, Object?> map) => User(
    username: map[UserFields.username] as String, 
    name: map[UserFields.name] as String
  );
}
