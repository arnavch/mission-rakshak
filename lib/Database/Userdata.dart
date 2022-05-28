import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:mission_rakshak/Database/Counter.dart';
import 'package:mission_rakshak/Database/centerData.dart';

class UserDatabase {
  User user;

  UserDatabase(this.user);

  // collection reference
  static final CollectionReference userDataCollection =
      FirebaseFirestore.instance.collection('UserData');

  static final CollectionReference verifiedUserViewCollection =
      FirebaseFirestore.instance.collection('verifiedUserView');

  static final CollectionReference nonVerifiedUserViewCollection =
      FirebaseFirestore.instance.collection('nonVerifiedUserView');

  static final CollectionReference adminUserView =
      FirebaseFirestore.instance.collection('AdminView');

  Future<void> createUnauthorizedUser() async {
    return await userDataCollection.doc(user.uid).set({
      'donatedBefore': false,
      'authorized': false,
      'emailId': user.email,
      'correctData': false,
      'firstName': '',
      'lastName': '',
      'mobileNumber': '',
      'bloodType': '',
      'DOB': '',
      'gender': '',
      'address': '',
      'location': '',
    });
  }

  Future<void> updateUnauthorizedUserDataFromSignIn({
    @required firstName,
    @required lastName,
    @required mobileNumber,
    @required String bloodType,
    @required gender,
    @required DOB,
    @required address,
    @required latitude,
    @required longitude,
  }) async {
    await userDataCollection.doc(user.uid).set({
      'donatedBefore': false,
      'authorized': false,
      'emailId': user.email,
      'correctData': true,
      'firstName': firstName,
      'lastName': lastName,
      'mobileNumber': mobileNumber,
      'bloodType': bloodType,
      'DOB': DOB,
      'gender': gender,
      'address': address,
      'location': new GeoPoint(latitude, longitude),
    });

    String topic;
    topic = bloodType.substring(0, bloodType.length - 1);

    if (bloodType[bloodType.length - 1] == '+') {
      topic = topic + '_p';
    }
    if (bloodType[bloodType.length - 1] == '-') {
      topic = topic + '_n';
    }

    await FirebaseMessaging.instance.subscribeToTopic(topic);

    await nonVerifiedUserViewCollection.doc(bloodType).update({
      'users': FieldValue.arrayUnion([
        {
          'firstName': firstName,
          'lastName': lastName,
          'emailId': user.email,
          'mobileNumber': mobileNumber,
          'DOB': DOB,
          'docId': user.uid,
        }
      ])
    });

    await Counter.addUnverifiedUser();

    return true;
  }

  Future<void> updateUnauthorizedUserDataFromProfilePage({
    @required firstName,
    @required lastName,
    @required mobileNumber,
    @required address,
    @required latitude,
    @required longitude,
    @required oldFirstName,
    @required oldLastName,
    @required oldMobileNumber,
    @required DOB,
    @required bloodType,
  }) async {
    await nonVerifiedUserViewCollection.doc(bloodType).update({
      'users': FieldValue.arrayRemove([
        {
          'firstName': oldFirstName,
          'lastName': oldLastName,
          'emailId': user.email,
          'mobileNumber': oldMobileNumber,
          'DOB': DOB,
          'docId': user.uid,
        }
      ]),
    });

    await nonVerifiedUserViewCollection.doc(bloodType).update({
      'users': FieldValue.arrayUnion([
        {
          'firstName': firstName,
          'lastName': lastName,
          'emailId': user.email,
          'mobileNumber': mobileNumber,
          'DOB': DOB,
          'docId': user.uid,
        }
      ]),
    });

    await userDataCollection.doc(user.uid).update({
      // 'correctData': true,
      'firstName': firstName,
      'lastName': lastName,
      // 'emailId': user.email,
      'mobileNumber': mobileNumber,
      // 'bloodType': bloodType,
      // 'DOB': null,
      // 'gender': gender,
      'address': address,
      // 'donatedBefore': false,
      'location': new GeoPoint(latitude, longitude),
    });
    return true;
  }

  // VERIFIED USERS

  Future<void> updateVerifiedUserDataFromProfilePage({
    @required mobileNumber,
    @required oldMobileNumber,
    @required address,
    @required firstName,
    @required lastName,
    @required latitude,
    @required longitude,
    @required DOB,
    bloodType,
  }) async {
    await verifiedUserViewCollection
        .doc(bloodType)
        .collection('verifiedView')
        .doc(user.uid)
        .update({
      'firstName': firstName,
      'lastName': lastName,
      'mobileNumber': mobileNumber,
    });

    // await verifiedUserViewCollection.doc(bloodType).update({
    //   'users': FieldValue.arrayRemove([
    //     {
    //       'firstName': firstName,
    //       'lastName': lastName,
    //       'emailId': user.email,
    //       'mobileNumber': oldMobileNumber,
    //       'DOB': DOB,
    //       'docId': user.uid,
    //     }
    //   ]),
    // });

    // await verifiedUserViewCollection.doc(bloodType).update({
    //   'users': FieldValue.arrayUnion([
    //     {
    //       'firstName': firstName,
    //       'lastName': lastName,
    //       'emailId': user.email,
    //       'mobileNumber': mobileNumber,
    //       'DOB': DOB,
    //       'docId': user.uid,
    //     }
    //   ]),
    // });

    await userDataCollection.doc(user.uid).update({
      // 'correctData': true,
      // 'firstName': firstName,
      // 'lastName': lastName,
      // 'emailId': user.email,
      'mobileNumber': mobileNumber,
      // 'bloodType': bloodType,
      // 'DOB': null,
      // 'gender': gender,
      'address': address,
      // 'donatedBefore': false,
      'location': new GeoPoint(latitude, longitude),
    });

    return true;
  }

