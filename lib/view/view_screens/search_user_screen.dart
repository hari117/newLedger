import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newledger/model/apptheam/leader_theam.dart';
import 'package:newledger/view/view_screens/login_screen.dart';
import 'package:newledger/view/view_widgets/text_widget.dart';
import 'package:newledger/view_models/helper_files.dart';

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
      backgroundColor: Colors.white,
      appBar: searchUserAppBar(),
      body: listOfUsers(),
    );
  }

  searchUserAppBar() {
    return AppBar(
      elevation:1,
      backgroundColor: Colors.white,
      title: CustomText(
        name: "Choose Account",
        textLetterSpacing: 1.1,
        textFontWeigth: FontWeight.normal,
        textColor: $appTheam.primaryColor_02,
      ),
      leading: IconButton(
        onPressed: ()
        {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back,color: $appTheam.primaryColor_01,),
      ),
    );
  }

  listOfUsers() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("UserAccouts")
          .doc(google.currentUser.id)
          .collection("allUsersList")
          .snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return Center(
            child:CustomText(
              name: "Wait Data is Loading",
              textLetterSpacing: 1.3,
              textColor: $appTheam.onWhite_01,
              textSize: 22,
            ),

          );
        }
        List<DocumentSnapshot> doc = snap.data.documents;
        return ListView.builder(
          primary: false,
          shrinkWrap: true,
          itemCount: snap.data.documents.length,
          itemBuilder: (context, index) {
            String userName = doc[index]["name"];
            return InkWell(
              onTap: () {
                widget.callback(userName);
                Navigator.pop(context);
              },
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 3,
                      color: $appTheam.primaryColor_02.withOpacity(.5),
                      offset: Offset(
                        3.0, // Move to right 10  horizontally
                        3.0, // Move to bottom 10 Vertically
                      ),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        $helperFile.W20(),
                        Container(
                          width: 45,
                          height: 45,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: $appTheam.primaryColor_02,
                            shape: BoxShape.circle,
                          ),
                          child: CustomText(
                            name: "${userName[0].toUpperCase()}",
                            textLetterSpacing: 1.3,
                            textColor: $appTheam.onWhite_01,
                            textSize: 22,
                          ),

                        ),
                        $helperFile.W20(),
                        CustomText(
                          name: userName,
                          textLetterSpacing: 1.3,
                          textColor: $appTheam.primaryColor_02,
                          textSize: 17,
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
    );
  }
}
