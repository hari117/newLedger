


import 'package:flutter/material.dart';

class GlobalState extends ChangeNotifier
{


  bool isAuth=false;


   setBool(bool value)
   {
     isAuth=value;
     notifyListeners();
   }

}