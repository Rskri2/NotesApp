import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:noteapp/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String loadingText;
  const AuthState({required this.isLoading, this.loadingText = 'Please wait a moment'});
}

class AuthStateUninitialised extends AuthState {
  const AuthStateUninitialised({required super.isLoading});
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering({required this.exception, required super.isLoading});
}

class AuthStateLogin extends AuthState {
  const AuthStateLogin({required super.isLoading});
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn({required this.user, required super.isLoading});
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification({required super.isLoading});
}

class AuthStateLogOut extends AuthState {
  const AuthStateLogOut({required super.isLoading});
}

class AuthStateLoggedOut extends AuthState with EquatableMixin{
  final Exception? exception;
  const AuthStateLoggedOut({required this.exception, required super.isLoading, super.loadingText});

  @override
  List<Object?> get props => [exception, isLoading];
}
class AuthStateForgotPassword extends AuthState{
  final Exception? exception;
  final bool hasSentEmail;
  const AuthStateForgotPassword({required super.isLoading, required this.exception, required this.hasSentEmail});
}
