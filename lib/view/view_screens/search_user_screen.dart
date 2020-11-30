import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newledger/view/view_screens/login_screen.dart';

class SearchUser extends StatefulWidget {
  Function callback;
  SearchUser({this.callback});
  @override
  _SearchUserState createState() => _SearchUserState();


}

class _SearchUserState extends State<SearchUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Choose \nAccout",
          style: GoogleFonts.muli(
              letterSpacing: 1.1,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 18),
        ),
      ),
      body: StreamBuilder(
        stream:Firestore.instance.collection("UserAccouts").doc(google.currentUser.id).collection("allUsersList").snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return Center(
              child: Text("Wait Data is Loading"),
            );
          }
          List<DocumentSnapshot> doc=snap.data.documents;
          return ListView.builder(

              primary: false,
              shrinkWrap: true,

              itemCount: snap.data.documents.length,
              itemBuilder: (context, index) {
                String userName=doc[index]["name"];
                return InkWell(
                  onTap: ()
                  {
                    widget.callback(userName);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 35,
                          height: 70,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(40)),
                          child: Text(
                            "${userName[0]}",
                            style: GoogleFonts.muli(color: Colors.white, fontSize: 22),
                          ),
                        ),
                        SizedBox(
                          width: 9,
                        ),
                        Text(
                          userName,
                          style: GoogleFonts.muli(
                              letterSpacing: 1.1,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                );
                },
          );
        },
      ),
    );
  }
}
