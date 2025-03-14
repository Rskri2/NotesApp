import 'package:flutter_test/flutter_test.dart';
import 'package:noteapp/services/auth/auth_exception.dart';
import 'package:noteapp/services/auth/auth_provider.dart';
import 'package:noteapp/services/auth/auth_user.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test('Should not begin with initialised', () {
      expect(provider._isInitialised, false);
    });
    test('Cannot logout before login', () {
      expect(
        provider.logout(),
        throwsA(TypeMatcher<NotInitialisedException>()),
      );
    });
    test('Should be able to initialise', () async {
      await provider.initialise();
      expect(provider.isInitialised, true);
    });
    test('User should be null after initialisation', () async {
      expect(provider.currentUser, null);
    });
    test(
      'Should be able to initialise in 2 seconds',
      () async {
        await provider.initialise();
        expect(provider.isInitialised, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );
    test('User should be able to login', () async {
      expect(
        () => provider.login(email: 'temp@gmail.com', password: 'other'),
        throwsA(isInstanceOf<UserNotFoundException>()),
      );

      expect(
        () => provider.login(email: 'tempval@gmail.com', password: 'temp'),
        throwsA(isInstanceOf<WrongPasswordException>()),
      );
      //
      var goodCredentials = await provider.login(
        email: 'tempval@gmail.com',
        password: 'any',
      );
      expect(provider.currentUser, goodCredentials);
      expect(goodCredentials.isEmailVerified, false);
    });

    test('Should be able to verify email address', () async {
      await provider.sendEmailVerification();
      expect(provider.currentUser?.isEmailVerified, true);
    });
    test('Should be able login and logout', () async {
      await provider.logout();
      expect(provider.currentUser, null);
      var goodCredentials = await provider.register(
        email: 'tempval@gmail.com',
        password: 'any',
      );
      expect(provider.currentUser, goodCredentials);
    });
  });
}

class NotInitialisedException implements Exception {}

class MockAuthProvider implements AuthProviders {
  var _isInitialised = false;
  bool get isInitialised => _isInitialised;
  AuthUser? _user;
  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialise() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialised = true;
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    if (!isInitialised) throw NotInitialisedException();
    var givenEmail = email;
    if (email == 'temp@gmail.com') throw UserNotFoundException();
    if (password == 'temp') throw WrongPasswordException();

    var user = AuthUser(id:'my_id', email:givenEmail, isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logout() async {
    if (!isInitialised) throw NotInitialisedException();
    if (_user == null) throw UserNotFoundException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<AuthUser> register({required String email, required String password}) {
    if (!isInitialised) throw NotInitialisedException();
    Future.delayed(const Duration(seconds: 1));
    return login(email: email, password: password);
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialised) throw NotInitialisedException();
    final user = _user;
    if (user == null) throw UserNotFoundException();
    var newUser = AuthUser(id:'my_id', email:user.email, isEmailVerified: true);
    _user = newUser;
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) async {
     Future.delayed(const Duration(seconds: 2));

  }
}
