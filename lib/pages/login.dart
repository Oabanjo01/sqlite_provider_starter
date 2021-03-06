import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlite_provider_starter/pages/todo_page.dart';
import 'package:sqlite_provider_starter/routes/routes.dart';
import 'package:sqlite_provider_starter/services/todo_service.dart';
import 'package:sqlite_provider_starter/services/user_service.dart';
import 'package:sqlite_provider_starter/widgets/app_textfield.dart';
import 'package:sqlite_provider_starter/widgets/dialogs.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController usernameController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple, Colors.blue],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Text(
                    'Welcome',
                    style: TextStyle(
                        fontSize: 46,
                        fontWeight: FontWeight.w200,
                        color: Colors.white),
                  ),
                ),
                AppTextField(
                  controller: usernameController,
                  labelText: 'Please enter username',
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (usernameController.text.isEmpty) {
                        showSnackBar(context, 'What is yor username?');
                      } else {
                        String result = await context
                            .read<UserService>()
                            .getUsers(usernameController.text.trim());
                        if (result != 'OK!') {
                          showSnackBar(context, result);
                        } else {
                          String name = context.read<UserService>().currentUser.name;
                          context
                              .read<TodoService>()
                              .getTodos(name);
                          Navigator.of(context).pushNamed(
                            RouteManager.todoPage,
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.purple,
                    ),
                    child: Text('Continue'),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(RouteManager.registerPage);
                  },
                  child: Text('Register a new User'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
