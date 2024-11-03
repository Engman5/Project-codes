import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Sign in method with navigation to permissions screen
  Future<User?> signInWithEmail(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Navigate to permissions screen after successful login
        Navigator.pushReplacementNamed(context, '/permissionsScreen');
      }

      return userCredential.user;
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  // Sign up method with navigation to details collection screen
  Future<User?> signUpWithEmail(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Navigate to details collection screen after successful signup
        Navigator.pushReplacementNamed(context, '/detailsCollectionScreen');
      }

      return userCredential.user;
    } catch (e) {
      print('Error signing up: $e');
      return null;
    }
  }

  // Reset password method (unchanged)
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Error resetting password: $e');
    }
  }

  // Sign out method with navigation to login screen
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      // Navigate to login screen after sign out
      Navigator.pushReplacementNamed(context, '/loginScreen');
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Auth state changes stream (unchanged)
  Stream<User?> get user {
    return _auth.authStateChanges();
  }
}
