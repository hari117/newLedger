import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newledger/login_screen.dart';
import 'package:newledger/transcation_screen.dart';


class ParticularUserScreen extends StatefulWidget {
  String name;

  ParticularUserScreen({this.name});

  @override
  _ParticularUserScreenState createState() => _ParticularUserScreenState();
}

class _ParticularUserScreenState extends State<ParticularUserScreen> {
  // int totalDebit = 0;
  // int totalCredit = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        title: Text(
          "${widget.name}",
          style: GoogleFonts.muli(
            letterSpacing: 1.1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.blue,
              height: MediaQuery.of(context).size.height * .4,
              child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          size: 20,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        mobileStreamBuilder(),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.mail_outline,
                          size: 20,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        eMailStreamBuilder(),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .9,
                      height: 70,
                      alignment: Alignment.center,
                      child: overAllDebitAndCreditAmount(),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Container(
                                child: Icon(
                                  Icons.arrow_upward_rounded,
                                  size: 50,
                                  color: Colors.green,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                        color: Colors.green, width: 3)),
                              ),

                              //StreamBuilder here
                              SizedBox(
                                width: 10,
                              ),
                              creditStreamBuilder(),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                child: Icon(
                                  Icons.arrow_downward,
                                  size: 50,
                                  color: Colors.red,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                        color: Colors.red, width: 3)),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              debitStreamBuilder(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            StreamBuilder(
              stream: allTranscationRef
                  .doc(google.currentUser.id)
                  .collection(widget.name)
                  .snapshots(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return Center(
                    child: Text("Wait Data Is Loading"),
                  );
                }
                List<DocumentSnapshot> doc = snap.data.documents;
                for (DocumentSnapshot d in doc) {
                  print(d.data());
                }
                ;
                return ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: snap.data.documents.length,
                    itemBuilder: (context, index) {
                      IconData iconChange;
                      Color colorType;
                      if ("Debit" == doc[index]["type"]) {
                        iconChange = Icons.arrow_downward;
                        colorType = Colors.red;
                      } else {
                        iconChange = Icons.arrow_upward;
                        colorType = Colors.green;
                      }
                      return Container(
                        alignment: Alignment.center,
                        margin:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
                              doc[index]["date"],
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
                                  "\$ ${doc[index]["amount"]} Rs",
                                  style: GoogleFonts.muli(),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    });
              },
            )
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

  debitStreamBuilder() {
    return StreamBuilder(
      stream:Firestore.instance.collection("UserAccouts").doc(google.currentUser.id).collection("allUsersList").snapshots(),
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
      stream: Firestore.instance.collection("UserAccouts").doc(google.currentUser.id).collection("allUsersList").snapshots(),
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
      stream: Firestore.instance.collection("UserAccouts").doc(google.currentUser.id).collection("allUsersList").snapshots(),
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
          print(dc.data());
        }
        return null;
      },
    );
  }

  eMailStreamBuilder() {
    return StreamBuilder(
      stream: Firestore.instance.collection("UserAccouts").doc(google.currentUser.id).collection("allUsersList").snapshots(),
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
          // print(dc.data());
        }
        return null;
      },
    );
  }

  overAllDebitAndCreditAmount() {
    return StreamBuilder(
      stream: Firestore.instance.collection("UserAccouts").doc(google.currentUser.id).collection("allUsersList").snapshots(),
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
}
