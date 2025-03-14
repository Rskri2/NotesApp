import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:noteapp/services/auth/auth_exception.dart';
import 'package:noteapp/services/auth/auth_provider.dart' show AuthProviders;
import 'package:noteapp/services/auth/auth_user.dart';

import '../../firebase_options.dart';

class FirebaseAuthProvider implements AuthProviders{
  @override
  AuthUser? get currentUser{
    final user = FirebaseAuth.instance.currentUser;
    if(user != null){
      return AuthUser.fromFirebase(user);
    }
    else {
      return null;
    }
  }
  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password,);
      final user = currentUser;
      if(user != null){
        return user;
      }
      else {
        throw UserNotLoggedInException();
      }
    } on FirebaseAuthException catch(e){
      if (e.code == 'user-not-found') {
        throw UserNotFoundException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordException();
      }
      else {
        throw GenericAuthException();
      }
    } catch (e){
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logout() async{
    final user = FirebaseAuth.instance.currentUser;
    if(user != null){
      await FirebaseAuth.instance.signOut();
    }
    else{
      throw UserNotLoggedInException();
    }
  }

  @override
  Future<AuthUser> register({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if(user != null){
        return user;
      }
      else {
        throw UserNotLoggedInException();
      }
    } on FirebaseAuthException  catch (e){
      if (e.code == 'weak-password') {
        throw WeakPasswordException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    }
    catch(e){
      throw GenericAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async{
    final user = FirebaseAuth.instance.currentUser;
    if(user != null){
      await user.sendEmailVerification();
    }
    else{
      throw UserNotLoggedInException();
    }
  }

  @override
  Future<void> initialise() async {
     await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) async{
    try{
       await FirebaseAuth.instance.sendPasswordResetEmail(email: toEmail);
    } on FirebaseException catch(e){
      switch(e.code){
        case 'firebase_auth/invalid-email':
          throw InvalidEmailAuthException();
        case 'firebase_auth/user-not-found':
          throw UserNotFoundException();
        default:
          throw GenericAuthException();
      }
    }
    catch(_){
      throw GenericAuthException();
    }
  }

}