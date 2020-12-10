import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:newledger/model/apptheam/leader_theam.dart';
import 'package:newledger/view/view_screens/add_user_screen.dart';
import 'package:newledger/view/view_screens/login_screen.dart';
import 'package:newledger/view/view_screens/transcation_screen.dart';
import 'package:newledger/view/view_widgets/loading_widget.dart';
import 'package:newledger/view/view_widgets/text_widget.dart';
import 'package:newledger/view/view_widgets/usercard_widget.dart';
import 'package:newledger/view_models/helper_files.dart';

class NewHomeScreen extends StatefulWidget {
  @override
  _NewHomeScreenState createState() => _NewHomeScreenState();
}

class _NewHomeScreenState extends State<NewHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              color: $appTheam.primaryColor_01,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // all home screen widgets are here
                  $helperFile.H50(),
                  welcomeQuoteAndLogOut(),
                  $helperFile.H10(),
                  displayName(),
                  $helperFile.H25(),
                  debitAndCredit(),
                  $helperFile.H20(),
                  $helperFile.H20(),
                  $helperFile.H20(),

                  // end.
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 210),
              child: lowerPart(),
            )
          ],
        ),
      ),
      floatingActionButton: speedDailFloatingButton(),
    );
  }


  welcomeQuoteAndLogOut()
  {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          name: "Welcome Back,",
          textColor: $appTheam.onWhite_01,
          textSize: 24,
          textLetterSpacing: 1.1,
        ),
        InkWell(
          onTap: () {
            logOutDialogBox(context);
          },
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image:
                  NetworkImage(google.currentUser.photoUrl),
                ),
                shape: BoxShape.circle),
          ),
        )
      ],
    );
  }

  displayName()
  {
    return CustomText(
      name: google.currentUser.displayName[0].toUpperCase() +
          google.currentUser.displayName.substring(1),
      textColor: $appTheam.onWhite_01,
      textSize: 14,
      textLetterSpacing: 1.3,
    );
  }

  debitAndCredit() {
    return Row(
      children: [
        Flexible(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(color: $appTheam.primaryColor_02),
              ],
            ),
            padding: EdgeInsets.only(left: 10),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                $helperFile.H10(),
                totalCreditStream(),
                $helperFile.H10(),
                CustomText(
                  name: "CREDIT",
                  textLetterSpacing: 1.1,
                  textSize: 8,
                  textColor: Colors.green,
                ),
                $helperFile.H10(),
              ],
            ),
          ),
        ),
        $helperFile.W20(),
        Flexible(
          child: Container(
            padding: EdgeInsets.only(left: 10),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                boxShadow: [BoxShadow(color: $appTheam.primaryColor_02)]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                $helperFile.H10(),
                totalDebitStream(),
                $helperFile.H10(),
                CustomText(
                  name: "DEBIT",
                  textLetterSpacing: 1.1,
                  textSize: 8,
                  textColor: Colors.red,
                ),
                $helperFile.H10(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  lowerPart() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("UserAccouts")
          .doc(google.currentUser.id)
          .collection("allUsersList")
          .snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return Container(
            width: double.infinity,
            height: 400,
            alignment: Alignment.center,
            child: SizedBox(
              width: 100,
              height: 100,
              child: CustomLoadingWidget(),
            ),
          );
        }
        List<DocumentSnapshot> doc = snap.data.documents;
        if (doc.isEmpty) {
          return Container(
              width: double.infinity,
              height: 400,
              alignment: Alignment.center,
              child: Text(
                " Currerntly There is No Transcations",
                style: GoogleFonts.roboto(
                    color: Colors.red, fontSize: 15, letterSpacing: 1.2),
              ));
        }
        return ListView.builder(
          primary: false,
          shrinkWrap: true,
          itemCount: snap.data.documents.length,
          itemBuilder: (context, index) {
            String userName = doc[index]["name"];
            return UserCard(
              userName: userName,
            );
          },
        );
      },
    );
  }
  speedDailFloatingButton() {
    return SpeedDial(
      elevation: .1,
      backgroundColor: $appTheam.primaryColor_02,
      child: Icon(
        Icons.layers_sharp,
        color: $appTheam.onWhite_01,
      ),
      children: [
        SpeedDialChild(
            child: Icon(
              Icons.add,
              color: $appTheam.primaryColor_02,
            ),
            label: "Add User",
            backgroundColor: $appTheam.onWhite_01,
            onTap: () {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => CreateUser()));
            }),
        SpeedDialChild(
          backgroundColor: $appTheam.onWhite_01,
          child: Icon(
            Icons.monetization_on,
            color: $appTheam.primaryColor_02,
          ),
          label: "Transcation",
          onTap: () {
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => TranscationScreen(
                  name: null,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  totalCreditStream() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("UserAccouts")
          .doc(google.currentUser.id)
          .collection("allUsersList")
          .snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return Text("Loading");
        }
        List<DocumentSnapshot> doc = snap.data.documents;
        int total = 0;
        for (DocumentSnapshot d in doc) {
          total = total + d["inCredit"];
        }
        //List<DocumentSnapshot
        return RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: '₹ ',
                style: GoogleFonts.muli(
                    color: Colors.green, fontSize: 14, letterSpacing: 1.1),
              ),
              TextSpan(
                text: '$total',
                style: GoogleFonts.muli(
                    color: total == 0 ? Colors.white : Colors.green,
                    fontSize: 22,
                    letterSpacing: 1.1),
              ),
            ],
          ),
        );
      },
    );
  }

  totalDebitStream() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("UserAccouts")
          .doc(google.currentUser.id)
          .collection("allUsersList")
          .snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return Text("Loading");
        }
        List<DocumentSnapshot> doc = snap.data.documents;
        int total = 0;
        for (DocumentSnapshot d in doc) {
          total = total + d["inDebit"];
        }
        //List<DocumentSnapshot
        return RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: '₹ ',
                style: GoogleFonts.muli(
                    color:  Colors.red, fontSize: 14, letterSpacing: 1.1),
              ),
              TextSpan(
                text: '$total',
                style: GoogleFonts.muli(
                    color: total == 0 ? Colors.white : Colors.red,
                    fontSize: 22,
                    letterSpacing: 1.1),
              ),
            ],
          ),
        );
      },
    );
  }

  logOutDialogBox(context)
  {
    showDialog(
        barrierColor: $appTheam.onWhite_01,
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ), //this right here
            child: Container(
              decoration: BoxDecoration(
                color: $appTheam.primaryColor_01,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15),
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  crossAxisAlignment:
                  CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    $helperFile.H15(),
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(google
                                .currentUser.photoUrl),
                          )),
                    ),
                    $helperFile.H10(),
                    Text(
                      "Are You Sure,\nYou Want To Logout?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          letterSpacing: 1.3,
                          height: 1.2,
                          color: $appTheam.onWhite_01,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    $helperFile.H5(),
                    FlatButton(
                      minWidth: 150,
                      height: 35,
                      onPressed: () {
                        google.signOut();
                        Navigator.pop(context);
                      },
                      child: CustomText(
                        name: "Logout",
                        textSize: 18,
                        textColor: Colors.red,
                      ),
                      color: $appTheam.primaryColor_02,
                    ),
                    FlatButton(
                      minWidth: 150,
                      height: 35,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: CustomText(
                        name: "Cancel",
                        textSize: 18,
                        textColor: Colors.green,
                      ),
                      color: $appTheam.primaryColor_02,
                    ),
                    $helperFile.H15(),
                  ],
                ),
              ),
            ),
          );
        });
  }




}
