import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:newledger/model/globalState.dart';
import 'package:newledger/view/view_screens/newhome_screen.dart';
import 'package:newledger/view_models/helper_files.dart';
import 'package:provider/provider.dart';

GoogleSignIn google = GoogleSignIn();
CollectionReference userAccountRef =
    Firestore.instance.collection("UserAccouts");
CollectionReference allTranscationRef =
    Firestore.instance.collection("Transactions");

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //bool isAuth = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<GlobalState>(context, listen: false).checkGoogleAuth();
  }



  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalState>(
      builder: (context, model, child) {
        return model.isAuth ? NewHomeScreen() : loginScreen();
      },
    );
  }




  loginScreen() {
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
                  $helperFile.W10(),
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

