import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:newledger/model/apptheam/leader_theam.dart';
import 'package:newledger/view/view_screens/login_screen.dart';
import 'package:newledger/view/view_screens/search_user_screen.dart';
import 'package:newledger/view/view_widgets/text_widget.dart';
import 'package:newledger/view_models/firebase_activites.dart';
import 'package:newledger/view_models/helper_files.dart';
import 'package:group_radio_button/group_radio_button.dart';

class TranscationScreen extends StatefulWidget {
  String name;
  DocumentSnapshot documentSnapshot;
  @override
  _TranscationScreenState createState() => _TranscationScreenState();

  TranscationScreen({this.name,this.documentSnapshot});
}

class _TranscationScreenState extends State<TranscationScreen> {
  TextEditingController _accoutNameController = TextEditingController();
  TextEditingController _transcationAmountController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  TextEditingController _dateTimeController = TextEditingController();
  TextEditingController _searchTextController = TextEditingController();
  String dateTime = DateFormat('MM-dd-yyyy').format(DateTime.now()).toString();
  DateTime firebaseDateTime = DateTime.now();

  final amountKey = GlobalKey<FormFieldState>();
  final nameKey = GlobalKey<FormFieldState>();
  final noteKey = GlobalKey<FormFieldState>();

  String indentiItem = "CREDIT";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _accoutNameController.text = widget.name;
    _dateTimeController.text=dateTime;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _accoutNameController.dispose();
    _transcationAmountController.dispose();
    _noteController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.documentSnapshot!=null)
      {
        print("the document contain values");
      }else
        {
          print("the document is empty");
        }
    return Scaffold(
      backgroundColor:Colors.white,
      appBar: transcationScreenAppBar(),
      body: SingleChildScrollView(
        // physics: BouncingScrollPhysics(),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: $appTheam.primaryColor_03,
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 180,
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  transactionAmountTextFeild(),
                  CustomText(
                    name: "Rupees",
                    textColor: $appTheam.onWhite_01,
                    textLetterSpacing: 2,
                    textSize: 14,
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              child: Column(
                children: [
                  Column(
                    children: [
                      $helperFile.H10(),
                      radioButtons(),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        accountNameTextFeild(),
                        $helperFile.H20(),
                        dateTimeTextFeild(),
                        $helperFile.H20(),
                        noteTextFeild(),
                        $helperFile.H45(),
                        submitButtonWidget(),
                      ],
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            ),

          ],
        ),
      ),
    );
  }

  transcationScreenAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: $appTheam.primaryColor_03,
      title: CustomText(
        name: "New Transcation",
        textLetterSpacing: 1.1,
        textFontWeigth: FontWeight.normal,
        textColor: $appTheam.onWhite_01,
        textSize: 17,
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back,
          color: $appTheam.onWhite_01,
        ),
      ),
    );
  }

  headLine(String textWord) {
    return CustomText(
      name: textWord,
      textLetterSpacing: 1.2,
      textColor: $appTheam.primaryColor_01,
      textSize: 16,
    );
  }

  accountNameTextFeild() {
    return TextFormField(
      validator: (value) {
        if (value.length == 0 || value == null) {
          return "You Must Choose Name";
        }
      },
      controller: _accoutNameController,
      onTap: () {
        /*   Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => SearchUser(
              callback: chooseUser,
            ),
          ),
        );*/
        displayBottomSheet(context);
      },
      readOnly: true,
      cursorColor: $appTheam.primaryColor_03,
      style: TextStyle(
          color: $appTheam.primaryColor_03, letterSpacing: 1.3, fontSize: 14),
      decoration: InputDecoration(
        labelStyle: TextStyle(color:Colors.black45, fontSize: 14),
        labelText: ("Choose user"),
        suffixIcon: Icon(
          Icons.supervised_user_circle,
          color: $appTheam.primaryColor_03,
        ),
        hintStyle: TextStyle(
            color: Colors.black.withOpacity(.2),
            letterSpacing: 1.3,
            fontSize: 14),
        hintText: "Choose User",
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black45,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(
              color: Colors.black45,
            )),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black45,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }

  transactionAmountTextFeild() {
    return Container(
      alignment: Alignment.center,

      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        textInputAction: TextInputAction.next,
        cursorColor: $appTheam.primaryColor_02,
        key: amountKey,
        validator: (value) {
          if (value == null) {
            return "enter ammount";
          }
        },
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        controller: _transcationAmountController,
        keyboardType: TextInputType.number,
        autofocus: true,
        style: TextStyle(color: Colors.white, fontSize: 22),
        decoration: InputDecoration(

          suffixIcon: Icon(
            Icons.attach_money,
            color: $appTheam.primaryColor_03,
          ),
          hintStyle: TextStyle(
              color: Colors.white10.withOpacity(.5),
              letterSpacing: 1.3,
              fontSize: 22),
          hintText: "Amount",
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black45,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(
              color: Colors.black45,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black45,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  dateTimeTextFeild() {
    return TextFormField(
      onTap: ()
      {
        displayCalender(context);
      },
      controller: _dateTimeController,
      readOnly: true,
      cursorColor: $appTheam.primaryColor_01,
      style: TextStyle(
          color: $appTheam.primaryColor_03,
          fontSize: 14
      ),
      decoration: InputDecoration(
        labelStyle: TextStyle(color:Colors.black45, fontSize: 14),
        labelText:"Add Note To Remember",
        suffixIcon: Icon(
          Icons.date_range_rounded,
          color: $appTheam.primaryColor_03,
        ),
        hintStyle: TextStyle(
            color: Colors.black.withOpacity(.2),
            letterSpacing: 1.3,
            fontSize: 14),
        hintText: "Note",
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(
              color: Colors.black45,
            )),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black45,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }
  noteTextFeild() {
    return TextFormField(
      inputFormatters: [
        LengthLimitingTextInputFormatter(20)
      ],

      controller: _noteController,
      readOnly: false,
      cursorColor: $appTheam.primaryColor_01,
      textInputAction: TextInputAction.done,
      style: TextStyle(
          color: $appTheam.primaryColor_03, fontSize: 14),
      decoration: InputDecoration(
        labelText: "Add A Word To Remember",
        labelStyle: TextStyle(color:Colors.black45, fontSize: 14),

      // contentPadding: EdgeInsets.only(top:10 ),
        suffixIcon: Icon(
          Icons.note_add_rounded,
          color: $appTheam.primaryColor_03,
        ),
        hintStyle: TextStyle(
            color: Colors.black.withOpacity(.2),
            letterSpacing: 1.3,
            fontSize: 14),
        hintText: "Note",
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(
              color: Colors.black45,
            )),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black45,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }

  submitButtonWidget() {
    return Align(
      alignment: Alignment.center,
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        minWidth: double.infinity,
        height: 60,
        color: $appTheam.primaryColor_01,
        elevation: 3,
        splashColor: $appTheam.primaryColor_03,
        onPressed: () async {
          print("the selected payment type is $indentiItem");
          if (_accoutNameController.text == null ||
              _accoutNameController.text == "" ||
              _transcationAmountController.text == null ||
              _transcationAmountController.text == "") {
            alertDialogWidget(context);
          } else if (indentiItem == "") {
            alertDialogWidget(context);
          } else {
            if (indentiItem == null) {
              alertDialogWidget(context);
            } else {
              if (indentiItem == "DEBIT") {
                await FirebaseCenter.debitAmout(
                    _transcationAmountController.text,
                    firebaseDateTime,
                    _accoutNameController.text,
                    _noteController.text);
                _transcationAmountController.clear();
                dateTime = null;
                _accoutNameController.clear();
                _noteController.clear();
                indentiItem = null;
                Navigator.pop(context);
              } else {
                await FirebaseCenter.creditAmount(
                    _transcationAmountController.text,
                    firebaseDateTime,
                    _accoutNameController.text,
                    _noteController.text);
                _transcationAmountController.clear();
                _accoutNameController.clear();
                _noteController.clear();
                dateTime = null;
                Navigator.pop(context);
                indentiItem = "";
              }
            }
          }
        },
        child: CustomText(
          name: "Submit",
          textColor: $appTheam.onWhite_01,
          textLetterSpacing: 2,
          textSize: 18,
        ),
      ),
    );
  }

  chooseUser(String name) {
    _accoutNameController.text = name;
  }

  radioButtons() {
    return Container(
      height: 80,
      width: double.infinity,
      child: Row(
        children: [
          Radio(
              activeColor: Colors.green,
              value: "CREDIT",
              groupValue: indentiItem,
              onChanged: (value) {
                setState(
                  () {
                    indentiItem = value;
                  },
                );
              }),
          CustomText(
            name: "CREDIT",
            textSize: 14,
            textColor: $appTheam.primaryColor_03,
            textLetterSpacing: 1.4,
          ),
          $helperFile.W20(),
          Radio(
            activeColor: Colors.red,
            value: "DEBIT",
            groupValue: indentiItem,
            onChanged: (value) {
              setState(
                () {
                  indentiItem = value;
                },
              );
            },
          ),
          CustomText(
            name: "DEBIT",
            textSize: 14,
            textColor: $appTheam.primaryColor_03,
            textLetterSpacing: 1.4,
          ),

        ],
      ),
    );
  }

  void displayBottomSheet(
    context,
  ) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              $helperFile.H60(),
              Row(
                children: [
                  Expanded(child: Container(height: 45,child:searchTextFeild())),
                 // $helperFile.W20(),
                  InkWell(
                    child: CustomText(name: "Cancel",textSize: 12,textColor:Colors.black.withOpacity(.5),),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  $helperFile.W20(),

                ],
              ),
              $helperFile.H20(),
              StreamBuilder(
                stream: Firestore.instance
                    .collection("UserAccouts")
                    .doc(google.currentUser.id)
                    .collection("allUsersList")
                    .snapshots(),
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return Center(
                      child: CustomText(
                        name: "Wait Data is Loading",
                        textLetterSpacing: 1.3,
                        textColor: $appTheam.onWhite_01,
                        textSize: 22,
                      ),
                    );
                  }
                  List<DocumentSnapshot> doc = snap.data.documents;
                  return ListView.separated(
                    separatorBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.only(top: 5),
                        child: Divider(thickness: 1,),
                      );
                    },
                    primary: false,
                    shrinkWrap: true,
                    itemCount: snap.data.documents.length,
                    itemBuilder: (context, index) {
                      String userName = doc[index]["name"];
                      return InkWell(
                        onTap: () {
                          _accoutNameController.text = userName;
                          Navigator.pop(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          /* margin: EdgeInsets.symmetric(horizontal: 20),
                          padding: EdgeInsets.symmetric(horizontal: 10),*/
                       //   height: 50,
                          //height: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  $helperFile.W20(),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: $appTheam.primaryColor_03,
                                      shape: BoxShape.circle,
                                    ),
                                    child: CustomText(
                                        name: "${userName[0].toUpperCase()}",
                                        textColor: Colors.white,
                                        textSize: 15),
                                  ),
                                  $helperFile.W15(),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomText(
                                        name: userName,
                                        textLetterSpacing: 1.3,
                                        textColor: $appTheam.primaryColor_03,
                                        textSize: 17,
                                      ),
                                      $helperFile.H5(),
                                      CustomText(
                                        name: doc[index]["mobileNumber"],
                                        textLetterSpacing: 1.3,
                                        textColor: Colors.black.withOpacity(.5),
                                        textSize: 12,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          );
          return Text("hi");
        });
  }

  searchTextFeild() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 20),

      child: TextFormField(
        autofocus: true,
        controller: _searchTextController,
        cursorColor: Colors.black.withOpacity(.5),
        style: TextStyle(color: $appTheam.primaryColor_03),
        decoration: InputDecoration(

          filled: true,
          fillColor:Colors.black.withOpacity(.03),
          contentPadding: EdgeInsets.only(top: 5),
          suffixIcon: GestureDetector(
            onTap: ()
            {
              print("search icon is clicked");
              _searchTextController.clear();
            },
            child: Icon(
              Icons.clear,
              color:Colors.black.withOpacity(.5),
            ),
          ),

          prefixIcon: Icon(Icons.search, color:Colors.black.withOpacity(.5),),

          hintStyle: TextStyle(
              color: Colors.black.withOpacity(.2),
              letterSpacing: 1.3,
              fontSize: 14),
          hintText: "Search User",
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color:Colors.black.withOpacity(.5),
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: Colors.black.withOpacity(.5),
              )),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color:Colors.black.withOpacity(.5),
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }



  alertDialogWidget(context)
  {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: CustomText(
              name:"Opps Message",
              textLetterSpacing: 1.3,
              textColor: $appTheam.primaryColor_02,
              textSize: 12,
            ),
            content: CustomText(
                  name:"You Mush Choose User\nAnd Fill Amount Before Submitting",
                  textLetterSpacing: 1.3,
                  textColor: $appTheam.primaryColor_01,
                  textSize: 15,

                ),

            actions: [
              FlatButton(
                minWidth: 100,
                height: 40,
                color: $appTheam.primaryColor_01,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: CustomText(
                  name:"Ok",
                  textLetterSpacing: 1.3,
                  textColor: $appTheam.onWhite_01,
                  textSize: 14,
                )
              ),
              $helperFile.W20(),
            ],
          );
        });
  }



  displayCalender(content)
  {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2050),
    ).then(
          (date) {
        setState(
              () {
                dateTime = DateFormat('MM-dd-yyyy').format(date).toString();
            _dateTimeController.text = DateFormat('MM-dd-yyyy').format(date).toString();
            firebaseDateTime = date;
          },
        );
        //FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }



}
