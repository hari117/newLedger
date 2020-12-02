

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextWidget extends StatefulWidget {
  @override
  _CustomTextWidgetState createState() => _CustomTextWidgetState();
}

class _CustomTextWidgetState extends State<CustomTextWidget> {
  String type="roboto";
  @override
  Widget build(BuildContext context) {
    return Text("CustomText",style: GoogleFonts.roboto(),);
  }
}
