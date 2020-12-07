import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:newledger/model/apptheam/leader_theam.dart';
import 'package:newledger/model/globalState.dart';
import 'package:newledger/view/view_screens/newhome_screen.dart';
import 'package:newledger/view/view_widgets/text_widget.dart';
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
      backgroundColor: Color(0xFF273250),
     // backgroundColor: $appTheam.primaryColor_01,
      body: Stack(
        children: [
          Positioned(
            child: Container(
              //      color: Colors.red,
              width: MediaQuery.of(context).size.width, height: 550,
              child: Image(
                fit: BoxFit.fill,
                image: AssetImage("assets/images/half_Ellipse.png"),
              ),
            ),
          ),
          Stack(
            children: [
              Positioned(
                bottom: 30,
                left: 10,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width,
                        child: CustomText(
                          name: "The Ledger Book",
                          textColor: $appTheam.onWhite_01,
                          textLetterSpacing: 1.1,
                          textFontWeigth: FontWeight.w500,
                          textSize: 24,
                        ),
                      ),
                      $helperFile.H10(),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.centerLeft,
                        child: CustomText(
                          name: "Smart Easy Simple",
                          textColor: $appTheam.onWhite_01,
                          textLetterSpacing: 1.2,
                          //textFontWeigth: FontWeight.w500,
                          textFontStyle: FontStyle.normal,
                          textSize: 14,
                        ),
                      ),
                      $helperFile.H40(),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: 330,
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          height: 55,
                          color: $appTheam.onWhite_01,
                          //  color: Color.fromRGBO(255,255,255,15),
                          onPressed: () {
                            googleLogin();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            //   mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                "assets/svg/google.svg",
                                width: 30,
                              ),
                              $helperFile.W10(),
                              CustomText(
                                name: "Continue with Google",
                                textColor: $appTheam.primaryColor_01,
                                textLetterSpacing: 1.2,
                                textFontWeigth: FontWeight.w500,
                                textFontStyle: FontStyle.normal,
                                textSize: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  googleLogin() {
    google.signIn();
  }
}
