import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newledger/view_models/firebase_activites.dart';

class TranscationCard extends StatefulWidget {
  DocumentSnapshot doc;
  String name;
  Function callback;
  TranscationCard({this.doc,this.name,this.callback});

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
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: 80,
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
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.doc["date"],
            style: GoogleFonts.muli(),
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
              Text(
                "\$ ${widget.doc["amount"]} Rs",
                style: GoogleFonts.muli(),
              ),
              SizedBox(
                width: 7,
              ),
              InkWell(
                onTap: ()
                {
                 print("********* delete funtion is pressed **********");
                 FirebaseCenter.deleteParticularTranscationList(widget.doc,widget.name);
                 widget.callback();
                },
                child: Icon(
                  Icons.delete,
                  color: Colors.black45,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
