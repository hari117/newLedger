import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:newledger/view/view_screens/search_user_screen.dart';
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

  String dateTime =DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              $helperFile.H10(),
              accountNameText(),
              accountNameTextBox(),
              $helperFile.H10(),
              Text(
                "Transaction",
                style: GoogleFonts.muli(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2),
              ),
              $helperFile.H5(),
              transactionAmountTextBox(),

            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomBar(),
    );
  }

  // This is Callback funtion to select user
  chooseUser(String name) {
    _accoutNameController.text = name;
  }
  transcationScreenAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(Icons.keyboard_arrow_left),
        color: Colors.black,
        iconSize: 40,
        onPressed: () {
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
    );
  }
  accountNameTextBox() {
    return  Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: TextField(
        controller: _accoutNameController,
        onTap: () {

          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => SearchUser(
                    callback: chooseUser,
                  )));
        },
        readOnly: true,

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
          ),
        ),
      ),
    );
  }
  bottomBar() {
    return  Container(
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
    return  Expanded(
      child: MaterialButton(
        height: 50,
        color: Colors.red,
        splashColor: Colors.blue,
        onPressed: () async {
          if (_transcationAmountController.text == "" &&
              dateTime == "") {
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


            FirebaseCenter.debitAmout(
                _transcationAmountController.text,
                dateTime,
                _accoutNameController.text);

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
              fontSize: 18,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w500),
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
          if (_transcationAmountController.text == "" &&
              dateTime == "") {
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

            FirebaseCenter.creditAmount(
                _transcationAmountController.text,
                dateTime,
                _accoutNameController.text);
            _transcationAmountController.clear();
            _accoutNameController.clear();
            dateTime = null;
            Navigator.pop(context);
          }
        },
        child: Text(
          "Credit",
          style: GoogleFonts.muli(
              fontSize: 18,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
  transactionAmountTextBox() {
    return    Container(
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
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: _transcationAmountController,
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
          $helperFile.W10(),
          MaterialButton(
              height: 57,
              color: Colors.blue,
              child: Text(dateTime,
                style: GoogleFonts.muli(color: Colors.white),
              ),
              onPressed: () {
                print("button pressed");
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1950),
                  lastDate: DateTime(2050),
                ).then((date) {
                  dateTime = DateFormat('yyyy-MM-dd')
                      .format(date)
                      .toString();
                  FocusScope.of(context)
                      .requestFocus(new FocusNode());
                  setState(() {});
                });
              })
        ],
      ),
    );
  }
  accountNameText() {
    return  Text(
      "Account Name",
      style: GoogleFonts.muli(
          fontSize: 18,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2),
    );
  }
  transcationNameText() {
    return Text(
      "Transcation ",
      style: GoogleFonts.muli(
          fontSize: 18,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2),
    );
  }
}