  static Future<bool> makeUserVerified({
    @required firstName,
    @required lastName,
    @required mobileNumber,
    @required DOB,
    @required bloodType,
    @required uid,
    @required email,
  }) async {
    await nonVerifiedUserViewCollection.doc(bloodType).update({
      'users': FieldValue.arrayRemove([
        {
          'firstName': firstName,
          'lastName': lastName,
          'emailId': email,
          'mobileNumber': mobileNumber,
          'DOB': DOB,
          'docId': uid,
          'donations': 0,
        }
      ]),
    });

    await verifiedUserViewCollection
        .doc(bloodType)
        .collection('verifiedView')
        .doc(uid)
        .set({
      'firstName': firstName,
      'lastName': lastName,
      'emailId': email,
      'mobileNumber': mobileNumber,
      'DOB': DOB,
      'docId': uid,
      'donations': 0,
    });

    await userDataCollection.doc(uid).update({
      'donatedBefore': true,
      'donations': 0,
    });

    await Counter.convertToVerifiedUser(bloodType);

    return true;
  }

  //AUTHORIZED USERS--------------------------------------------------------
  Future<void> createAuthorizedUser() async {
    return await userDataCollection.doc(user.uid).set({
      'correctData': false,
      'firstName': '',
      'lastName': '',
      'emailId': user.email,
      'mobileNumber': '',
      'authorized': true,
      'centerName': '',
      'authLevel': 2,
    });
  }

  Future<void> updateAuthorizedUserDataFromSignIn(
      {@required firstName,
      @required lastName,
      @required mobileNumber,
      @required centerName}) async {
    await userDataCollection.doc(user.uid).update({
      'correctData': true,
      'firstName': firstName,
      'lastName': lastName,
      'emailId': user.email,
      'mobileNumber': mobileNumber,
      'authorized': true,
      'centerName': centerName,
    });

    await adminUserView.doc('adminIndex').update({
      'users': FieldValue.arrayUnion([
        {
          'firstName': firstName,
          'lastName': lastName,
          'emailId': user.email,
          'mobileNumber': mobileNumber,
          'centerName': centerName,
          'docId': user.uid,
          'authLevel': 2,
        }
      ])
    });

    await CenterData.centerDataCollection.doc(centerName).update({
      'adminUsers': FieldValue.arrayUnion([
        user.uid,
      ]),
    });

    await Counter.addAdminUser();
  }

  Future<bool> updateAuthorizedUserDataFromProfilePage({
    @required mobileNumber,
    @required centerName,
    @required oldMobileNumber,
    @required oldCenterName,
    @required firstName,
    @required lastName,
  }) async {
    await userDataCollection.doc(user.uid).update({
      'mobileNumber': mobileNumber,
      'centerName': centerName,
    });

    await adminUserView.doc('adminIndex').update({
      'users': FieldValue.arrayRemove([
        {
          'firstName': firstName,
          'lastName': lastName,
          'emailId': user.email,
          'mobileNumber': oldMobileNumber,
          'centerName': oldCenterName,
          'docId': user.uid,
          'authLevel': 2,
        }
      ])
    });

    await adminUserView.doc('adminIndex').update({
      'users': FieldValue.arrayUnion([
        {
          'firstName': firstName,
          'lastName': lastName,
          'emailId': user.email,
          'mobileNumber': mobileNumber,
          'centerName': centerName,
          'docId': user.uid,
          'authLevel': 2,
        }
      ])
    });

    await CenterData.centerDataCollection.doc(oldCenterName).update({
      'adminUsers': FieldValue.arrayRemove([
        user.uid,
      ]),
    });

    await CenterData.centerDataCollection.doc(centerName).update({
      'adminUsers': FieldValue.arrayUnion([
        user.uid,
      ]),
    });

    return true;
  }

  //DELETE USER

  Future<bool> deleteUser(Map userData) async {
    bool isVerified = userData['donatedBefore'];
    String firstName = userData['firstName'];
    String lastName = userData['lastName'];
    String mobileNumber = userData['mobileNumber'];
    String email = userData['emailId'];
    String bloodType = userData['bloodType'];

    if (!isVerified) {
      await nonVerifiedUserViewCollection.doc(bloodType).update({
        'users': FieldValue.arrayRemove([
          {
            'firstName': firstName,
            'lastName': lastName,
            'emailId': email,
            'mobileNumber': mobileNumber,
            'DOB': userData['DOB'],
            'docId': user.uid,
          }
        ]),
      });

      await Counter.deleteUnverifiedUser();

      await userDataCollection.doc(user.uid).delete();
    }

    return true;
  }

