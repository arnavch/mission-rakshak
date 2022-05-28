import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class CenterData {
  static final CollectionReference centerDataCollection =
      FirebaseFirestore.instance.collection('bloodDonationCenters');

  static Future<void> createBloodDonationCenter({
    name,
    emailId,
    mobileNumber,
    address,
    latitude,
    longitude,
  }) async {
    await centerDataCollection.doc(name).set({
      'name': name,
      'emailId': emailId,
      'mobileNumber': mobileNumber,
      'address': address,
      'location': new GeoPoint(latitude, longitude)
    });
    await centerDataCollection.doc('index').update({
      'center_location.$name': new GeoPoint(latitude, longitude),
      'centers.$name': address,
    });
  }

  static Future<DocumentSnapshot> getNearestCenter({
    @required latitude,
    @required longitude,
  }) async {
    DocumentSnapshot document =
        await CenterData.centerDataCollection.doc('index').get();
    Map data = document.data();
    Map locations = data['center_location'];
    int smallestD;
    String name;
    int distance;
    locations.forEach((key, value) {
      if (value != null) {
        distance = Geolocator.distanceBetween(
                latitude, longitude, value.latitude, value.longitude)
            .toInt();
        if (smallestD == null || distance < smallestD) {
          smallestD = distance;
          name = key;
        }
      }
    });
    return await CenterData.centerDataCollection.doc(name).get();
  }

  static Future<DocumentSnapshot> getNearestCenterWithDocument({
    @required latitude,
    @required longitude,
    @required index,
  }) async {
    Map locations = index['center_location'];
    int smallestD;
    String name;
    int distance;
    locations.forEach((key, value) {
      if (value != null) {
        distance = Geolocator.distanceBetween(
                latitude, longitude, value.latitude, value.longitude)
            .toInt();
        if (smallestD == null || distance < smallestD) {
          smallestD = distance;
          name = key;
        }
      }
    });
    return await CenterData.centerDataCollection.doc(name).get();
  }
}
