import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> saveUserProfile(
  String displayName,
  String uid,
  String height,
  String weight,
) async {
  final usersRef = FirebaseFirestore.instance.collection('users');
  await usersRef.doc(uid).set(
    {
      'displayName': displayName,
      'height': height,
      'weight': weight,
    },
  );
}

void handleSignIn(
  User user,
  String height,
  String weight,
) async {
  await saveUserProfile(
    user.displayName!,
    user.uid,
    height,
    weight,
  );
}

void signInWithFirebase(
  String email,
  String password,
  String height,
  String weight,
) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    handleSignIn(
      userCredential.user!,
      height,
      weight,
    );
  } catch (e) {
    print('Sign-in error: $e');
  }
}

void signUpWithFirebase(
  String email,
  String password,
  String displayName,
  String height,
  String weight,
) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await saveUserProfile(
      displayName,
      userCredential.user!.uid,
      height,
      weight,
    );
  } catch (e) {
    print('Sign-up error: $e');
  }
}
