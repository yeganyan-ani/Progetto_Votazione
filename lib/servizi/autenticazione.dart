import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:votazione/modelli/user.dart';

// Servizio di autenticazione con Firebase
class Autenticazione {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  User? _userFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }

    return User(user.uid, user.email);
  }

  Stream<User?>? get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  // Servizio di Login con Firebase
  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    return _userFromFirebase(credential.user);
  }

  // Servizio di registrazione con Firebase
  Future<User?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    return _userFromFirebase(credential.user);
  }

  // Servizio di logout con Firebase
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
