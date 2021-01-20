import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthService();

  UserModel get currentUser {
    UserModel _currentUser;
    if (_auth.currentUser != null) {
      var currentUser = _auth.currentUser;
      _currentUser = UserModel.fromJson({
        'uid': currentUser.uid,
        'email': currentUser.email,
        'displayName': currentUser.displayName,
        'photoURL': currentUser.photoURL,
      });
    }
    return _currentUser;
  }

  Future<UserModel> signInWithEmailAndPassword(
      {String email, String password}) async {
    return await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((currentUser) => UserModel.fromJson({
              'id': currentUser.user.uid,
              'email': currentUser.user.email,
              'displayName': currentUser.user.displayName,
              'photoURL': currentUser.user.photoURL,
            }));
  }

  Future<UserModel> createUserWithEmailAndPassword(
      {String email, String password}) async {
    return await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((currentUser) => UserModel.fromJson({
              'uid': currentUser.user.uid,
              'email': currentUser.user.email,
              'displayName': currentUser.user.displayName,
              'photoURL': currentUser.user.photoURL,
            }));
  }

  Future<void> signOut() async {
    if (_auth.currentUser != null) _auth.signOut();
  }
}
