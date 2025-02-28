import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text("Login"),
        ),
        body: Column(
      children: [
        TextField(
          controller: _email,
          decoration: const InputDecoration(hintText: "Enter email here"),
          keyboardType: TextInputType.emailAddress,
        ),
        TextField(
          controller: _password,
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          decoration: const InputDecoration(
            hintText: "Enter password here",
          ),
        ),
        TextButton(
          onPressed: () async {
            final email = _email.text;
            final password = _password.text;
            await Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform,
            );
            try {
              final userCredentials = await FirebaseAuth.instance
                  .signInWithEmailAndPassword(
                email: email,
                password: password,
              );
              print(userCredentials);
            } on FirebaseAuthException catch(e) {
              if(e.code == 'user-not-found'){
                print("User not found");
              }
              else if(e.code == 'wrong-password'){
                print("Wrong password");
              }
            }
          },
          child: const Text("Login"),
        ),
        TextButton(onPressed: (){
          Navigator.of(context).pushNamedAndRemoveUntil("/register/", (route)=>false);
        }, child: const Text("Not registered yet?? Register here"))
      ],
    ));
  }
}