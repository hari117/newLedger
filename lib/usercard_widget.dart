import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newledger/login_screen.dart';
import 'package:newledger/particular_user_screen.dart';

class UserCard extends StatefulWidget {
  String userName;

  UserCard({this.userName});

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Alert Dialog '),
              content: Text("Are You Sure Want To Delete This User?"),
              actions: <Widget>[
                FlatButton(
                  child: Text("YES"),
                  onPressed: () async {
                    //Put your code here which you want to execute on Yes button click.
                    Navigator.of(context).pop();
                    await Firestore.instance
                        .collection("UserAccouts")
                        .doc(google.currentUser.id)
                        .collection("allUsersList")
                        .doc(widget.userName)
                        .delete();
                    deleteAllTranscations(widget.userName);
                  },
                ),
                FlatButton(
                  child: Text("NO"),
                  onPressed: () {
                    //Put your code here which you want to execute on No button click.
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      onTap: () {
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => ParticularUserScreen(name: widget.userName),
          ),
        );
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black45,
              offset: Offset(
                7.0, // Move to right 10  horizontally
                7.0, // Move to bottom 10 Vertically
              ),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 35,
                  height: 70,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(40)),
                  child: Text(
                    "${widget.userName[0]}",
                    style: GoogleFonts.muli(color: Colors.white, fontSize: 22),
                  ),
                ),
                SizedBox(
                  width: 9,
                ),
                Text(
                  "${widget.userName}",
                  style: GoogleFonts.muli(letterSpacing: 1.1),
                ),
              ],
            ),
            Row(
              children: [
                overAllDebitAndCreditAmount(),
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.black45)),
                  child: Icon(Icons.chevron_right),
                ),
              ],
            )
          ],
        ),
      ),
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
          if (widget.userName == dc["name"]) {
            int total = 0;
            int a = dc["inCredit"];
            int b = dc["inDebit"];
            int c = a - b;
            //print("**************************** $a ************************************");
            //print("**************************** $b ************************************");
            if (a > b) {
              //print("************************* condition matched 1: **************************");
              return Text(
                "\$ $c Rs",
                style: GoogleFonts.muli(
                    letterSpacing: 1, fontSize: 20, color: Colors.green),
              );
            } else {
              //print("************************* condition matched 2: **************************");
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

  deleteAllTranscations(String name) async {
    QuerySnapshot qc = await allTranscationRef
        .doc(google.currentUser.id)
        .collection(name)
        .getDocuments();
    List<DocumentSnapshot> dc = qc.docs;
    for (DocumentSnapshot d in dc) {
      if (d.exists) {
        await Firestore.instance
            .collection("UserAccouts")
            .doc(google.currentUser.id)
            .collection("allUsersList")
            .doc(google.currentUser.id)
            .collection(name)
            .doc(d.id)
            .delete();
      }
    }
  }
}
