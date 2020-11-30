import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newledger/view/view_screens/login_screen.dart';
import 'package:newledger/view/view_screens/particular_user_screen.dart';


class CreateUser extends StatefulWidget {
  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController eMailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create Account",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: TextField(
                  controller: nameController,
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
                      )),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: mobileNumberController,
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
                          )),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black45),
                        borderRadius: BorderRadius.circular(5.0),
                      )),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: TextField(
                  controller: eMailController,
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
                      )),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                width: double.infinity,
                child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    height: 50,
                    onPressed: () async {
                      if (nameController.text == null ||
                          nameController.text == "" &&
                              mobileNumberController.text == null ||
                          mobileNumberController.text == "" &&
                              eMailController.text == null ||
                          eMailController.text == "") {
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
                            });
                      } else {
                        print("add button is pressed");

                        Map<String, dynamic> map = {
                          "eMail": eMailController.text,
                          "inCredit": 0,
                          "inDebit": 0,
                          "mobileNumber": mobileNumberController.text,
                          "name": nameController.text
                        };
                        await Firestore.instance
                            .collection("UserAccouts")
                            .doc(google.currentUser.id)
                            .collection("allUsersList")
                            .doc(nameController.text)
                            .setData(map);
                        String name = nameController.text;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ParticularUserScreen(
                                    name: name,
                                  )),
                        );
                        nameController.clear();
                        mobileNumberController.clear();
                        eMailController.clear();
                      }
                    },
                    color: Colors.blue,
                    child: Text("ADD")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
