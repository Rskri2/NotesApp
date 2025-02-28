import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
    return Scaffold(appBar: AppBar(
      title: const Text("Register"),
      backgroundColor: Colors.blue,
    ),
        body:Column(
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
                  .createUserWithEmailAndPassword(
                email: email,
                password: password,
              );
              print(userCredentials);
            } on FirebaseAuthException catch (e) {
              if(e.code == 'weak-password'){
                print("Weak password");
              } else if(e.code == 'email-already-in-use'){
                print("Email already in use");
              }
              else if(e.code == 'invalid-email'){
                print("Email is invalid");
              }
              print(e.code);
            }
          },
          child: const Text("Register"),
        ),
        TextButton(onPressed: (){
          Navigator.of(context).pushNamedAndRemoveUntil("/login/", (route)=>false);
        }, child: const Text("Already have an account?Login"))
      ],
    ));
  }
}

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}