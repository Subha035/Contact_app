import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // create new account using email password method
  Future<String> createAccountWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      return "Account Created";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  // login with email password method
  Future<String> loginWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return "Login Successful";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  // logout the user
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // logout from google if logged in with google
      if (await GoogleSignIn().isSignedIn()) {
        await GoogleSignIn().signOut();
      }
    } on PlatformException catch (e) {
      print('Error signing out: $e');
    }
  }

  // check whether the user is sign in or not
  Future<bool> isLoggedIn() async {
    var user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  // for login with google
  Future<String> continueWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        // send auth request
        final GoogleSignInAuthentication gAuth = await googleUser.authentication;

        // obtain a new creditional
        final creds = GoogleAuthProvider.credential(
            accessToken: gAuth.accessToken, idToken: gAuth.idToken);

        // sign in with the credentials
        await FirebaseAuth.instance.signInWithCredential(creds);

        return "Google Login Successful";
      } else {
        return "Google login failed";
      }
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } on PlatformException catch (e) {
      print('Error signing in with Google: $e');
      return 'Error signing in with Google';
    }
  }
}