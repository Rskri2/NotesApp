import 'package:flutter/cupertino.dart';

@immutable
abstract class AuthEvent{
  const AuthEvent();
}

class AuthEventInitialise extends AuthEvent{
  const AuthEventInitialise();
}

class AuthEventLogin extends AuthEvent{
  final String email;
  final String password;
  const AuthEventLogin(this.email, this.password,);
}

class AuthEventLogout extends AuthEvent{
  const AuthEventLogout();
}

class AuthEventSendEmailVerification extends AuthEvent{
  const AuthEventSendEmailVerification();
}

class AuthEventRegister extends AuthEvent{
  final String email;
  final String password;
  const AuthEventRegister(this.email, this.password);
}

class AuthEventShouldRegister extends AuthEvent{
  const AuthEventShouldRegister();
}

class AuthEventForgotPassword extends AuthEvent{
  final String? email;
  const AuthEventForgotPassword(this.email);
}