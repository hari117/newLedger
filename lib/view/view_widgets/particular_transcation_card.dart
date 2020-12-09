import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newledger/model/apptheam/leader_theam.dart';
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
  bool isExpand = false;
  bool isMove = false;

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
          ),
          IconSlideAction(
            icon: Icons.delete,
            foregroundColor: Colors.red,
            color: $appTheam.primaryColor_02,
            onTap: ()
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
                                      FirebaseCenter.deleteParticularTranscationList(
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
         //  margin: EdgeInsets.only(left: 20,right: 20),
          alignment: Alignment.center,
         padding: EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            border: Border(
                left: BorderSide(
              color: colorType,
              width: 3,
            )),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                color: $appTheam.primaryColor_02.withOpacity(.3),
                offset: Offset(
                  2.0, // Move to right 10  horizontally
                  3.0, // Move to bottom 10 Vertically
                ),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                /*  $helperFile.H5(),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: $appTheam.primaryColor_02,
                        size: 15,
                      ),
                      $helperFile.W10(),
                      CustomText(
                        name:
                            "${DateFormat('MM-dd-yyyy').format(widget.doc["date"].toDate()).toString()}",
                        textColor: $appTheam.primaryColor_01,
                      ),
                    ],
                  ),
                  $helperFile.H5(),
                  Row(
                    children: [
                      Icon(
                        Icons.lock_clock,
                        color: $appTheam.primaryColor_02,
                        size: 15,
                      ),
                      $helperFile.W10(),
                      CustomText(
                        name:"${DateFormat('HH-mm').format(widget.doc["date"].toDate()).toString()}",
                        textColor: $appTheam.primaryColor_01,
                      ),
                    ],
                  ),
                  $helperFile.H5(),
                  Row(
                    children: [
                      Icon(
                        Icons.note,
                        color: $appTheam.primaryColor_02,
                        size: 15,
                      ),
                      $helperFile.W10(),
                      CustomText(
                        name: widget.doc["note"].toString(),
                        textColor: $appTheam.primaryColor_01,
                      ),
                    ],
                  ),
                  $helperFile.H5(),*/
                  model_01(),
                ],
              ),

              Column(
              //  mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomText(
                    name: "₹ ${widget.doc["amount"]}",
                    textColor: colorType,
                    textSize: 18,
                  ),
                  $helperFile.H10(),
                  CustomText(
                    name: widget.doc["type"],
                    textColor: colorType,
                    textSize: 10,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  moveUpdates(DragUpdateDetails details) {
    if (details.delta.dx < 0) {
      setState(() {
        isMove = true;
      });
    } else {
      setState(() {
        isMove = false;
      });
    }
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
                                FirebaseCenter.deleteParticularTranscationList(
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



  model_01()
  {
     return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         $helperFile.H10(),
         Row(children: [
           Row(
             children: [
               Icon(
                 Icons.calendar_today,
                 color: $appTheam.primaryColor_02,
                 size: 15,
               ),
               $helperFile.W10(),
               CustomText(
                 name:
                 "${DateFormat('MM-dd-yyyy').format(widget.doc["date"].toDate()).toString()}",
                 textColor: $appTheam.primaryColor_01,
               ),
             ],
           ),
           $helperFile.W15(),
           Row(
             children: [
               Icon(
                 Icons.update,
                 color: $appTheam.primaryColor_02,
                 size: 15,
               ),
               $helperFile.W5(),
               CustomText(
                 name:"${DateFormat('HH-mm').format(widget.doc["date"].toDate()).toString()}",
                 textColor: $appTheam.primaryColor_01,
               ),
             ],
           ),
         ],),
         $helperFile.H10(),
         Row(
           children: [
             Icon(
               Icons.note_add,
               color: $appTheam.primaryColor_02,
               size: 15,
             ),
             $helperFile.W10(),
             CustomText(
               name: widget.doc["note"].toString(),
               textColor: $appTheam.primaryColor_01,
             ),
           ],
         ),
         $helperFile.H10(),
       ],
     );
  }

  model_02()
  {
   return Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
       $helperFile.H5(),
       Row(
         children: [
           Icon(
             Icons.calendar_today,
             color: $appTheam.primaryColor_02,
             size: 15,
           ),
           $helperFile.W10(),
           CustomText(
             name:
             "${DateFormat('MM-dd-yyyy').format(widget.doc["date"].toDate()).toString()}",
             textColor: $appTheam.primaryColor_01,
           ),
         ],
       ),
       $helperFile.H5(),
       Row(
         children: [
           Icon(
             Icons.lock_clock,
             color: $appTheam.primaryColor_02,
             size: 15,
           ),
           $helperFile.W10(),
           CustomText(
             name:"${DateFormat('HH-mm').format(widget.doc["date"].toDate()).toString()}",
             textColor: $appTheam.primaryColor_01,
           ),
         ],
       ),
       $helperFile.H5(),
       Row(
         children: [
           Icon(
             Icons.note,
             color: $appTheam.primaryColor_02,
             size: 15,
           ),
           $helperFile.W10(),
           CustomText(
             name: widget.doc["note"].toString(),
             textColor: $appTheam.primaryColor_01,
           ),
         ],
       ),
       $helperFile.H5(),
     ],
   );
  }









}


