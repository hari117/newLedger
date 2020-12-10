import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:newledger/model/apptheam/leader_theam.dart';

class CustomLoadingWidget extends StatefulWidget {
  @override
  _CustomLoadingWidgetState createState() => _CustomLoadingWidgetState();
}

class _CustomLoadingWidgetState extends State<CustomLoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return LoadingIndicator(
      indicatorType: Indicator.ballClipRotatePulse,
      color:$appTheam.primaryColor_02,
    );
  }
}
