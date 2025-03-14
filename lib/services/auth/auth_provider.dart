import 'package:noteapp/services/auth/auth_user.dart';

abstract class AuthProviders{
  Future<void> initialise();
  AuthUser? get currentUser;

  Future<AuthUser> login({
    required String email,
    required String password
  });

  Future<AuthUser> register({
    required String email,
    required String password
  });

  Future<void> logout();

  Future<void> sendEmailVerification();

  Future<void> sendPasswordReset({required String toEmail});
}