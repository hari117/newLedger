import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:newledger/view/view_screens/login_screen.dart';

class FirebaseCenter {
  static CollectionReference userAccountRef =
      Firestore.instance.collection("UserAccouts");
  static CollectionReference allTranscationRef =
      Firestore.instance.collection("Transactions");

  checkUsersInFireBase(String num) async {
    DocumentSnapshot doc = await userAccountRef.document(num).get();
    if (!doc.exists) {
      Map<String, dynamic> map = {
        "name": google.currentUser.displayName,
        "id": google.currentUser.id,
        "email": google.currentUser.email,
        "photoUrl": google.currentUser.photoUrl,
      };
      await userAccountRef.doc(num).setData(map);
    }
  }

  static addParticularUser(String email, int credit, int debit,
      String mobileNumber, String name) async {
    Map<String, dynamic> map = {
      "eMail": email,
      "inCredit": credit,
      "inDebit": debit,
      "mobileNumber": mobileNumber,
      "name": name
    };
    await Firestore.instance
        .collection("UserAccouts")
        .doc(google.currentUser.id)
        .collection("allUsersList")
        .doc(name)
        .setData(map);
  }

  Future deleteParticularUser(String name) async {
    await Firestore.instance
        .collection("UserAccouts")
        .doc(google.currentUser.id)
        .collection("allUsersList")
        .doc(name)
        .delete();

    QuerySnapshot qc = await allTranscationRef
        .doc(google.currentUser.id)
        .collection(name)
        .getDocuments();
    List<DocumentSnapshot> dc = qc.docs;
    for (DocumentSnapshot d in dc) {
      if (d.exists) {
        await Firestore.instance
            .collection("UserAccouts")
            .doc(google.currentUser.id)
            .collection("allUsersList")
            .doc(google.currentUser.id)
            .collection(name)
            .doc(d.id)
            .delete();
      }
    }
  }

  Future UpdateRecord(DocumentSnapshot doc, String amount, String amontType,
      String accountName, DateTime dateTime, String note) async {
    String tempNote = note == "" ? "".toString() : note;
    Map<String, dynamic> map = {
      "type": amontType,
      "amount": amount,
      "date": Timestamp.fromDate(dateTime),
      "note": tempNote,
    };

    await allTranscationRef
        .doc(google.currentUser.id)
        .collection(accountName)
        .document(doc.id)
        .update(map);
    commonFuntion(accountName);
  }

  Future putAmount(String amount, DateTime dateTime, String accountName,
      String note, String amountType) async {
    String tempNote = note == "" ? "".toString() : note;
    Map<String, dynamic> map = {
      "type": amountType,
      "amount": amount,
      "date": Timestamp.fromDate(dateTime),
      "note": tempNote,
    };

    await allTranscationRef
        .doc(google.currentUser.id)
        .collection(accountName)
        .doc()
        .setData(map);

    DocumentSnapshot doc = await Firestore.instance
        .collection("UserAccouts")
        .doc(google.currentUser.id)
        .collection("allUsersList")
        .doc(accountName)
        .get();
    int total = int.parse(amount) + doc["inCredit"];
    Map<String, dynamic> map2 = {"inCredit": total};

    await Firestore.instance
        .collection("UserAccouts")
        .doc(google.currentUser.id)
        .collection("allUsersList")
        .doc(accountName)
        .update(map2);

    commonFuntion(accountName);
  }

  deleteParticularTranscationList(DocumentSnapshot doc, String name) async {
    DocumentSnapshot userDoc = await Firestore.instance
        .collection("UserAccouts")
        .doc(google.currentUser.id)
        .collection("allUsersList")
        .doc(name)
        .get();
    DocumentSnapshot transcationDoc = await Firestore.instance
        .collection("Transactions")
        .doc(google.currentUser.id)
        .collection(name)
        .doc(doc.id)
        .get();

    if (doc.exists) {
      print("document is in firebase");
      print(doc.id);
      if ("Credit" == doc["type"]) {
        print("this is credit transcation");
        int a = int.parse(doc["amount"]);
        int b = userDoc["inCredit"];
        int c = b - a;
        Map<String, int> map = {"inCredit": c};
        await Firestore.instance
            .collection("UserAccouts")
            .doc(google.currentUser.id)
            .collection("allUsersList")
            .doc(name)
            .update(map);
        await Firestore.instance
            .collection("Transactions")
            .doc(google.currentUser.id)
            .collection(name)
            .doc(doc.id)
            .delete();
      } else {
        int a = int.parse(doc["amount"]);
        int b = userDoc["inDebit"];
        int c = b - a;
        Map<String, int> map = {"inDebit": c};
        await Firestore.instance
            .collection("UserAccouts")
            .doc(google.currentUser.id)
            .collection("allUsersList")
            .doc(name)
            .update(map);
        await Firestore.instance
            .collection("Transactions")
            .doc(google.currentUser.id)
            .collection(name)
            .doc(doc.id)
            .delete();
      }
    }
  }

  commonFuntion(String accountName) async {
    int totalCredit = 0;
    int totalDebit = 0;
    QuerySnapshot qc = await allTranscationRef
        .doc(google.currentUser.id)
        .collection(accountName)
        .getDocuments();
    print("********************** Entered commonFuntion");
    List<DocumentSnapshot> dc = qc.docs;

    for (DocumentSnapshot d in dc) {
      if ("Credit" == d["type"]) {
        totalCredit = totalCredit + int.parse(d["amount"]);
      } else {
        totalDebit = totalDebit + int.parse(d["amount"]);
      }
    }

    print("******$totalDebit******");
    print("******$totalCredit******");

    DocumentSnapshot doc = await Firestore.instance
        .collection("UserAccouts")
        .doc(google.currentUser.id)
        .collection("allUsersList")
        .doc(accountName)
        .get();
    Map<String, dynamic> map2 = {
      "inDebit": totalDebit,
      "inCredit": totalCredit
    };

    await Firestore.instance
        .collection("UserAccouts")
        .doc(google.currentUser.id)
        .collection("allUsersList")
        .doc(accountName)
        .update(map2);

    totalCredit = 0;
    totalCredit = 0;
  }
}

final $fireBase = FirebaseCenter();
