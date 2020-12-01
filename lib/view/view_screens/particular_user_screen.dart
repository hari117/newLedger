import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newledger/view/view_screens/splash_screen.dart';
import 'package:newledger/view/view_screens/transcation_screen.dart';
import 'package:newledger/view/view_widgets/particular_transcation_card.dart';
import 'package:newledger/view_models/helper_files.dart';


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
      appBar:particularUserScreenAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            upperBody(),
            lowerBody(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => TranscationScreen(name: widget.name)));
        },
        child: Icon(
          Icons.attach_money,
          color: Colors.white,
        ),
      ),
    );
  }

  upperBody() {
    return  Container(
      color: Colors.blue,
      height: MediaQuery
          .of(context)
          .size
          .height * .3,
      child: Padding(
        padding: EdgeInsets.only(left: 20),
        child: Column(
          children: [

            $helperFile.H10(),
            mobileNumber(),
            $helperFile.H10(),
            eMail(),
            overAllAmount(),
            debitAndCreditMoney(),

          ],
        ),
      ),
    );
  }
  lowerBody() {
    return   StreamBuilder(
      stream: allTranscationRef.doc(google.currentUser.id).collection(
          widget.name).snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return Center(
            child: Text("Wait Data Is Loading"),
          );
        }
        List<DocumentSnapshot> doc = snap.data.documents;
        return ListView.builder(
          primary: false,
          shrinkWrap: true,
          itemCount: snap.data.documents.length,
          itemBuilder: (context, index) {
            return TranscationCard(doc: doc[index],name:widget.name);
          },);
      },
    );
  }

  debitStreamBuilder() {
    return StreamBuilder(
      stream: Firestore.instance.collection("UserAccouts").doc(
          google.currentUser.id).collection("allUsersList").snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return Text("wait");
        }
        List<DocumentSnapshot> docSnap = snap.data.documents;
        for (DocumentSnapshot d in docSnap) {
          if (widget.name == d["name"]) {
            return Text(
              '\$ ${d["inDebit"]}  \nDebit',
              style: GoogleFonts.muli(
                  color: Colors.white, fontSize: 10, letterSpacing: 1.1),
              overflow: TextOverflow.ellipsis,
            );
          }
        }
        return null;
      },
    );
  }

  creditStreamBuilder() {
    return StreamBuilder(
      stream: Firestore.instance.collection("UserAccouts").doc(
          google.currentUser.id).collection("allUsersList").snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return Text("wait");
        }
        List<DocumentSnapshot> docSnap = snap.data.documents;
        for (DocumentSnapshot d in docSnap) {
          if (widget.name == d["name"]) {
            return Text(
              '\$ ${d["inCredit"]}  \nDebit',
              style: GoogleFonts.muli(
                  color: Colors.white, fontSize: 10, letterSpacing: 1.1),
              overflow: TextOverflow.ellipsis,
            );
          }
        }
        return null;
      },
    );
  }

  mobileStreamBuilder() {
    return StreamBuilder(
      stream: Firestore.instance.collection("UserAccouts").doc(
          google.currentUser.id).collection("allUsersList").snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return Text("Loading");
        }
        List<DocumentSnapshot> phoneNum = snap.data.documents;
        for (DocumentSnapshot dc in phoneNum) {
          if (dc["name"] == widget.name) {
            return Text(
              dc["mobileNumber"],
              style: GoogleFonts.muli(
                  letterSpacing: 1.1, color: Colors.white, fontSize: 12),
            );
          }

        }
        return null;
      },
    );
  }

  eMailStreamBuilder() {
    return StreamBuilder(
      stream: Firestore.instance.collection("UserAccouts").doc(
          google.currentUser.id).collection("allUsersList").snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return Text("Loading");
        }
        List<DocumentSnapshot> phoneNum = snap.data.documents;
        for (DocumentSnapshot dc in phoneNum) {
          if (dc["name"] == widget.name) {
            return Text(
              dc["eMail"],
              style: GoogleFonts.muli(
                  letterSpacing: 1.1, color: Colors.white, fontSize: 11),
            );
          }

        }
        return null;
      },
    );
  }

  overAllDebitAndCreditAmount() {
    return StreamBuilder(
      stream: Firestore.instance.collection("UserAccouts").doc(
          google.currentUser.id).collection("allUsersList").snapshots(),
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
              return Text(
                "\$ $c Rs",
                style: GoogleFonts.muli(
                    letterSpacing: 1, fontSize: 20, color: Colors.green),
              );
            } else {
              int c = b - a;
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
      backgroundColor: Colors.blue,
      title: Text(
        "${widget.name}",
        style: GoogleFonts.muli(
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  mobileNumber()
  {
    return   Row(
      children: [
        Icon(
          Icons.phone,
          size: 20,
          color: Colors.white,
        ),
        $helperFile.W10(),
        mobileStreamBuilder(),
      ],
    );
  }

  overAllAmount() {
    return Container(
      width:double.infinity,
      height: 50,
      alignment: Alignment.center,
      child: overAllDebitAndCreditAmount(),
    );
  }

  eMail() {
    return   Row(
      children: [
        Icon(
          Icons.mail_outline,
          size: 20,
          color: Colors.white,
        ),
        $helperFile.W10(),
        eMailStreamBuilder(),
      ],
    );
  }


  debitAndCreditMoney()
  {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            Icon(Icons.arrow_circle_up,color: Colors.green,size: 70,),
            $helperFile.W10(),
            creditStreamBuilder(),
          ],
        ),
        Row(
          children: [
            Icon(Icons.arrow_circle_down_rounded,color: Colors.red,size: 70,),
            $helperFile.W10(),
            debitStreamBuilder(),
          ],
        ),
      ],
    );
  }
}