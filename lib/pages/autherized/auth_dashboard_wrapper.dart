import 'package:flutter/material.dart';

import 'package:mission_rakshak/pages/autherized/auth_QR_scanner.dart';
import 'package:mission_rakshak/pages/autherized/auth_addcenter.dart';
import 'package:mission_rakshak/pages/autherized/auth_dashboard.dart';
import 'package:mission_rakshak/pages/autherized/auth_profile_page.dart';
import 'package:mission_rakshak/pages/autherized/components/auth_bottomnavbar.dart';
import 'package:mission_rakshak/pages/autherized/settings/auth_settings_wrapper.dart';

class AuthDashboardWrapper extends StatefulWidget {
  AuthDashboardWrapper(this.data, this.centerData);
  Map<String, dynamic> data;
  Map<String, dynamic> centerData;
  @override
  _AuthDashboardWrapperState createState() => _AuthDashboardWrapperState();
}

class _AuthDashboardWrapperState extends State<AuthDashboardWrapper> {
  int cIndex = 0;
  changePage(int index) {
    setState(() {
      cIndex = index;
    });
  }

  Widget getpage(int index) {
    if (index == 0) {
      return AuthDashboard();
    }
    // if (index == 1) {
    //   return Auth_AddCenter();
    // }

    if (index == 1) {
      return QRScanner(widget.centerData, widget.data);
    }
    if (index == 2) {
      return AuthProfilePage(
        widget.data,
        widget.centerData,
      );
    }
    if (index == 3) {
      return AuthSettingsWrapper(widget.data);
    }
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
      bottomNavigationBar: AuthBottomNavbar(cIndex, changePage),
    );
  }
}
