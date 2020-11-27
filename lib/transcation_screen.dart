import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:newledger/login_screen.dart';
import 'package:newledger/search_user_screen.dart';

class TranscationScreen extends StatefulWidget {
  String name=DateTime.now().toString();
  @override
  _TranscationScreenState createState() => _TranscationScreenState();

  TranscationScreen({this.name});
}

class _TranscationScreenState extends State<TranscationScreen> {
  TextEditingController accoutNameController = TextEditingController();
  TextEditingController transcationAmountController = TextEditingController();
  TextEditingController transcationNote = TextEditingController();

   String dateTime="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    accoutNameController.text=widget.name;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          color: Colors.black,
          iconSize: 40,
          onPressed: ()
          {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        title: Text(
          "New Transcation",
          style: GoogleFonts.muli(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.3),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                "Accout Name",
                style: GoogleFonts.muli(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: TextField(
                  controller: accoutNameController,
                  onTap: () {
                    print("textfeild  pressed");

                    Navigator.push(
                        context, new MaterialPageRoute(
                        builder: (context) =>  SearchUser(callback:chooseUser,)));
                  },
                  readOnly: true,
                  //keyboardType: TextInputType.number,
                  autofocus: false,
                  decoration: InputDecoration(
                      hintText: "Accout",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.black45,
                          )),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black45),
                        borderRadius: BorderRadius.circular(5.0),
                      ),),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Transcation ",
                style: GoogleFonts.muli(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 2),
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: transcationAmountController,
                        keyboardType: TextInputType.number,
                        autofocus: false,
                        decoration: InputDecoration(
                            hintText: "Amount",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                  color: Colors.black45,
                                )),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black45),
                              borderRadius: BorderRadius.circular(5.0),
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    MaterialButton(
                        height: 57,
                        color: Colors.blue,
                        child: Text(
                          dateTime==""?"Date":dateTime.toString(),
                          style: GoogleFonts.muli(color: Colors.white),
                        ),
                        onPressed: () {
                          print("button pressed");
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate:DateTime(1950) ,
                            lastDate: DateTime(2050),
                          ).then((date){
                            dateTime=DateFormat('yyyy-MM-dd').format(date).toString();

                            setState(() {
                           });
                          });
                        })
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),

            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 80,
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: MaterialButton(
                     height: 50,
                    color: Colors.red,
                    onPressed: () async{

                       if(transcationAmountController.text =="" &&  dateTime=="")
                         {
                           showDialog(
                               context: context,
                               builder: (context) {
                                 return AlertDialog(
                                   title: Text("Alert Message"),
                                   content: Text("You Mush Fill Amount And Date"),
                                   actions: [
                                     FlatButton(
                                       onPressed: () {
                                         Navigator.pop(context);
                                       },
                                       child: Text("ok"),
                                     )
                                   ],
                                 );
                               });
                         }
                       else
                         {
                           print("debit button is pressed");
                           print("entered amount is ${transcationAmountController.text}");
                           Map<String,dynamic> map={"type":"Debit","amount":transcationAmountController.text,"date":dateTime};
                           print("******  map funtion finished**********");
                           await allTranscationRef.doc(google.currentUser.id).collection(accoutNameController.text).doc().setData(map);

                           print("data is pushed to firebase");
                           DocumentSnapshot doc=await Firestore.instance.collection("UserAccouts").doc(google.currentUser.id).collection("allUsersList").doc(accoutNameController.text).get();
                           int total=int.parse(transcationAmountController.text)+doc["inDebit"];
                           print("total $total");
                           Map<String,dynamic> map2={"inDebit":total};
                           await Firestore.instance.collection("UserAccouts").doc(google.currentUser.id).collection("allUsersList").doc(accoutNameController.text).update(map2);
                           print("debit value updated in allUsersList");
                           transcationAmountController.clear();
                           dateTime=null;
                           Navigator.pop(context);
                         }
                          print("");




                    },
                  child: Text("Dedit",style: GoogleFonts.muli(fontSize: 18,letterSpacing: 1.2,fontWeight: FontWeight.w500),),
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: MaterialButton(
                  height: 50,
                  color: Colors.green,
                    onPressed: () async{

                    if(transcationAmountController.text =="" &&  dateTime=="")
                      {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Alert Message"),
                                content: Text("You Mush Fill Amount And Date"),
                                actions: [
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("ok"),
                                  )
                                ],
                              );
                            });

                      }else
                        {
                          print("Credit button is pressed");
                          print("entered amount is ${transcationAmountController.text}");
                          print("entered amount is ${accoutNameController.text}");
                          Map<String,dynamic> map={"type":"Credit","amount":transcationAmountController.text,"date":dateTime};
                          print("******  map funtion finished**********");
                          await allTranscationRef.doc(google.currentUser.id).collection(accoutNameController.text).doc().setData(map);
                          print("data is pushed to firebase");

                          // adding total credit transcation value in alluserList
                          DocumentSnapshot doc=await Firestore.instance.collection("UserAccouts").doc(google.currentUser.id).collection("allUsersList").doc(accoutNameController.text).get();

                              int total=int.parse(transcationAmountController.text)+doc["inCredit"];
                              print("total $total");
                              Map<String,dynamic> map2={"inCredit":total};
                              await Firestore.instance.collection("UserAccouts").doc(google.currentUser.id).collection("allUsersList").doc(accoutNameController.text).update(map2);

                              transcationAmountController.clear();
                              dateTime=null;
                              Navigator.pop(context);


                        }

                    },
                  child: Text("Credit",style: GoogleFonts.muli(fontSize: 18,letterSpacing: 1.2,fontWeight: FontWeight.w500),),
                    ),
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          boxShadow: [

            BoxShadow(
              blurRadius: 10,
              spreadRadius: 0,
              color: Colors.black12,
              offset: Offset(-10,10),
            )
          ]
        ),
      ),
    );
  }

  // This is Callback funtion to select user
  chooseUser(String name)
  {
    accoutNameController.text=name;
  }
}
