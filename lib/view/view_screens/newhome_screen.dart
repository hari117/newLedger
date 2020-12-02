import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:newledger/view/view_screens/add_user_screen.dart';
import 'package:newledger/view/view_screens/login_screen.dart';
import 'package:newledger/view/view_screens/transcation_screen.dart';
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
      appBar: homeScreenAppBar(),
      drawer: homeScreenDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .2,
              color: Colors.blue,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // all home screen widgets are here

                  $helperFile.H15(),
                  accountName(),
                  $helperFile.H20(),
                  debitAndCredit(),

                  // end.
                ],
              ),
            ),
            StreamBuilder(
              stream: Firestore.instance
                  .collection("UserAccouts")
                  .doc(google.currentUser.id)
                  .collection("allUsersList")
                  .snapshots(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return Center(
                    child: Text("Wait Data is Loading"),
                  );
                }
                List<DocumentSnapshot> doc = snap.data.documents;
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
            ),
          ],
        ),
      ),
      floatingActionButton: speedDailFloatingButton(),
    );
  }

  accountName() {
    return Text(
      google.currentUser.displayName,
      style: GoogleFonts.muli(
          letterSpacing: 1.1,
          fontWeight: FontWeight.w500,
          color: Colors.white,
          fontSize: 18),
    );
  }

  debitAndCredit() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            Icon(
              Icons.arrow_upward_rounded,
              color: Colors.green,
              size: 50,
            ),
            $helperFile.W10(),
            totalCreditStream(),
          ],
        ),
        Row(
          children: [
            Icon(
              Icons.arrow_downward,
              color: Colors.red,
              size: 50,
            ),
            $helperFile.W10(),
            totalDebitStream(),
          ],
        ),
      ],
    );
  }

  speedDailFloatingButton() {
    return SpeedDial(
      child: Icon(Icons.accessibility_rounded),
      children: [
        SpeedDialChild(
            child: Icon(Icons.add),
            label: "Add User",
            backgroundColor: Colors.blue,
            onTap: () {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => CreateUser()));
            }),
        SpeedDialChild(
          backgroundColor: Colors.blue,
          child: Icon(Icons.monetization_on),
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
                text: 'Rs: ',
                style: GoogleFonts.muli(
                    color: Colors.white, fontSize: 10, letterSpacing: 1.1),
              ),
              TextSpan(
                text: '$total \n',
                style: GoogleFonts.muli(
                    color: total ==0 ?Colors.white :Colors.green, fontSize: 22, letterSpacing: 1.1),
              ),
              TextSpan(
                text: 'Credit',
                style: GoogleFonts.muli(
                    color: Colors.white, fontSize: 15, letterSpacing: 1.1),
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
                text: 'Rs: ',
                style: GoogleFonts.muli(
                    color: Colors.white, fontSize: 10, letterSpacing: 1.1),
              ),
              TextSpan(
                text: '$total \n',
                style: GoogleFonts.muli(
                    color: total ==0?Colors.white : Colors.red, fontSize: 22, letterSpacing: 1.1),
              ),
              TextSpan(
                text: 'Debit',
                style: GoogleFonts.muli(
                    color: Colors.white, fontSize: 15, letterSpacing: 1.1),
              ),
            ],
          ),
        );
        return Text(
          '\$ $total  \nDebit',
          style: GoogleFonts.muli(
              color: Colors.white, fontSize: 14, letterSpacing: 1.1),
        );
      },
    );
  }

  homeScreenAppBar() {
    return AppBar(
      title: Text(
        "Ledger Book",
        style: GoogleFonts.muli(letterSpacing: 1.2),
      ),
      backgroundColor: Colors.blue,
      elevation: 0.0,
      centerTitle: false,
    );
  }

  homeScreenDrawer() {
    return Drawer(
      elevation: 30,
      child: Container(
        child: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Column(
            children: [
              $helperFile.H25(),
              CircleAvatar(
                maxRadius: 50,
                backgroundImage: NetworkImage(google.currentUser.photoUrl),
              ),
              $helperFile.H15(),
              Text(
                google.currentUser.displayName,
                style: GoogleFonts.muli(fontSize: 22, letterSpacing: 1),
              ),
              $helperFile.H15(),
              Text(
                google.currentUser.email,
                style: GoogleFonts.muli(fontSize: 14, letterSpacing: 1),
              ),
              $helperFile.H30(),
              MaterialButton(
                onPressed: () {
                  google.signOut();
                },
                child: Text(
                  "Sign Out",
                  style: GoogleFonts.muli(
                      fontSize: 18, letterSpacing: 1, color: Colors.white),
                ),
                height: 50,
                color: Colors.blue,
                minWidth: 150,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
