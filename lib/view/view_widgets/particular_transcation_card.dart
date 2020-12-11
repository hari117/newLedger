import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newledger/model/apptheam/leader_theam.dart';
import 'package:newledger/view/view_screens/particular_user_screen.dart';
import 'package:newledger/view/view_screens/transcation_screen.dart';
import 'package:newledger/view/view_widgets/snakbar.dart';
import 'package:newledger/view/view_widgets/text_widget.dart';
import 'package:newledger/view_models/firebase_activites.dart';
import 'package:newledger/view_models/helper_files.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TranscationCard extends StatefulWidget {
  DocumentSnapshot doc;
  String name;

  TranscationCard({this.doc, this.name});

  @override
  _TranscationCardState createState() => _TranscationCardState();
}

class _TranscationCardState extends State<TranscationCard> {
  /*bool isExpand = false;
  bool isMove = false;*/

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
      builder: (context) => Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.15,
        secondaryActions: [
          IconSlideAction(
            foregroundColor: Colors.green,
            icon: Icons.upgrade,
            color: $appTheam.primaryColor_02,
            onTap: ()
           async {

              print("update icon is pressed entry");
              Navigator.push(
                  context, new MaterialPageRoute(
                  builder: (context) => TranscationScreen(name:widget.name,documentSnapshot: widget.doc,),));


              print("update icon is pressed exit");


            },
          ),
          IconSlideAction(
            icon: Icons.delete,
            foregroundColor: Colors.red,
            color: $appTheam.primaryColor_02,
            onTap: () {
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
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              $helperFile.H15(),
                              $helperFile.H10(),
                              Text(
                                "Are You Sure To Delete This Record ?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    letterSpacing: 1.3,
                                    height: 1.2,
                                    color: $appTheam.primaryColor_02,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                              $helperFile.H30(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  FlatButton(
                                    minWidth: 100,
                                    height: 35,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: CustomText(
                                      name: "No",
                                      textSize: 18,
                                      textColor: Colors.red,
                                    ),
                                    color: $appTheam.primaryColor_02,
                                  ),
                                  FlatButton(
                                    minWidth: 100,
                                    height: 35,
                                    onPressed: () async {
                                      $fireBase
                                          .deleteParticularTranscationList(
                                              widget.doc, widget.name);
                                      triggerSnakbar();
                                      Navigator.pop(context);
                                    },
                                    child: CustomText(
                                      name: "Yes",
                                      textSize: 18,
                                      textColor: Colors.green,
                                    ),
                                    color: $appTheam.primaryColor_02,
                                  ),
                                ],
                              ),
                              $helperFile.H15(),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            },
          ),
        ],
        child: Container(
          height: 90,
          // margin: EdgeInsets.only(left: 20),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(

            color: Colors.white,
            boxShadow: [

            ],
          ),
          child: Row(
            children: [
              model_01(),
              Expanded(
                child: Padding(
                  padding:EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      $helperFile.H15(),
                      CustomText(
                        name: "₹ ${widget.doc["amount"]}",
                        textColor: $appTheam.primaryColor_03,
                        textSize: 18,
                      ),
                      $helperFile.H10(),
                      Row(
                        children: [
                          Icon(
                            Icons.note,
                            color: $appTheam.primaryColor_02,
                            size: 15,
                          ),
                          $helperFile.W5(),
                          Expanded(
                            child: CustomText(
                              name: widget.doc["note"].toString()=="" ?"Empty Note":widget.doc["note"].toString(),
                              textColor: $appTheam.primaryColor_03,
                              textSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 50,
                height: 50,
                alignment: Alignment.topRight,
                child: CustomText(
                  name: "${widget.doc["type"].toString().toUpperCase()}",
                  textColor: colorType,
                  textSize: 10,
                  textFontWeigth: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  triggerSnakbar() {
    GlobalSnakBar.show(
        context, "Deleted Successfully", $appTheam.primaryColor_02);
  }

  deletetranscationCard() {
    return InkWell(
      onTap: () {
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        $helperFile.H15(),
                        $helperFile.H10(),
                        Text(
                          "Are You Sure To Delete This Record ?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              letterSpacing: 1.3,
                              height: 1.2,
                              color: $appTheam.primaryColor_02,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        $helperFile.H30(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            FlatButton(
                              minWidth: 100,
                              height: 35,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: CustomText(
                                name: "No",
                                textSize: 18,
                                textColor: Colors.red,
                              ),
                              color: $appTheam.primaryColor_02,
                            ),
                            FlatButton(
                              minWidth: 100,
                              height: 35,
                              onPressed: () async {
                                $fireBase.deleteParticularTranscationList(
                                    widget.doc, widget.name);
                                triggerSnakbar();
                                Navigator.pop(context);
                              },
                              child: CustomText(
                                name: "Yes",
                                textSize: 18,
                                textColor: Colors.green,
                              ),
                              color: $appTheam.primaryColor_02,
                            ),
                          ],
                        ),
                        $helperFile.H15(),
                      ],
                    ),
                  ),
                ),
              );
            });
      },
      child: Icon(
        Icons.delete,
        color: $appTheam.primaryColor_01,
        size: 23,
      ),
    );
  }

  updateRecord() {}

  model_01() {
    return Container(
          width: 100,
          /*height: 75,*/
      margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.symmetric(horizontal:10,vertical:10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(.05),
              borderRadius: BorderRadius.circular(5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //this is time and pm
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    name:
                    "${DateFormat('hh:mm').format(widget.doc["date"].toDate()).toString()}",
                    textColor: $appTheam.primaryColor_01,textSize: 15,textFontWeigth: FontWeight.bold,
                  ),
                  CustomText(
                    name:
                    "${DateFormat('a').format(widget.doc["date"].toDate()).toString()}",
                    textColor: $appTheam.primaryColor_01,textSize: 15,textFontWeigth: FontWeight.bold,
                  ),
                ],
              ),
              $helperFile.H5(),
              Row(
                children: [
                  // this widget represent date
                  CustomText(
                    name:
                        "${DateFormat('dd MMM yyyy').format(widget.doc["date"].toDate()).toString().toUpperCase()}",
                    textColor: $appTheam.primaryColor_03,textSize: 9,textLetterSpacing: 1.1,textFontWeigth: FontWeight.bold,
                  ),

                  //this widget represent month

                /*  CustomText(
                    name:
                        "${DateFormat('MMM').format(widget.doc["date"].toDate()).toString().toUpperCase()}",
                    textColor: $appTheam.primaryColor_03,textSize: 10,textLetterSpacing: 1.1,
                  ),

                  //this widget represent year
                  CustomText(
                    name:
                        "${DateFormat('yyyy').format(widget.doc["date"].toDate()).toString()}",
                    textColor: $appTheam.primaryColor_03,textSize: 10,
                  ),*/
                ],
              ),
            ],
          ),
        );



  }
}
