import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newledger/model/apptheam/leader_theam.dart';
import 'package:newledger/model/globalState.dart';
import 'package:newledger/view/view_screens/newhome_screen.dart';
import 'package:newledger/view/view_screens/login_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(LedgerTask());
}

class LedgerTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GlobalState>(
      create: (context) => GlobalState(),
      child: MaterialApp(
        theme: ThemeData(
            appBarTheme: AppBarTheme(
                iconTheme: IconThemeData(color: $appTheam.onWhite_01)),
            iconTheme: IconThemeData(color: Colors.red, opacity: 1)),
        home: ChangeNotifierProvider<GlobalState>(
          create: (context) => GlobalState(),
          child: LoginScreen(),
        ),
      ),
    );

/*    return MaterialApp(
      theme: ThemeData(
          appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(color: $appTheam.onWhite_01)),
          iconTheme: IconThemeData(color: Colors.red, opacity: 1)),
      home: ChangeNotifierProvider<GlobalState>(
        create: (context) => GlobalState(),
        child: LoginScreen(),
      ),
    );*/
  }
}
