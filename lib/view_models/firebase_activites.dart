import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newledger/view/view_screens/splash_screen.dart';

class FirebaseCenter {
  static CollectionReference userAccountRef =
      Firestore.instance.collection("UserAccouts");
  static CollectionReference allTranscationRef =
      Firestore.instance.collection("Transactions");

  static checkUsersInFireBase(String num) async {
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

  static Future deleteParticularUser(String name) async {
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

  static Future debitAmout(
      String amount, String dateTime, String accountName) async {
    Map<String, dynamic> map = {
      "type": "Debit",
      "amount": amount,
      "date": dateTime
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
    int total = int.parse(amount) + doc["inDebit"];
    Map<String, dynamic> map2 = {"inDebit": total};

    await Firestore.instance
        .collection("UserAccouts")
        .doc(google.currentUser.id)
        .collection("allUsersList")
        .doc(accountName)
        .update(map2);
  }

  static Future creditAmount(
      String amount, String dateTime, String accountName) async {
    Map<String, dynamic> map = {
      "type": "Credit",
      "amount": amount,
      "date": dateTime
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
  }
}
