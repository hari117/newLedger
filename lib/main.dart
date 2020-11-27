import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newledger/globalState.dart';
import 'package:newledger/login_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(LedgerTask());
}

class LedgerTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider<GlobalState>(
       create: (context) =>GlobalState(),
        child: LoginScreen(),

      ),
    );
  }
}
