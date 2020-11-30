import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newledger/view/view_screens/splash_screen.dart';
import 'package:newledger/view/view_screens/particular_user_screen.dart';
import 'package:newledger/view_models/firebase_activites.dart';
import 'package:newledger/view_models/helper_files.dart';

class CreateUser extends StatefulWidget {
  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {

  TextEditingController _nameController = TextEditingController();
  TextEditingController _mobileNumberController = TextEditingController();
  TextEditingController _eMailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: addUserAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              pageText(),
              $helperFile.H40(),
              nameTextBox(),
              mobileNumberTextBox(),
              emailTextBox(),
              addButton(),
            ],
          ),
        ),
      ),
    );
  }

  //Widget Funtions start from here .....

  nameTextBox() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: TextField(
        controller: _nameController,
        autofocus: false,
        decoration: InputDecoration(
          hintText: "Name",
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(5.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: Colors.black45),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black45),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  mobileNumberTextBox() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: TextField(
        keyboardType: TextInputType.number,
        controller: _mobileNumberController,
        autofocus: false,
        decoration: InputDecoration(
          hintText: "MobileNumber",
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(5.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(
              color: Colors.black45,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black45),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  emailTextBox() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: TextField(
        controller: _eMailController,
        autofocus: false,
        decoration: InputDecoration(
          hintText: "Email",
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

  addButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      width: double.infinity,
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        height: 50,
        onPressed: () async {
          if (_nameController.text == null ||
              _nameController.text == "" &&
                  _mobileNumberController.text == null ||
              _mobileNumberController.text == "" &&
                  _eMailController.text == null ||
              _eMailController.text == "") {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Alert Message"),
                  content: Text("Please fill All Details"),
                  actions: [
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("ok"),
                    )
                  ],
                );
              },
            );
          } else {


            FirebaseCenter.addParticularUser(_eMailController.text, 0, 0,
                _mobileNumberController.text, _nameController.text);
            String name = _nameController.text;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ParticularUserScreen(
                  name: name,
                ),
              ),
            );
            _nameController.clear();
            _mobileNumberController.clear();
            _eMailController.clear();
          }
        },
        color: Colors.blue,
        child: Text("ADD"),
      ),
    );
  }

  addUserAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      elevation: 0.0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  pageText() {
    return Text(
      "Create Account",
      style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          letterSpacing: 1.1,
          fontWeight: FontWeight.w500),
    );
  }
}
