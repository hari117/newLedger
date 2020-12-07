import 'package:flutter/material.dart';
import 'package:newledger/model/apptheam/leader_theam.dart';
import 'package:newledger/view/view_widgets/text_widget.dart';

class GlobalSnakBar {
  // final String msg;
  //
  // const GlobalSnakBar(@required this.msg);

  static show(BuildContext context, String msg,Color snakColor) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
       // backgroundColor: snakColor,
        content: CustomText(name:msg,textSize: 14,textColor: $appTheam.onWhite_01,textFontWeigth: FontWeight.normal,textLetterSpacing: 1.1,),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