  //Worker USERS--------------------------------------------------------
  Future<void> createWorkerUser() async {
    return await userDataCollection.doc(user.uid).set({
      'correctData': false,
      'firstName': '',
      'lastName': '',
      'emailId': user.email,
      'mobileNumber': '',
      'authorized': true,
      'centerName': '',
      'authLevel': 1,
    });
  }

  Future<void> updateWorkerUserDataFromSignIn({
    @required firstName,
    @required lastName,
    @required mobileNumber,
    @required centerName,
  }) async {
    await userDataCollection.doc(user.uid).update({
      'correctData': true,
      'firstName': firstName,
      'lastName': lastName,
      'emailId': user.email,
      'mobileNumber': mobileNumber,
      'authorized': true,
      'centerName': centerName,
    });

    await adminUserView.doc('adminIndex').update({
      'users': FieldValue.arrayUnion([
        {
          'firstName': firstName,
          'lastName': lastName,
          'emailId': user.email,
          'mobileNumber': mobileNumber,
          'centerName': centerName,
          'docId': user.uid,
          'authLevel': 1,
        }
      ])
    });

    await CenterData.centerDataCollection.doc(centerName).update({
      'adminUsers': FieldValue.arrayUnion([
        user.uid,
      ]),
    });

    await Counter.addAdminUser();
  }

  Future<bool> updateWorkerUserDataFromProfilePage({
    @required mobileNumber,
    @required oldMobileNumber,
    @required firstName,
    @required lastName,
    @required centerName,
    @required oldCenterName,
  }) async {
    await userDataCollection.doc(user.uid).update({
      'mobileNumber': mobileNumber,
      'centerName': centerName,
    });

    await adminUserView.doc('adminIndex').update({
      'users': FieldValue.arrayRemove([
        {
          'firstName': firstName,
          'lastName': lastName,
          'emailId': user.email,
          'mobileNumber': oldMobileNumber,
          'centerName': oldCenterName,
          'docId': user.uid,
          'authLevel': 1,
        }
      ])
    });

    await adminUserView.doc('adminIndex').update({
      'users': FieldValue.arrayUnion([
        {
          'firstName': firstName,
          'lastName': lastName,
          'emailId': user.email,
          'mobileNumber': mobileNumber,
          'centerName': centerName,
          'docId': user.uid,
          'authLevel': 1,
        }
      ])
    });

    await CenterData.centerDataCollection.doc(oldCenterName).update({
      'adminUsers': FieldValue.arrayRemove([
        user.uid,
      ]),
    });

    await CenterData.centerDataCollection.doc(centerName).update({
      'adminUsers': FieldValue.arrayUnion([
        user.uid,
      ]),
    });

    return true;
  }
}

class DonationHistoryData {
  static final CollectionReference donationHistoryCollection =
      FirebaseFirestore.instance.collection('donationHistory');

  static Future<bool> createDonationLog({
    @required name,
    @required bloodType,
    @required centerName,
    @required userId,
  }) async {
    Timestamp date = Timestamp.now();
    DateTime datetime =
        DateTime.fromMillisecondsSinceEpoch(date.seconds * 1000);
    String dateString = '${datetime.month}_${datetime.year}';
    await donationHistoryCollection.doc(dateString).set(
        {
          'history': FieldValue.arrayUnion([
            {
              'bloodType': bloodType,
              'name': name,
              'centerName': centerName,
              'timeStamp': Timestamp.now(),
              'userId': userId,
            }
          ]),
        },
        SetOptions(
          merge: true,
        ));

    await UserDatabase.userDataCollection.doc(userId).update({
      'previousDonations': FieldValue.arrayUnion([
        {
          'centerName': centerName,
          'timeStamp': Timestamp.now(),
        }
      ]),
      'donations': FieldValue.increment(1),
    });

    await UserDatabase.verifiedUserViewCollection
        .doc(bloodType)
        .collection('verifiedView')
        .doc(userId)
        .update({
      'donations': FieldValue.increment(1),
    });

    await donationHistoryCollection.doc('entryList').update({
      'entries': FieldValue.arrayUnion([dateString])
    });

    return true;
  }

  //TODO: check if this function works

  static Future<void> deleteDonationLog({
    @required name,
    @required bloodType,
    @required centerName,
    @required userId,
    @required timeStampOfEntry,
  }) async {
    Timestamp date = Timestamp.now();
    DateTime datetime =
        DateTime.fromMillisecondsSinceEpoch(date.seconds * 1000);
    String dateString = '${datetime.month}_${datetime.year}';
    await donationHistoryCollection.doc(dateString).update({
      'history': FieldValue.arrayRemove([
        {
          //need all feild of map to delete successfully
          'bloodType': bloodType,
          'name': name,
          'centerName': centerName,
          'timeStamp': timeStampOfEntry,
          'userId': userId,
        }
      ]),
    });
  }
}
