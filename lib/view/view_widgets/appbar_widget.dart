import 'package:flutter/material.dart';
import 'package:newledger/model/apptheam/leader_theam.dart';
import 'package:newledger/view/view_widgets/text_widget.dart';

class CustomAppBar extends StatefulWidget {

  String userName;
  Color appbarColor;


  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  CustomAppBar(this.userName, this.appbarColor);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: widget.appbarColor,
      title: CustomText(name:widget.userName,textColor: $appTheam.onWhite_01,),

    );
  }
}
