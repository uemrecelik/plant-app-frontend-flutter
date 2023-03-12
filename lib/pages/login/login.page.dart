import 'package:flutter/material.dart';
import 'package:term_project_mobile/pages/home/home.page.dart';
import 'package:term_project_mobile/pages/login/login.servide.dart';
import 'package:term_project_mobile/pages/main/main.page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("lib/assets/loginBackground.png"),
                fit: BoxFit.cover)),
        child: Center(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(
                  height: 80,
                ),
                Container(
                  width: 300,
                  height: 400,
                  decoration: BoxDecoration(
                      color: Colors.grey[200]?.withOpacity(0.4),
                      border: Border.all(width: 0.1),
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextField(
                            controller: _usernameController,
                            obscureText: false,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Username',
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                            ),
                          ),
                          Center(
                            child: OutlinedButton(
                              onPressed: () async {
                                var username = _usernameController.text;
                                var password = _passwordController.text;
                                var jwt = await LoginService()
                                    .attemptLogIn(username, password);
                                if (jwt != null) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const MainPage(),
                                  ));
                                } else {
                                  // ignore: use_build_context_synchronously
                                  LoginService().displayDialog(
                                      context,
                                      "An Error Occurred",
                                      "No account was found matching that username and password");
                                  _passwordController.text = '';
                                  _usernameController.text = '';
                                }
                              },
                              child: const Text('Login'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
