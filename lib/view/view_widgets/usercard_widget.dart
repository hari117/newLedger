import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newledger/model/apptheam/leader_theam.dart';
import 'package:newledger/view/view_screens/login_screen.dart';
import 'package:newledger/view/view_screens/particular_user_screen.dart';
import 'package:newledger/view/view_widgets/text_widget.dart';
import 'package:newledger/view_models/firebase_activites.dart';
import 'package:newledger/view_models/helper_files.dart';

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
              title: CustomText(
                name: 'Warning',
                textColor: $appTheam.primaryColor_03,
              ),
              content: CustomText(
                name: "Are you sure want to delete this user ?",
                textColor: $appTheam.primaryColor_03,
                textLetterSpacing: 1.1,
                textSize: 14,
              ),
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: FlatButton(
                    height: 45,
                    minWidth: 100,
                    color: $appTheam.primaryColor_03,
                    child: CustomText(
                      name: "No",
                      textSize: 16,
                      textLetterSpacing: 1.3,
                    ),
                    onPressed: () {
                      //Put your code here which you want to execute on No button click.
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                $helperFile.W10(),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: FlatButton(
                    height: 45,
                    minWidth: 100,
                    color: $appTheam.primaryColor_03,
                    child: CustomText(
                      name: "Yes",
                      textSize: 16,
                      textLetterSpacing: 1.3,
                    ),
                    onPressed: () async {
                      //Put your code here which you want to execute on Yes button click.
                      FirebaseCenter.deleteParticularUser(widget.userName);
                      Navigator.of(context).pop();
                      // await Firestore.instance
                      //     .collection("UserAccouts")
                      //     .doc(google.currentUser.id)
                      //     .collection("allUsersList")
                      //     .doc(widget.userName)
                      //     .delete();
                      // deleteAllTranscations(widget.userName);
                    },
                  ),
                ),
                $helperFile.H20(),
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
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              blurRadius: 1,
              color: $appTheam.primaryColor_02.withOpacity(.2),
              offset: Offset(
                2.0, // Move to right 10  horizontally
                2.0, // Move to bottom 10 Vertically
              ),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                $helperFile.W20(),
                Container(
                  width: 45,
                  height: 45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: $appTheam.primaryColor_02,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    "${widget.userName[0].toUpperCase()}",
                    style: GoogleFonts.muli(color: Colors.white, fontSize: 22),
                  ),
                ),
                $helperFile.W10(),
                CustomText(
                  name: widget.userName,
                  textLetterSpacing: 1.3,
                  textColor: $appTheam.primaryColor_02,
                  textSize: 17,
                )
              ],
            ),
            Row(
              children: [
                overAllDebitAndCreditAmount(),
                $helperFile.W20(),
                /*     Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.black45)),
                  child: Icon(Icons.chevron_right),
                ),*/
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

            if (a > b) {
              int c = a - b;
              return Text(
                "₹ $c ",
                style: GoogleFonts.roboto(
                    letterSpacing: 1, fontSize: 20, color: Colors.green),
              );
            } else {
              int c = b - a;
              return Text(
                "₹ $c ",
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

}
