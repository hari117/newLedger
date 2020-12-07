import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatefulWidget {
  String name;
  Color textColor;
  double textSize;
  double textLetterSpacing;
  FontWeight textFontWeigth;
  FontStyle textFontStyle;

  @override
  _CustomTextState createState() => _CustomTextState();

  CustomText({@required this.name, this.textColor, this.textSize,
      this.textLetterSpacing, this.textFontWeigth,this.textFontStyle});
}

class _CustomTextState extends State<CustomText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.name,
      style: GoogleFonts.roboto(
        color: widget.textColor,
        fontSize: widget.textSize,
        letterSpacing: widget.textLetterSpacing,
        fontWeight: widget.textFontWeigth,
          fontStyle: widget.textFontStyle,
      ),
    );
  }
}
