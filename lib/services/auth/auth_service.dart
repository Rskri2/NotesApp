import 'package:noteapp/services/auth/auth_user.dart';
import 'package:noteapp/services/auth/firebase_auth_provider.dart';

import 'auth_provider.dart';

class AuthService implements AuthProviders {
  final AuthProviders provider;
  const AuthService(this.provider);
  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());
  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> login({required String email, required String password}) =>
      provider.login(email: email, password: password);

  @override
  Future<void> logout() => provider.logout();

  @override
  Future<AuthUser> register({
    required String email,
    required String password,
  }) => provider.register(email: email, password: password);

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initialise() => provider.initialise();

  @override
  Future<void> sendPasswordReset({required String toEmail}) async=> provider.sendPasswordReset(toEmail: toEmail);
}
