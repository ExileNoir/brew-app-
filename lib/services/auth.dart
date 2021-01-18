import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create userObj based on FirebaseUser
  User _userFromFirebaseUser(final FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map((FirebaseUser user) => _userFromFirebaseUser(user));
  }

  // sign in anon
  Future signInAnon() async {
    try {
      final AuthResult authResult = await _auth.signInAnonymously();
      final FirebaseUser user = authResult.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with IDs
  Future signInWithEmailAndPwd(final String email, final String pwd) async {
    try {
      final AuthResult result =
          await _auth.signInWithEmailAndPassword(email: email, password: pwd);
      final FirebaseUser firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {}
  }

  // register with IDs
  Future registerWithEmailAndPwd(final String email, final String pwd) async {
    try {
      final AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: pwd);
      final FirebaseUser firebaseUser = result.user;

      // create a new document for the user with the uid
      await DatabaseService(uid: firebaseUser.uid)
          .updateUserData('new crew member', '0', 100);

      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
