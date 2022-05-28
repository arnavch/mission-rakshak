import 'package:flutter/material.dart';
import 'package:mission_rakshak/styles/colors.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthSettingsPage extends StatefulWidget {
  AuthSettingsPage({
    this.changeToChangePassword,
  });
  final Function changeToChangePassword;

  @override
  _AuthSettingsPageState createState() => _AuthSettingsPageState();
}

class _AuthSettingsPageState extends State<AuthSettingsPage> {
  bool wantNotifications = false;

  signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SettingsList(
          sections: [
            SettingsSection(
              tiles: [
                // SettingsTile.switchTile(
                //   title: 'Notification',
                //   subtitle: 'Allow notifications',
                //   titleTextStyle: TextStyle(
                //       fontFamily: 'Montserrat', fontWeight: FontWeight.w700),
                //   switchActiveColor: red,
                //   subtitleTextStyle: TextStyle(fontFamily: 'Montserrat'),
                //   leading: Icon(
                //     Icons.notifications,
                //     color: red,
                //     size: 30,
                //   ),
                //   switchValue: wantNotifications,
                //   onToggle: (bool value) {
                //     setState(() {
                //       wantNotifications = value;
                //     });
                //   },
                // ),
                SettingsTile(
                  title: 'Change password',
                  subtitle: 'Click here to change password',
                  titleTextStyle: TextStyle(
                      fontFamily: 'Montserrat', fontWeight: FontWeight.w700),
                  subtitleTextStyle: TextStyle(fontFamily: 'Montserrat'),
                  leading: Icon(
                    Icons.lock,
                    color: red,
                    size: 30,
                  ),
                  onPressed: (BuildContext context) {
                    widget.changeToChangePassword();
                  },
                ),
                SettingsTile(
                  title: 'Sign Out',
                  subtitle: 'Click here to sign out',
                  titleTextStyle: TextStyle(
                      fontFamily: 'Montserrat', fontWeight: FontWeight.w700),
                  subtitleTextStyle: TextStyle(fontFamily: 'Montserrat'),
                  leading: Icon(
                    Icons.person_remove,
                    color: red,
                    size: 30,
                  ),
                  onPressed: (BuildContext context) {
                    signOut();

                    // Navigator.pushNamed(context, '/auth');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
