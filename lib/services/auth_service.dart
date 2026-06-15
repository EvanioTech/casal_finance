import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error fetching user data: \$e');
      return null;
    }
  }

  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Erro ao fazer login';
    }
  }

  Future<UserCredential?> signUpWithEmail(String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user doc in Firestore
      if (result.user != null) {
        UserModel newUser = UserModel(
          uid: result.user!.uid,
          email: email,
          name: name,
          coupleId: result.user!.uid, // Initially, coupleId is their own UID
        );
        await _db.collection('users').doc(result.user!.uid).set(newUser.toMap());
      }
      return result;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Erro ao criar conta';
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User canceled the sign-in

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential result = await _auth.signInWithCredential(credential);

      // Create or update user doc in Firestore
      if (result.user != null) {
        DocumentSnapshot doc = await _db.collection('users').doc(result.user!.uid).get();
        if (!doc.exists) {
          UserModel newUser = UserModel(
            uid: result.user!.uid,
            email: result.user!.email ?? '',
            name: result.user!.displayName ?? 'Usuário Google',
            coupleId: result.user!.uid,
          );
          await _db.collection('users').doc(result.user!.uid).set(newUser.toMap());
        }
      }
      return result;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Erro no login com o Google';
    } catch (e) {
      throw 'Erro desconhecido ao entrar com o Google';
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
