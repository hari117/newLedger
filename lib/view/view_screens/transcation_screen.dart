import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:newledger/model/apptheam/leader_theam.dart';
import 'package:newledger/model/globalState.dart';
import 'package:newledger/view/view_screens/search_user_screen.dart';
import 'package:newledger/view/view_widgets/snakbar.dart';
import 'package:newledger/view/view_widgets/text_widget.dart';
import 'package:newledger/view_models/firebase_activites.dart';
import 'package:newledger/view_models/helper_files.dart';

class TranscationScreen extends StatefulWidget {
  String name;

  @override
  _TranscationScreenState createState() => _TranscationScreenState();

  TranscationScreen({this.name});
}

class _TranscationScreenState extends State<TranscationScreen> {
  TextEditingController _accoutNameController = TextEditingController();
  TextEditingController _transcationAmountController = TextEditingController();

  String dateTime = DateFormat('MM-dd-yyyy').format(DateTime.now()).toString();

  final amountKey = GlobalKey<FormFieldState>();
  final nameKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _accoutNameController.text = widget.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: transcationScreenAppBar(),
      body: Builder(
        builder: (context)=>Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  $helperFile.H10(),
                  accountNameText(),
                  accountNameTextBox(),
                  $helperFile.H10(),
                  CustomText(
                    name: "Transaction",
                    textLetterSpacing: 1.2,
                    textFontWeigth: FontWeight.normal,
                    textColor: $appTheam.primaryColor_02,
                    textSize: 14,
                  ),
                  $helperFile.H5(),
                  transactionAmountTextBox(),
                  CustomText(
                    name: "Select Date",
                    textLetterSpacing: 1.2,
                    textFontWeigth: FontWeight.normal,
                    textColor: $appTheam.primaryColor_02,
                    textSize: 14,
                  ),
                  $helperFile.H10(),
                  InkWell(
                    onTap: ()
                    {
                      print("button pressed");
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime(2050),
                      ).then((date) {
                        dateTime =
                            DateFormat('MM-dd-yyyy').format(date).toString();
                        setState(() {});
                        FocusScope.of(context).requestFocus(FocusNode());
                      });
                  //    FocusScope.of(context).dispose();
                    },
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 10),
                      child:CustomText(
                        name:dateTime,
                        textLetterSpacing: 1.3,
                        textColor: $appTheam.primaryColor_02,
                        textSize: 14,
                      ),
                     /* child: Text(
                      dateTime,
                      style: GoogleFonts.muli(color: Colors.black),
                    ),*/
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          width: 1.2,
                          color: $appTheam.primaryColor_02
                        )
                      ),
                    ),
                  ),
                  $helperFile.H20(),
     Container(
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
              decoration: BoxDecoration(

              ),
            ),
                  $helperFile.H50(),
                ],
              ),
            ),
          ),
        ),
      ),
  //    bottomNavigationBar: bottomBar(),
    );
  }

  // This is Callback funtion to select user
  chooseUser(String name) {
    _accoutNameController.text = name;
  }

  transcationScreenAppBar() {
    return AppBar(
      elevation: 1,
      backgroundColor: Colors.white,
      title: CustomText(
        name: "New Transcation",
        textLetterSpacing: 1.1,
        textFontWeigth: FontWeight.normal,
        textColor: $appTheam.primaryColor_02,
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back,
          color: $appTheam.primaryColor_01,
        ),
      ),
    );
  }

  accountNameTextBox() {
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
        decoration: InputDecoration(
          hintStyle:
          TextStyle(color:Colors.black45, letterSpacing: 1.3,fontSize: 14),
          hintText: "Choose User",
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: $appTheam.primaryColor_01,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: $appTheam.primaryColor_01,
              )),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: $appTheam.primaryColor_01,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  bottomBar() {
    return Container(
      width: double.infinity,
      height: 80,
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            debitButton(),
            $helperFile.W10(),
            creditButton(),
          ],
        ),
      ),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          blurRadius: 10,
          spreadRadius: 0,
          color: Colors.black12,
          offset: Offset(-10, 10),
        )
      ]),
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
            FirebaseCenter.debitAmout(_transcationAmountController.text,
                dateTime, _accoutNameController.text);
            _transcationAmountController.clear();
            dateTime = null;
            _accoutNameController.clear();
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
          } else {
            print("all data are corret");
            FirebaseCenter.creditAmount(_transcationAmountController.text,
                dateTime, _accoutNameController.text);
            _transcationAmountController.clear();
            _accoutNameController.clear();
            dateTime = null;
            Navigator.pop(context);
          //  GlobalSnakBar.show(context,"added",$appTheam.primaryColor_02);
          }
        },
        child: Text(
          "Credit",
          style: GoogleFonts.muli(
              fontSize: 18, letterSpacing: 1.2, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  transactionAmountTextBox() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 2),
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
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
        decoration: InputDecoration(
          hintStyle:
          TextStyle(color:Colors.black45, letterSpacing: 1.3,fontSize: 14),

          hintText: "Amount",
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: $appTheam.primaryColor_01,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(
              color: $appTheam.primaryColor_01,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: $appTheam.primaryColor_01,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  accountNameText() {
    return CustomText(
      name: "Account Name",
      textLetterSpacing: 1.2,
      textFontWeigth: FontWeight.normal,
      textColor: $appTheam.primaryColor_02,
      textSize: 14,
    );
  }


}
