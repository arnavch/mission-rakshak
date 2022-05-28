import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mission_rakshak/Database/requestData.dart';
import 'package:mission_rakshak/components/bottom_navbar.dart';
import 'package:mission_rakshak/pages/blood_donation_page.dart';
import 'package:mission_rakshak/pages/dashboard_screen.dart';
import 'package:mission_rakshak/pages/locations_page.dart';
import 'package:mission_rakshak/pages/settings/settings_wrapper.dart';

import 'dashboard_screen.dart';
import 'profile_page.dart';

class DashboardWrapper extends StatefulWidget {
  DashboardWrapper(this.data, this.centerData);
  Map<String, dynamic> data;
  Map<String, dynamic> centerData;

  @override
  _DashboardWrapperState createState() => _DashboardWrapperState();
}

class _DashboardWrapperState extends State<DashboardWrapper> {
  int cIndex = 0;
  changePage(int index) {
    setState(() {
      cIndex = index;
    });
  }

  Map nearestCenterData;
  dynamic nearestRequestData;

  setNearestCenterData(value) {
    nearestCenterData = value;
  }

  setNearestRequestData(value) {
    nearestRequestData = value;
  }

  Widget getpage(int index) {
    if (index == 0) {
      return DashboardPage(
        data: widget.data,
        centerData: widget.centerData,
        setNearestCenterFunc: setNearestCenterData,
        nearestCenterData: nearestCenterData,
        nearestRequest: nearestRequest,
      );
    }
    if (index == 1) {
      return LocationListPage(widget.data, widget.centerData);
    }
    if (index == 2) {
      return ProfilePage(widget.data);
    }
    if (index == 3) {
      return BloodDonationPage();
    }

    if (index == 4) {
      return SettingsWrapper(widget.data);
    }
  }

  Future<List> nearestRequest;

  @override
  void initState() {
    String bloodType = widget.data['bloodType'];
    String topic;
    topic = bloodType.substring(0, bloodType.length - 1);

    if (bloodType[bloodType.length - 1] == '+') {
      topic = topic + '_p';
    }
    if (bloodType[bloodType.length - 1] == '-') {
      topic = topic + '_n';
    }

    FirebaseMessaging.instance.subscribeToTopic(topic);

    nearestRequest = RequestData.getNearestRequest(
      latitude: widget.data['location'].latitude,
      longitude: widget.data['location'].longitude,
      bloodType: widget.data['bloodType'].toString().toUpperCase(),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: cIndex == 3
      //     ? AppBar(
      //         backgroundColor: red,
      //         // centerTitle: true,
      //         elevation: 0,
      //         title: Text('Settings', style: appBarTextStyle),
      //       )
      //     : null,
      body: getpage(cIndex),
      bottomNavigationBar: BottomNavBar(cIndex, changePage),
    );
  }
}
