import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newledger/model/apptheam/leader_theam.dart';
import 'package:newledger/model/globalState.dart';
import 'package:newledger/view/view_screens/login_screen.dart';
import 'package:newledger/view/view_screens/transcation_screen.dart';
import 'package:newledger/view/view_widgets/loading_widget.dart';
import 'package:newledger/view/view_widgets/particular_transcation_card.dart';
import 'package:newledger/view/view_widgets/text_widget.dart';
import 'package:newledger/view_models/helper_files.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

class ParticularUserScreen extends StatefulWidget {
  String name;

  ParticularUserScreen({this.name});

  @override
  _ParticularUserScreenState createState() => _ParticularUserScreenState();
}

class _ParticularUserScreenState extends State<ParticularUserScreen> {

  ScrollController _scrollController=ScrollController();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(listenPostion);
  }

  listenPostion() {
    if (_scrollController.offset > 29) {
   /*   setState(() {
        isVisible = true;
      });*/

      print("************");
       Provider.of<GlobalState>(context, listen: false).isVisible(true);
    } else {
      {
       /* setState(() {
          isVisible = false;
        });*/
         Provider.of<GlobalState>(context, listen: false).isVisible(false);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
     print("");
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            elevation: 0,
         //title: isVisible ? userName() : Text(""),
         title: Consumer<GlobalState>(
           builder: (context,obj,child)
           {

             print(obj.isVisibleName);
             return obj.isVisibleName ? userName() : Text("");
           }
         ),
            centerTitle: true,
              backgroundColor: Color(0xFF232D48),
            expandedHeight: 50.0,
            pinned: true,

          ),
         SliverToBoxAdapter(
           child:Stack(
             children: [
               upperBody(),
               //   lowerBody(),
               Container(
                 margin: EdgeInsets.only(top: 210),
                 child: lowerBody(),
               )
             ],
           ),
         )

        ],
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     /*    Row(
                        children: [
                          Icon(Icons.supervised_user_circle),
                          userName(),
                        ],
                      ),*/
                      userName(),
                      $helperFile.H20(),
                      mobileNumber(),
                      $helperFile.H15(),
                      eMail(),
                    ],
                  ),
                ),
                Flexible(child: overAllAmount()),
              ],
            ),
            $helperFile.H40(),
            debitAndCreditMoney(),
            $helperFile.H50(),
          ],
        ),
      ),
    );
  }

  lowerBody() {
    return StreamBuilder(
      stream: allTranscationRef.doc(google.currentUser.id).collection(widget.name).orderBy('date',descending: true).snapshots(),
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
            child: CustomText(
              name: "Currerntly There is No Transcations",
              textColor: $appTheam.primaryColor_01,
              textSize: 15,
              textLetterSpacing: 1.2,
            ),
          );
        }
        return ListView.separated(
          separatorBuilder: (context,index)
          {
            return Divider(color:Colors.black.withOpacity(.3),thickness: .25,);
          },
          primary: false,
          shrinkWrap: true,
          itemCount: snap.data.documents.length,
          itemBuilder: (context, index) {
            //   return Text("dummy text");

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
              textColor: Colors.red,
              textSize: 22,
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
              textColor: Colors.green,
              textSize: 22,
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
            int c = a - b;
            if (a > b) {
              return CustomText(
                name: "₹ $c ",
                textLetterSpacing: 1.2,
                textColor: Colors.green,
                textSize: 18,
                textFontWeigth: FontWeight.bold,
              );
            } else {
              return CustomText(
                name: "₹ $c ",
                textLetterSpacing: 1.1,
                textColor: Colors.red,
                textSize: 20,
                textFontWeigth: FontWeight.normal,
                textFontStyle: FontStyle.italic,
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
      /* title: CustomText(
        name: widget.name,
        textLetterSpacing: 1.2,
        textColor: $appTheam.onWhite_01,
      ),*/
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
      alignment: Alignment.centerRight,
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
        Flexible(
          child: Container(
            padding: EdgeInsets.only(left: 10),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: $appTheam.primaryColor_02,
            ),
            /*   child: Row(
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
            ),*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                $helperFile.H10(),
                creditStreamBuilder(),
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
        $helperFile.W15(),
        Flexible(
          child: Container(
            padding: EdgeInsets.only(left: 10),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: $appTheam.primaryColor_02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                $helperFile.H10(),
                debitStreamBuilder(),
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

  userName() {
    return CustomText(
      name: widget.name,
      textLetterSpacing: 1.2,
      textColor: $appTheam.onWhite_01,
      textSize: 17,
    );
  }
}
