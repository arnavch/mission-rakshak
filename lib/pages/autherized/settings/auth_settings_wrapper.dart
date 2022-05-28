import 'package:flutter/material.dart';
import 'package:mission_rakshak/pages/autherized/settings/auth_settings.dart';
import 'package:mission_rakshak/pages/settings/change_password_page.dart';
import 'package:mission_rakshak/styles/colors.dart';
import 'package:mission_rakshak/styles/text_styles.dart';

class AuthSettingsWrapper extends StatefulWidget {
  AuthSettingsWrapper(this.data);
  Map<String, dynamic> data;

  @override
  _AuthSettingsWrapperState createState() => _AuthSettingsWrapperState();
}

class _AuthSettingsWrapperState extends State<AuthSettingsWrapper> {
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
      return AuthSettingsPage(
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
