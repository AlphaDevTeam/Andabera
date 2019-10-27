import 'dart:io';

import 'package:andabera/login_screen.dart';
import 'package:andabera/modelTest.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  final databaseReference = Firestore.instance;


  String _name;
  String _email;
  String _imageUrl;
  String _role;
  String _uid;

  String get name => _name;
  String get email => _email;
  String get imageUrl => _imageUrl;
  String get role => _role;

  set role(String value) {
    _role = value;
  }


  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }

  Observable<FirebaseUser> user; // firebase user
  Observable<Map<String, dynamic>> profile; // custom user data in Firestore
  PublishSubject loading = PublishSubject();

  // constructor
  AuthService() {
    user = Observable(_auth.onAuthStateChanged);

    profile = user.switchMap((FirebaseUser u) {
      if (u != null) {
        return _db
            .collection('userX')
            .document(u.uid)
            .snapshots()
            .map((snap) => snap.data);
      } else {
        return Observable.just({});
      }
    });

  }

  Future<FirebaseUser> googleSignIn() async {
    try {
      loading.add(true);
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      AuthResult authResult = await _auth.signInWithCredential(credential);
      assert(!authResult.user.isAnonymous);
      assert(await authResult.user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(authResult.user.uid == currentUser.uid);

      assert(authResult.user.email != null);
      assert(authResult.user.displayName != null);
      assert(authResult.user.photoUrl != null);

      _name = authResult.user.displayName;
      _email = authResult.user.email;
      _imageUrl = authResult.user.photoUrl;
      authService.uid = currentUser.uid;

      _getRole(currentUser);
      print("user name: ${authResult.user.displayName}");

      loading.add(false);

      return authResult.user;
    } catch (error) {
      print(error.toString());
      //return error;
    }
  }

  _getRole(FirebaseUser user) {
    databaseReference
        .collection("userX")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        if (f.data['uid'] == user.uid) {
          final userRole = f.data['role'].toString();
          authService.role = userRole;
        }
      });
    });
  }

  /// Get the token, save it to the database for current user
  saveDeviceToken(FirebaseMessaging fcm) async {
    // Get the current user
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    assert(user != null);
    // Get the token for this device
    String fcmToken = await fcm.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      //Save Token info
      var tokenData = _db
          .collection('userX')
          .document(user.uid)
          .collection('deviceTokens')
          .document(fcmToken);

      await tokenData.setData({
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem, // optional
        'platformVersion': Platform.version,
        'lastUpdated': DateTime.now()
      }, merge: true);

      //Saving User profile data
      var profileData = _db
          .collection('userX')
          .document(user.uid);

      await profileData.setData({
        'createdAt': FieldValue.serverTimestamp(), // optional
        'uid': user.uid,
        'email': user.email,
        'photoURL': user.photoUrl,
        'displayName': user.displayName,
        'lastSeen': DateTime.now(),
      }, merge: true);

    }
  }


  /// Save Messages
  saveMessages(User userDetails) async {
    // Get the current user
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    assert(user != null);
    //assert(user.uid != userDetails.useruid);
    // Get the token for this device

    // Save it to Firestore
    if (userDetails != null) {
      //Save Token info
      var messageData = _db
          .collection('messages')
          .document( DateTime.now().toString());

      await messageData.setData({
        'title':userDetails.cardTitle,
        'description':userDetails.cardDescription,
        'imgUrl':userDetails.imgURL,
        'userUID':userDetails.useruid,
        'chanel':userDetails.relatedChanel,
        'createdUser':userDetails.createdUser,
        'createdDate': DateTime.now().toIso8601String(),
      }, merge: true);
    }
  }


  Future<String> signOut() async {
    try {
      await _auth.signOut();
      print("signOut requested");
      return 'SignOut';
    } catch (e) {
      return e.toString();
    }
  }

}

// TODO refactor global to InheritedWidget
final AuthService authService = AuthService();