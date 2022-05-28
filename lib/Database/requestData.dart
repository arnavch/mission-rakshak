import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mission_rakshak/Database/centerData.dart';

class RequestData {
  static final CollectionReference bloodRequestCollection =
      FirebaseFirestore.instance.collection('bloodRequests');

  static Future<void> createBloodDonationRequest({
    name,
    geoPoint,
    bloodType,
    address,
  }) async {
    await bloodRequestCollection.doc(bloodType).update({
      'requests.$name': [geoPoint, address, name],
    });

    List requestData = [name, bloodType, Timestamp.now()];
    await bloodRequestCollection.doc('requestView').update({
      'allRequests.${name}_$bloodType': requestData,
    });
  }

  static Future<void> deleteBloodDonationRequest({
    name,
    bloodType,
  }) async {
    await bloodRequestCollection.doc(bloodType).update({
      'requests.$name': FieldValue.delete(),
    });

    await bloodRequestCollection.doc('requestView').update({
      'allRequests.${name}_$bloodType': FieldValue.delete(),
    });
  }

  static Map getShortestDistance({
    @required List centerData,
    @required latitude,
    @required longitude,
  }) {
    int smallestD;
    String name;
    int distance;
    int priority;

    centerData.forEach((value) {
      distance = Geolocator.distanceBetween(
              latitude, longitude, value[0].latitude, value[0].longitude)
          .toInt();
      if (smallestD == null || distance < smallestD) {
        smallestD = distance;
        name = value[2];
        priority = value[3];
      }
    });

    return {
      'name': name,
      'distance': smallestD,
      'priority': priority,
    };
  }

  static Future<List> getNearestRequest({
    @required latitude,
    @required longitude,
    @required bloodType,
  }) async {
    print(bloodType);
    DocumentSnapshot document =
        await RequestData.bloodRequestCollection.doc(bloodType).get();
    Map data = document.data();
    Map requests = data['requests'];
    print(requests);
    // String keyVal;
    if (requests.length == 0) {
      return [
        await CenterData.centerDataCollection
            .doc('thisWillNotExistCuzWhatsTheProbablity')
            .get()
      ];
    }
    // if (requests.length == 1) {
    //   requests.forEach((key, value) async {
    //     keyVal = key.toString();
    //   });
    //   return await CenterData.centerDataCollection.doc(keyVal).get();
    // }

    if (false) {
    } else {
      List urgentRequestList = [];
      List emergencyRequestList = [];
      List normalRequestList = [];

      requests.forEach((key, value) async {
        if (value[3] == 0) {
          emergencyRequestList.add(value);
        } else if (value[3] == 1) {
          urgentRequestList.add(value);
        } else if (value[3] == 2) {
          normalRequestList.add(value);
        }
      });

      Map emergencyRequest;
      Map urgentRequest;
      Map normalRequest;

      print(emergencyRequestList);
      print(urgentRequestList);
      print(normalRequestList);

      if (emergencyRequestList != null &&
          emergencyRequestList.isEmpty != true) {
        emergencyRequest = getShortestDistance(
            centerData: emergencyRequestList,
            latitude: latitude,
            longitude: longitude);
      }
      if (urgentRequestList != null && urgentRequestList.isEmpty != true) {
        urgentRequest = getShortestDistance(
            centerData: urgentRequestList,
            latitude: latitude,
            longitude: longitude);
      } else if ((emergencyRequestList == null ||
              emergencyRequestList.isEmpty == true) &&
          normalRequestList != null &&
          normalRequestList.isEmpty != true) {
        normalRequest = getShortestDistance(
            centerData: normalRequestList,
            latitude: latitude,
            longitude: longitude);
      }

      List requestList = [];

      print(emergencyRequest);
      print(urgentRequest);
      print(normalRequest);

      if (emergencyRequest != null) {
        requestList.add([
          await CenterData.centerDataCollection
              .doc(emergencyRequest['name'])
              .get(),
          0
        ]);
      }
      if (urgentRequest != null) {
        requestList.add([
          await CenterData.centerDataCollection
              .doc(urgentRequest['name'])
              .get(),
          1
        ]);
      }
      if (normalRequest != null) {
        requestList.add([
          await CenterData.centerDataCollection
              .doc(normalRequest['name'])
              .get(),
          2
        ]);
      }

      print(requestList);

      return requestList;

      // int smallestD;
      // String name;
      // int distance;
      // requests.forEach((key, value) {
      //   if (value != null) {
      //     distance = Geolocator.distanceBetween(
      //             latitude, longitude, value[0].latitude, value[0].longitude)
      //         .toInt();
      //     if (smallestD == null || distance < smallestD) {
      //       smallestD = distance;
      //       name = key.toString();
      //     }
      //   }
      // });
    }
  }
}

// print('here at request e');
//
// int smallestD;
// String name;
// int distance;
// int priority;
//
// // emergencyRequestList.map((value) {
// //   name = 'vashi';
// //
// // });

