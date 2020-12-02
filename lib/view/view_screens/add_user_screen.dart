import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newledger/view/view_screens/login_screen.dart';
import 'package:newledger/view/view_screens/particular_user_screen.dart';
import 'package:newledger/view_models/firebase_activites.dart';
import 'package:newledger/view_models/helper_files.dart';
import 'package:email_validator/email_validator.dart';

class CreateUser extends StatefulWidget {
  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _mobileNumberController = TextEditingController();
  TextEditingController _eMailController = TextEditingController();
  final numberFocusNode = FocusNode();
  final eMailFocusNode = FocusNode();
  final nameFoucusNode = FocusNode();

  final nameKey = GlobalKey<FormFieldState>();
  final numberKey = GlobalKey<FormFieldState>();
  final eMailKey = GlobalKey<FormFieldState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _mobileNumberController.dispose();
    _eMailController.dispose();
  }

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

  nameTextBox() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: TextFormField(
        key: nameKey,
        keyboardType: TextInputType.name,
        focusNode: nameFoucusNode,
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value.length == 0) {
            return "Name Must Atlease 5 letters";
          } else {
            _nameController.text = value;
          }
        },
        controller: _nameController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: "Name *",
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
        onFieldSubmitted: (value) {
          FocusScope.of(context).requestFocus(numberFocusNode);
        },
        onTap: () {
          print("textfeild is pressed");
        },
      ),
    );
  }

  mobileNumberTextBox() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: TextFormField(
        key: numberKey,
        validator: (value) {
          if (value.length == 10) {
            _mobileNumberController.text = value;
          } else {
            return "Enter Correct Number";
          }
        },
        keyboardType: TextInputType.phone,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        textInputAction: TextInputAction.next,
        focusNode: numberFocusNode,

        controller: _mobileNumberController,
        autofocus: false,
        decoration: InputDecoration(
          hintText: "MobileNumber *",
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
        onFieldSubmitted: (value) {
          FocusScope.of(context).requestFocus(eMailFocusNode);
        },
      ),
    );
  }

  emailTextBox() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: TextFormField(
        key: eMailKey,
        validator: (value) {
          if (EmailValidator.validate(value)) {
            _eMailController.text = value;
          } else {
            return "Enter Working Email";
          }
        },
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.done,
        focusNode: eMailFocusNode,
        controller: _eMailController,
        autofocus: false,
        decoration: InputDecoration(
          hintText: "Email *",
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
          if (numberKey.currentState.isValid &&
              nameKey.currentState.isValid &&
              eMailKey.currentState.isValid) {
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

            print("all data is valid");
          } else {
            if (!nameKey.currentState.isValid) {
              FocusScope.of(context).requestFocus(nameFoucusNode);
            } else if (!numberKey.currentState.isValid) {
              FocusScope.of(context).requestFocus(numberFocusNode);
            } else {
              FocusScope.of(context).requestFocus(eMailFocusNode);
            }
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
