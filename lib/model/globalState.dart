


import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:newledger/view/view_screens/login_screen.dart';
import 'package:newledger/view_models/firebase_activites.dart';

class GlobalState extends ChangeNotifier
{


  bool isAuth=false;

  bool isVisibleName=false;


  isVisible(bool value)
  {
    print("********* evant called *********");
    isVisibleName=value;
    notifyListeners();
  }

  checkGoogleAuth() {
    google.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      hangleSignIn(account);
    });
    google.signInSilently().then((GoogleSignInAccount account) {
      hangleSignIn(account);
    });
  }


  hangleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      FirebaseCenter.checkUsersInFireBase(google.currentUser.id);

      isAuth=true;
      notifyListeners();

    } else {

      isAuth=false;
      notifyListeners();


    }
  }

}