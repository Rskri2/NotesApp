import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteapp/services/auth/bloc/auth_bloc.dart';
import 'package:noteapp/services/auth/bloc/auth_events.dart';
import 'package:noteapp/services/auth/bloc/auth_state.dart';
import 'package:noteapp/views/utilities/dialog/error_dialog.dart';
import '../services/auth/auth_exception.dart';

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundException) {
            await showErrorDialog(
              context,
              "Cannot find a user with entered credentials",
            );
          } else if (state.exception is WrongPasswordException) {
            await showErrorDialog(context, "Wrong credentials");
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, "Authentication error");
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text("Login"),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text('Please log in your account'),
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
                  context.read<AuthBloc>().add(AuthEventLogin(email, password));
                },
                child: const Text("Login"),
              ),
              TextButton(
                onPressed: () async {
                  context.read<AuthBloc>().add(AuthEventForgotPassword(null));
                },
                child: const Text("Forgot password? Click here to reset"),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventShouldRegister());
                },
                child: const Text("Not registered yet? Register here"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
