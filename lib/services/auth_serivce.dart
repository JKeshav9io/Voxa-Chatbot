import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authState => _auth.authStateChanges();

  Future<User?> signIn(String email, String password) async {
    try {
      final userCred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return userCred.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Login failed';
    }
  }

  Future<User?> signUp(String email, String password) async {
    try {
      final userCred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return userCred.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Signup failed';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}
