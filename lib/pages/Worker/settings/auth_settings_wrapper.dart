import 'package:flutter/material.dart';
import 'package:mission_rakshak/pages/Worker/settings/auth_settings.dart';
import 'package:mission_rakshak/pages/settings/change_password_page.dart';
import 'package:mission_rakshak/styles/colors.dart';
import 'package:mission_rakshak/styles/text_styles.dart';

class WorkerAuthSettingsWrapper extends StatefulWidget {
  WorkerAuthSettingsWrapper(this.data);
  Map<String, dynamic> data;

  @override
  _WorkerAuthSettingsWrapperState createState() =>
      _WorkerAuthSettingsWrapperState();
}

class _WorkerAuthSettingsWrapperState extends State<WorkerAuthSettingsWrapper> {
  int cIndex = 0;
  changePage(int index) {
    setState(() {
      cIndex = index;
    });
  }

  changePageToChangePassword() {
    setState(() {
      cIndex = 1;
    });
  }

  changePageToSettings() {
    setState(() {
      cIndex = 0;
    });
  }

  Widget getPage(int index) {
    if (index == 0) {
      return WorkerAuthSettingsPage(
        changeToChangePassword: changePageToChangePassword,
      );
    }
    if (index == 1) {
      return ChangePasswordPage(
          userData: widget.data, changePageToSettings: changePageToSettings);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: cIndex == 0
          ? AppBar(
              backgroundColor: red,
              // centerTitle: true,
              elevation: 0,
              title: Text('Settings', style: appBarTextStyle),
            )
          : null,
      body: getPage(cIndex),
    );
  }
}
