import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:newledger/model/apptheam/leader_theam.dart';
import 'package:newledger/view/view_screens/search_user_screen.dart';
import 'package:newledger/view/view_widgets/text_widget.dart';
import 'package:newledger/view_models/firebase_activites.dart';
import 'package:newledger/view_models/helper_files.dart';
import 'package:group_radio_button/group_radio_button.dart';

class TranscationScreen extends StatefulWidget {
  String name;

  @override
  _TranscationScreenState createState() => _TranscationScreenState();

  TranscationScreen({this.name});
}

class _TranscationScreenState extends State<TranscationScreen> {
  TextEditingController _accoutNameController = TextEditingController();
  TextEditingController _transcationAmountController = TextEditingController();
  TextEditingController _noteController = TextEditingController();

  String dateTime = DateFormat('MM-dd-yyyy').format(DateTime.now()).toString();
  DateTime firebaseDateTime = DateTime.now();

  final amountKey = GlobalKey<FormFieldState>();
  final nameKey = GlobalKey<FormFieldState>();
  final noteKey = GlobalKey<FormFieldState>();

  String indentiItem = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _accoutNameController.text = widget.name;
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
    return Scaffold(
      backgroundColor: $appTheam.primaryColor_02,
      appBar: transcationScreenAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: SingleChildScrollView(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                $helperFile.H10(),
                headLine("Account Name"),
                accountNameTextFeild(),
                $helperFile.H10(),
                headLine("Transaction"),
                // $helperFile.H5(),
                transactionAmountTextFeild(),
                headLine("Select Date"),
                $helperFile.H10(),
                selectDateTextFeild(),
                $helperFile.H25(),
                headLine("Note"),
                noteTextFeild(),
                $helperFile.H20(),
                ListTile(
                  title: const Text('CREDIT'),
                  leading: Radio(
                    value: "CREDIT",
                    groupValue: indentiItem,
                    onChanged: (value) {
                      setState(() {
                        indentiItem = value;
                      });
                      print(value);
                    },
                  ),
                ),
                ListTile(
                  title: const Text('DEBIT'),
                  leading: Radio(
                    value: "DEBIT",
                    groupValue: indentiItem,
                    onChanged: (value) {
                      setState(() {
                        indentiItem = value;
                      });
                      print(value);
                    },
                  ),
                ),
                submitButtonWidget(),
                //   buttons(),
                $helperFile.H50(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  transcationScreenAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: $appTheam.primaryColor_02,
      title: CustomText(
        name: "New Transcation",
        textLetterSpacing: 1.1,
        textFontWeigth: FontWeight.normal,
        textColor: $appTheam.onWhite_01,
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
      textFontWeigth: FontWeight.normal,
      textColor: $appTheam.onWhite_01,
      textSize: 16,
    );
  }

  accountNameTextFeild() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      key: nameKey,
      child: TextFormField(
        validator: (value) {
          if (value.length == 0 || value == null) {
            return "You Must Choose Name";
          }
        },
        controller: _accoutNameController,
        onTap: () {
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => SearchUser(
                callback: chooseUser,
              ),
            ),
          );
        },
        readOnly: true,
        cursorColor: $appTheam.primaryColor_01,
        style: TextStyle(color: Colors.white10.withOpacity(.5)),
        decoration: InputDecoration(
          suffixIcon: Icon(
            Icons.supervised_user_circle,
            color: Colors.white10.withOpacity(.5),
          ),
          hintStyle: TextStyle(
              color: Colors.white10.withOpacity(.5),
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
      ),
    );
  }