// emergencyRequestList.forEach((value) {
// distance = Geolocator.distanceBetween(
// latitude, longitude, value[0].latitude, value[0].longitude)
//     .toInt();
// if (smallestD == null || distance < smallestD) {
// smallestD = distance;
// name = value[2];
// priority = value[3];
// }
// });
//
// print(name);
// emergencyRequest = {
// 'name': name,
// 'distance': smallestD,
// 'priority': priority,
// };

// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import 'package:flutter/cupertino.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:mission_rakshak/Database/centerData.dart';
//
// class RequestData {
//   static final CollectionReference bloodRequestCollection =
//       FirebaseFirestore.instance.collection('bloodRequests');
//
//   static Future<void> createBloodDonationRequest({
//     name,
//     geoPoint,
//     bloodType,
//     address,
//   }) async {
//     await bloodRequestCollection.doc(bloodType).update({
//       'requests.$name': [geoPoint, address, name],
//     });
//
//     List requestData = [name, bloodType, Timestamp.now()];
//     await bloodRequestCollection.doc('requestView').update({
//       'allRequests.${name}_$bloodType': requestData,
//     });
//   }
//
//   static Future<void> deleteBloodDonationRequest({
//     name,
//     bloodType,
//   }) async {
//     await bloodRequestCollection.doc(bloodType).update({
//       'requests.$name': FieldValue.delete(),
//     });
//
//     await bloodRequestCollection.doc('requestView').update({
//       'allRequests.${name}_$bloodType': FieldValue.delete(),
//     });
//   }
//
//   static Map getShortestDistance({
//     @required List centerData,
//     @required latitude,
//     @required longitude,
//   }) {
//     int smallestD;
//     String name;
//     int distance;
//     int priority;
//
//     centerData.map((value) {
//       if (value != null) {
//         distance = Geolocator.distanceBetween(
//                 latitude, longitude, value[0].latitude, value[0].longitude)
//             .toInt();
//         if (smallestD == null || distance < smallestD) {
//           smallestD = distance;
//           name = value[2];
//           priority = value[3];
//         }
//       }
//     });
//
//     return {
//       'name': name,
//       'distance': smallestD,
//       'priority': priority,
//     };
//   }
//
//   static Future<List> getRequestCenters({
//     @required latitude,
//     @required longitude,
//     @required bloodType,
//   }) async {
//     print(bloodType);
//     DocumentSnapshot document =
//         await RequestData.bloodRequestCollection.doc(bloodType).get();
//     Map data = document.data();
//     Map requests = data['requests'];
//     String keyVal;
//     if (requests.length == 0) {
//       return [
//         await CenterData.centerDataCollection
//             .doc('thisWillNotExistCuzWhatsTheProbablity')
//             .get()
//       ];
//     }
//     if (requests.length == 1) {
//       requests.forEach((key, value) async {
//         keyVal = key.toString();
//       });
//       return [await CenterData.centerDataCollection.doc(keyVal).get()];
//     } else {
//       List urgentRequestList = [];
//       List emergencyRequestList = [];
//       List normalRequestList = [];
//
//       requests.forEach((key, value) async {
//         if (value[3] == 2) {
//           emergencyRequestList.add(value);
//         } else if (value[3] == 1) {
//           urgentRequestList.add(value);
//         } else if (value[3] == 0) {
//           normalRequestList.add(value);
//         }
//       });
//
//       Map emergencyRequest;
//       Map urgentRequest;
//       Map normalRequest;
//
//       if (emergencyRequestList.isEmpty != true ||
//           emergencyRequestList != null) {
//         emergencyRequest = getShortestDistance(
//             centerData: emergencyRequestList,
//             latitude: latitude,
//             longitude: longitude);
//       }
//       if (urgentRequestList.isEmpty != true || urgentRequestList != null) {
//         urgentRequest = getShortestDistance(
//             centerData: urgentRequestList,
//             latitude: latitude,
//             longitude: longitude);
//       }
//       if (normalRequestList.isEmpty != true || normalRequestList != null) {
//         normalRequest = getShortestDistance(
//             centerData: normalRequestList,
//             latitude: latitude,
//             longitude: longitude);
//       }
//       List requestList = [];
//
//       if (emergencyRequest != null) {
//         if (urgentRequest != null) {
//           if (emergencyRequest['distance'] < urgentRequest['distance']) {
//             urgentRequest = null;
//           }
//         }
//         if (normalRequest != null) {
//           if (emergencyRequest['distance'] < normalRequest['distance']) {
//             normalRequest = null;
//           }
//         }
//       }
//
//       if (urgentRequest != null) {
//         if (normalRequest != null) {
//           if (urgentRequest['distance'] < normalRequest['distance']) {
//             normalRequest = null;
//           }
//         }
//       }
//
//       if (emergencyRequest != null) {
//         requestList.add(await CenterData.centerDataCollection
//             .doc(emergencyRequest['name'])
//             .get());
//       }
//       if (urgentRequest != null) {
//         requestList.add(await CenterData.centerDataCollection
//             .doc(urgentRequest['name'])
//             .get());
//       }
//       if (normalRequest != null) {
//         requestList.add(await CenterData.centerDataCollection
//             .doc(normalRequest['name'])
//             .get());
//       }
//
//       return requestList;
//     }
//   }
// }
