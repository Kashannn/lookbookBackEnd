// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';
//
// import '../utils/components/constant/snackbar.dart';
//
//
// Future<void> signInWithGoogle({required BuildContext context}) async {
//   Get.dialog(Loading());
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   final GoogleSignIn googleSignIn = GoogleSignIn();
//   await googleSignIn.signOut();
//   try {
//     final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
//     if (googleSignInAccount != null) {
//       final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleSignInAuthentication.accessToken,
//         idToken: googleSignInAuthentication.idToken,
//       );
//       final UserCredential userCredential = await auth.signInWithCredential(credential);
//       final User? user = userCredential.user;
//       print('User signed in: ${user!.displayName}');
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
//
//       if (!userDoc.exists) {
//         await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
//           'name': user.displayName ?? 'Unknown',
//           'email': user.email ?? 'Unknown',
//           'uid': user.uid,
//           'walletBalance': 0.0,
//           'profilePic': user.photoURL ?? 'https://firebasestorage.googleapis.com/v0/b/school-yard-4750d.appspot.com/o/Profile%2Fdefault_profile.jpg?alt=media&token=7b8a56f1-ff5d-43dc-b0e5-2062bfc745b2',
//           // Add more user data fields as needed
//         });
//       }
//     } else {
//       Get.back();
//       print('User cancelled sign-in');
//     }
//   } catch (e) {
//     Get.back();
//     print('Error signing in with Google: $e');
//
//   }
// }
