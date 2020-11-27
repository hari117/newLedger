import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:newledger/newhome_screen.dart';


GoogleSignIn google = GoogleSignIn();
CollectionReference userAccountRef =
    Firestore.instance.collection("UserAccouts");
CollectionReference allTranscationRef =
    Firestore.instance.collection("Transactions");
// CollectionReference allUsersListRef =
//     userAccountRef.doc(google.currentUser.id).collection("allUsersList");

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isAuth = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    google.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      hangleSignIn(account);
    });
    google.signInSilently().then((GoogleSignInAccount account) {
      hangleSignIn(account);
    });
  }

  hangleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      checkUsersInFireBase();
      setState(() {
        isAuth = true;
        print("********************* ${google.currentUser.id}***********************************");
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  checkUsersInFireBase() async {
    DocumentSnapshot doc =
        await userAccountRef.document(google.currentUser.id).get();
    if (!doc.exists) {
      Map<String, dynamic> map = {
        "name": google.currentUser.displayName,
        "id": google.currentUser.id,
        "email": google.currentUser.email,
        "photoUrl": google.currentUser.photoUrl,
      };
      await userAccountRef.doc(google.currentUser.id).setData(map);
    }
  }

  @override
  Widget build(BuildContext context) {

    return isAuth ? NewHomeScreen() : unAuthScreen();

  }

  unAuthScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              color: Colors.white54,
              onPressed: () {
                googleLogin();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    "assets/svg/google.svg",
                    width: 30,
                  ),
                  SizedBox(
                    width: 11,
                  ),
                  Text(
                    "Google SignIn",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  googleLogin() {
    google.signIn();
  }
}