  transactionAmountTextFeild() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 2),
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
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
        autofocus: false,
        style: TextStyle(color: Colors.white10.withOpacity(.5)),
        decoration: InputDecoration(
          suffixIcon: Icon(
            Icons.attach_money,
            color: Colors.white10.withOpacity(.5),
          ),
          hintStyle: TextStyle(
              color: Colors.white10.withOpacity(.5),
              letterSpacing: 1.3,
              fontSize: 14),
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

  selectDateTextFeild() {
    return InkWell(
      onTap: () {
        print("button pressed");
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
                firebaseDateTime = date;
              },
            );
            FocusScope.of(context).requestFocus(FocusNode());
          },
        );
        //    FocusScope.of(context).dispose();
      },
      child: Container(
        height: 60,
        width: double.infinity,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              name: dateTime,
              textLetterSpacing: 1.3,
              textColor: Colors.white10.withOpacity(.5),
              textSize: 14,
            ),
            Icon(Icons.date_range, color: Colors.white10.withOpacity(.5)),
          ],
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: .5,
              color: Colors.black45,
            ),
          ),
        ),
      ),
    );
  }

  noteTextFeild() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      key: noteKey,
      child: TextFormField(
        maxLength: 20,
        controller: _noteController,
        readOnly: false,
        cursorColor: $appTheam.primaryColor_01,
        style: TextStyle(
          color: Colors.white10.withOpacity(.5),
        ),
        decoration: InputDecoration(
          suffixIcon: Icon(
            Icons.note_add_rounded,
            color: Colors.white10.withOpacity(.5),
          ),
          hintStyle: TextStyle(
              color: Colors.white10.withOpacity(.5),
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
      ),
    );
  }

  buttons() {
    return Container(
      width: double.infinity,
      height: 80,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          debitButton(),
          $helperFile.W10(),
          creditButton(),
        ],
      ),
      decoration: BoxDecoration(),
    );
  }

  debitButton() {
    return Expanded(
      child: MaterialButton(
        height: 50,
        color: Colors.red,
        splashColor: Colors.blue,
        onPressed: () async {
          if (_accoutNameController.text == null ||
              _accoutNameController.text == "" ||
              _transcationAmountController.text == null ||
              _transcationAmountController.text == "") {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Warning"),
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
          } else {
            print(_noteController.text);
            await FirebaseCenter.debitAmout(
                _transcationAmountController.text,
                firebaseDateTime,
                _accoutNameController.text,
                _noteController.text);
            _transcationAmountController.clear();
            dateTime = null;
            _accoutNameController.clear();
            _noteController.clear();
            Navigator.pop(context);
          }
          print("");
        },
        child: Text(
          "Debit",
          style: GoogleFonts.muli(
              fontSize: 18, letterSpacing: 1.2, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  creditButton() {
    return Expanded(
      child: MaterialButton(
        height: 50,
        color: Colors.green,
        splashColor: Colors.blue,
        onPressed: () async {
          /*      if (_accoutNameController.text == null ||
              _accoutNameController.text == "" ||
              _transcationAmountController.text == null ||
              _transcationAmountController.text == "") {
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
          } else {
            print("all data are corret");
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
            //  GlobalSnakBar.show(context,"added",$appTheam.primaryColor_02);
          }*/
        },
        child: Text(
          "Credit",
          style: GoogleFonts.muli(
              fontSize: 18, letterSpacing: 1.2, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  submitButtonWidget() {
    return MaterialButton(
      onPressed: () async {
        print("the selected payment type is $indentiItem");
        if (_accoutNameController.text == null ||
            _accoutNameController.text == "" ||
            _transcationAmountController.text == null ||
            _transcationAmountController.text == "") {
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

      }else if(indentiItem=="")
        {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Alert Message"),
                  content: Text("Select Payment Method"),
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
            if(indentiItem==null)
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
                indentiItem=null;
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
                indentiItem=null;
              }

            }
          }




        },
      child: CustomText(
        name: "Submit",
        textColor: $appTheam.onWhite_01,
        textLetterSpacing: 2,
      ),
    );
  }

  // This is Callback funtion to select user
  chooseUser(String name) {
    _accoutNameController.text = name;
  }
}
