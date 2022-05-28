import 'package:flutter/material.dart';
import 'package:mission_rakshak/pages/settings/change_password_page.dart';
import 'package:mission_rakshak/pages/settings/donation_history.dart';
import 'package:mission_rakshak/pages/settings/get_verfied_page.dart';
import 'package:mission_rakshak/pages/settings/settings.dart';
import 'package:mission_rakshak/pages/settings/get_verification_qr.dart';
import 'package:mission_rakshak/styles/colors.dart';
import 'package:mission_rakshak/styles/text_styles.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SettingsWrapper extends StatefulWidget {
  SettingsWrapper(this.data);
  Map<String, dynamic> data;

  @override
  _SettingsWrapperState createState() => _SettingsWrapperState();
}

class _SettingsWrapperState extends State<SettingsWrapper> {
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

  changePageToGetVerified() {
    setState(() {
      cIndex = 2;
    });
  }

  changePageToQRgen() {
    setState(() {
      cIndex = 3;
    });
  }

  changePageToDonationHistory() {
    setState(() {
      cIndex = 4;
    });
  }

  Widget getPage(int index) {
    if (index == 0) {
      return SettingsPage(
        changePageToGetVerified: changePageToGetVerified,
        changePageToDonationHistory: changePageToDonationHistory,
        changeToChangePassword: changePageToChangePassword,
        userData: widget.data,
      );
    }
    if (index == 1) {
      return ChangePasswordPage(
          userData: widget.data, changePageToSettings: changePageToSettings);
    }
    if (index == 2) {
      return GetVerifiedPage(
          userData: widget.data,
          changePageToSettings: changePageToSettings,
          changePageToQRgen: changePageToQRgen);
    }
    if (index == 3) {
      return QRgen(changePageToGetVerified: changePageToGetVerified);
    }
    if (index == 4) {
      return DonationHistory(
        changePageToSettings: changePageToSettings,
        userData: widget.data,
      );
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
