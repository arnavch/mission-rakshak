import 'package:flutter/material.dart';
import 'package:mission_rakshak/pages/Worker/auth_QR_scanner.dart';
import 'package:mission_rakshak/pages/Worker/auth_profile_page.dart';
import 'package:mission_rakshak/pages/autherized/components/auth_bottomnavbar.dart';
import 'package:mission_rakshak/pages/Worker/settings/auth_settings_wrapper.dart';

class WorkerAuthDashboardWrapper extends StatefulWidget {
  WorkerAuthDashboardWrapper(this.data, this.centerData);
  Map<String, dynamic> data;
  Map<String, dynamic> centerData;
  @override
  _WorkerAuthDashboardWrapperState createState() =>
      _WorkerAuthDashboardWrapperState();
}

class _WorkerAuthDashboardWrapperState
    extends State<WorkerAuthDashboardWrapper> {
  int cIndex = 0;
  changePage(int index) {
    setState(() {
      cIndex = index;
    });
  }

  Widget getpage(int index) {
    if (index == 0) {
      return WorkerQRScanner(widget.centerData, widget.data);
    }
    if (index == 1) {
      return WorkerAuthProfilePage(
        widget.data,
        widget.centerData,
      );
    }
    if (index == 2) {
      return WorkerAuthSettingsWrapper(widget.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getpage(cIndex),
      bottomNavigationBar: WorkerAuthBottomNavbar(cIndex, changePage),
    );
  }
}
