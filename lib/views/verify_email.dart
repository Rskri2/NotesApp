import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_events.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Email verification"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          const Text(
            "We've sent you an email verification link.Please open it to verify your email.",
          ),
          TextButton(
            onPressed: ()  {
              context.read<AuthBloc>().add(const AuthEventSendEmailVerification());

            },
            child: const Text(
              "If you haven't received email verification mail, press the button below",
            ),
          ),
          TextButton(
            onPressed: () async {
              context.read<AuthBloc>().add(const AuthEventLogout());

            },
            child: const Text("Restart"),
          ),
        ],
      ),
    );
  }
}
