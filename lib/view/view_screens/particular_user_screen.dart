import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newledger/model/apptheam/leader_theam.dart';
import 'package:newledger/view/view_screens/login_screen.dart';
import 'package:newledger/view/view_screens/transcation_screen.dart';
import 'package:newledger/view/view_widgets/particular_transcation_card.dart';
import 'package:newledger/view/view_widgets/text_widget.dart';
import 'package:newledger/view_models/helper_files.dart';
import 'package:loading_indicator/loading_indicator.dart';

class ParticularUserScreen extends StatefulWidget {
  String name;

  ParticularUserScreen({this.name});

  @override
  _ParticularUserScreenState createState() => _ParticularUserScreenState();
}

class _ParticularUserScreenState extends State<ParticularUserScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: particularUserScreenAppBar(),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            upperBody(),
         //   lowerBody(),
            Container(
              margin: EdgeInsets.only(top: 250),
              child: lowerBody(),
            )

          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF232D48),
        onPressed: () {
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => TranscationScreen(name: widget.name),
            ),
          );
        },
        child: Icon(
          Icons.attach_money,
          color: $appTheam.onWhite_01,
        ),
      ),
    );
  }

  upperBody() {
    return Container(
      color: Color(0xFF232D48),
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            $helperFile.H10(),
            mobileNumber(),
            $helperFile.H15(),
            eMail(),
            overAllAmount(),
            debitAndCreditMoney(),
            $helperFile.H80(),
          ],
        ),
      ),
    );
  }

  lowerBody() {
    return StreamBuilder(
      stream: allTranscationRef
          .doc(google.currentUser.id)
          .collection(widget.name)
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
              child: LoadingIndicator(
                indicatorType: Indicator.ballClipRotatePulse,
                color: $appTheam.primaryColor_02,
              ),
            ),
          );
        }
        List<DocumentSnapshot> doc = snap.data.documents;
        if (doc.isEmpty) {
          return Container(
            width: double.infinity,
            height: 400,
            alignment: Alignment.center,
            child: CustomText(name:"Currerntly There is No Transcations",textColor: $appTheam.primaryColor_01,textSize: 15,textLetterSpacing: 1.2,),
            /*child: Text(
              " Currerntly There is No Transcations",
              style: GoogleFonts.roboto(
                  color: Colors.red, fontSize: 15, letterSpacing: 1.2),
            ),*/
          );
        }
        return ListView.builder(
          primary: false,
          shrinkWrap: true,
          itemCount: snap.data.documents.length,
          itemBuilder: (context, index) {
            return TranscationCard(
              doc: doc[index],
              name: widget.name,
            );
          },
        );
      },
    );
  }

  debitStreamBuilder() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("UserAccouts")
          .doc(google.currentUser.id)
          .collection("allUsersList")
          .snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return Text("wait");
        }
        List<DocumentSnapshot> docSnap = snap.data.documents;
        for (DocumentSnapshot d in docSnap) {
          if (widget.name == d["name"]) {
            return CustomText(
              name: "₹ ${d["inDebit"].toString()}",
              textLetterSpacing: 1.1,
              textColor: $appTheam.onWhite_01,
              textSize: 15,
            );
          }
        }
        return null;
      },
    );
  }

  creditStreamBuilder() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("UserAccouts")
          .doc(google.currentUser.id)
          .collection("allUsersList")
          .snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return Text("wait");
        }
        List<DocumentSnapshot> docSnap = snap.data.documents;
        for (DocumentSnapshot d in docSnap) {
          if (widget.name == d["name"]) {
            return CustomText(
              name: "₹ ${d["inCredit"].toString()}",
              textLetterSpacing: 1.1,
              textColor: $appTheam.onWhite_01,
              textSize: 15,
            );
          }
        }
        return null;
      },
    );
  }

  mobileStreamBuilder() {
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
        List<DocumentSnapshot> phoneNum = snap.data.documents;
        for (DocumentSnapshot dc in phoneNum) {
          if (dc["name"] == widget.name) {
            return CustomText(
              name: dc["mobileNumber"],
              textLetterSpacing: 1.1,
              textColor: $appTheam.onWhite_01,
            );
          }
        }
        return null;
      },
    );
  }

  eMailStreamBuilder() {
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
        List<DocumentSnapshot> phoneNum = snap.data.documents;
        for (DocumentSnapshot dc in phoneNum) {
          if (dc["name"] == widget.name) {
            return CustomText(
              name: dc["eMail"],
              textLetterSpacing: 1.1,
              textColor: $appTheam.onWhite_01,
              textSize: 12,
            );
          }
        }
        return null;
      },
    );
  }

  overAllDebitAndCreditAmount() {
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
        for (DocumentSnapshot dc in doc) {
          if (widget.name == dc["name"]) {
            int total = 0;
            int a = dc["inCredit"];
            int b = dc["inDebit"];
            if (a > b) {
              int c = a - b;
              return CustomText(
                name: "₹ $c ",
                textLetterSpacing: 1.2,
                textColor: $appTheam.onWhite_01,
                textSize: 20,
              );
              return Text(
                "\$ $c Rs",
                style: GoogleFonts.muli(
                    letterSpacing: 1, fontSize: 20, color: Colors.green),
              );
            } else {
              int c = b - a;
              return CustomText(
                name: "₹ $c ",
                textLetterSpacing: 1.1,
                textColor: $appTheam.onWhite_01,
                textSize: 20,
              );
              return Text(
                "\$ $c Rs",
                style: GoogleFonts.muli(
                    letterSpacing: 1, fontSize: 20, color: Colors.red),
              );
            }
          }
        }
        return null;
      },
    );
  }

  particularUserScreenAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Color(0xFF232D48),
      title: CustomText(
        name: widget.name,
        textLetterSpacing: 1.2,
        textColor: $appTheam.onWhite_01,
      ),
      /*  title: Text(
        "${widget.name}",
        style: GoogleFonts.muli(
          letterSpacing: 1.1,
        ),
      ),*/
    );
  }

  mobileNumber() {
    return Row(
      children: [
        Icon(
          Icons.phone,
          size: 20,
          color: $appTheam.onWhite_01,
        ),
        $helperFile.W10(),
        mobileStreamBuilder(),
      ],
    );
  }

  overAllAmount() {
    return Container(
      width: double.infinity,
      height: 80,
      alignment: Alignment.center,
      child: overAllDebitAndCreditAmount(),
    );
  }

  eMail() {
    return Row(
      children: [
        Icon(
          Icons.mail_outline,
          size: 20,
          color: $appTheam.onWhite_01,
        ),
        $helperFile.W10(),
        eMailStreamBuilder(),
      ],
    );
  }

  debitAndCreditMoney() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: 80,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: $appTheam.primaryColor_02,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_upward_rounded,
                  color: Colors.green,
                  size: 40,
                ),
                $helperFile.W5(),
                creditStreamBuilder(),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            //padding: EdgeInsets.symmetric(horizontal: 30),
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: $appTheam.primaryColor_02,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_downward,
                  color: Colors.red,
                  size: 40,
                ),
                $helperFile.W5(),
                debitStreamBuilder(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
