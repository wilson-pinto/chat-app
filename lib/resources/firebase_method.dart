import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/constants/strings.dart';
import 'package:flutter_app/models/message.dart';
import 'package:flutter_app/models/user_model.dart';
import 'package:flutter_app/utils/utilities.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  static final Firestore firestore = Firestore.instance;

  User user = User();

  Future<FirebaseUser> getCurrentUser() async{
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser;
  }

  Future<FirebaseUser> signIn() async{
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication = await _signInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: _signInAuthentication.idToken,
        accessToken: _signInAuthentication.accessToken
    );

    AuthResult authResult = await _auth.signInWithCredential(credential);
    FirebaseUser  user = authResult.user;
    return user;
  }

  Future<bool> authenticateUser(FirebaseUser user) async{
    QuerySnapshot result =await firestore
        .collection(USERS_COLLECTION)
        .where(EMAIL_FIELD, isEqualTo: user.email)
        .getDocuments();

    final List<DocumentSnapshot> docs = result.documents;
    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(FirebaseUser currentUser) async{

    String username = Utils.getUserName(currentUser.email);
    user = User(
      uid: currentUser.uid,
      email: currentUser.email,
      name: currentUser.displayName,
      profilePhoto: currentUser.photoUrl,
        username: username
    );
    firestore.collection(USERS_COLLECTION).document(currentUser.uid).setData(user.toMap(user));
  }

  Future<void> signOut() async{
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    return await _auth.signOut();
  }

  Future<List<User>> fetchAllUsers(FirebaseUser currentUser) async {
    List<User> userList = List<User>();

    QuerySnapshot querySnapshot =
    await firestore.collection(USERS_COLLECTION).getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != currentUser.uid) {
        userList.add(User.fromMap(querySnapshot.documents[i].data));
      }
    }
    return userList;
  }

  Future<void> addMessageToDb(
      Message message, User sender, User receiver) async {
      var map = message.toMap();

      await firestore
      .collection(MESSAGES_COLLECTION)
      .document(message.senderId)
      .collection(message.receiverId)
      .add(map);

      return await firestore
          .collection(MESSAGES_COLLECTION)
          .document(message.receiverId)
          .collection(message.senderId)
          .add(map);
  }
}