import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newledger/model/apptheam/leader_theam.dart';
import 'package:newledger/view/view_widgets/snakbar.dart';
import 'package:newledger/view/view_widgets/text_widget.dart';
import 'package:newledger/view_models/firebase_activites.dart';

class TranscationCard extends StatefulWidget {
  DocumentSnapshot doc;
  String name;

  TranscationCard({this.doc, this.name});

  @override
  _TranscationCardState createState() => _TranscationCardState();
}

class _TranscationCardState extends State<TranscationCard> {
  @override
  Widget build(BuildContext context) {
    IconData iconChange;
    Color colorType;
    if ("Debit" == widget.doc["type"]) {
      iconChange = Icons.arrow_downward;
      colorType = Colors.red;
    } else {
      iconChange = Icons.arrow_upward;
      colorType = Colors.green;
    }
    return Builder(
      builder: (context) => Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 80,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              color: $appTheam.primaryColor_02.withOpacity(.5),
              offset: Offset(
                3.0, // Move to right 10  horizontally
                3.0, // Move to bottom 10 Vertically
              ),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              name: widget.doc["date"],
              textColor: $appTheam.primaryColor_01,
            ),
            Row(
              children: [
                Icon(
                  iconChange,
                  color: colorType,
                ),
                SizedBox(
                  width: 3,
                ),
                CustomText(
                  name: "₹ ${widget.doc["amount"]}",
                  textColor: $appTheam.primaryColor_01,
                  textSize: 17,
                ),
                SizedBox(
                  width: 7,
                ),
                InkWell(
                  onTap: () {
                    print("********* delete funtion is pressed **********");
                    FirebaseCenter.deleteParticularTranscationList(
                        widget.doc, widget.name);
                    GlobalSnakBar.show(
                         context,
                   "Deleted Successfully",
                       $appTheam.primaryColor_02);
                  },
                  child: Icon(
                    Icons.delete,
                    color: $appTheam.primaryColor_01,
                    size: 23,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
