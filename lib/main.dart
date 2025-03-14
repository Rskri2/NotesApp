import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteapp/helpers/loading/loading_screen.dart';
import 'package:noteapp/services/auth/bloc/auth_bloc.dart';
import 'package:noteapp/services/auth/bloc/auth_events.dart';
import 'package:noteapp/services/auth/bloc/auth_state.dart';
import 'package:noteapp/services/auth/firebase_auth_provider.dart';
import 'package:noteapp/views/forgot_password.dart';
import 'package:noteapp/views/login_view.dart';
import 'package:noteapp/views/notes/notes_view.dart';
import 'package:noteapp/views/register_view.dart';
import 'package:noteapp/views/verify_email.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialise());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(context: context, text: state.loadingText);
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return NotesView();
        } else if (state is AuthStateNeedsVerification) {
          return VerifyEmail();
        } else if(state is AuthStateForgotPassword){
          return ForgotPassword();
        } else if (state is AuthStateLoggedOut) {
          return LoginView();
        } else if (state is AuthStateRegistering) {
          return RegisterView();
        } else {
          return const Scaffold(
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10.0),
                Text("Loading.."),
              ],
            ),
          );
        }
      },
    );
  }
}
