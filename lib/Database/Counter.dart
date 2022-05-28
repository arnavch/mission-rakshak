import 'package:cloud_firestore/cloud_firestore.dart';

class Counter {
  static final CollectionReference counterCollection =
      FirebaseFirestore.instance.collection('counter');

  static addUnverifiedUser() {
    counterCollection.doc('user').update({
      'unverifiedCount': FieldValue.increment(1),
    });
  }

  static deleteUnverifiedUser() {
    counterCollection.doc('user').update({
      'unverifiedCount': FieldValue.increment(-1),
    });
  }

  //--------verified--------------

  static convertToVerifiedUser(String bloodType) {
    counterCollection.doc('user').update({
      'verifiedCount': FieldValue.increment(1),
      bloodType: FieldValue.increment(1),
      'unverifiedCount': FieldValue.increment(-1),
    });
  }

  //---------admin------------

  static addAdminUser() {
    counterCollection.doc('user').update({
      'adminCount': FieldValue.increment(1),
    });
  }
}
