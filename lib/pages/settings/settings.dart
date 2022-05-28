import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mission_rakshak/Database/Userdata.dart';
import 'package:mission_rakshak/pages/rule_page.dart';
import 'package:mission_rakshak/styles/colors.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({
    this.changeToChangePassword,
    this.changePageToGetVerified,
    this.userData,
    this.changePageToDonationHistory,
  });
  final Function changeToChangePassword;
  final Function changePageToGetVerified;
  final Function changePageToDonationHistory;
  final Map<String, dynamic> userData;
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  //bool wantNotifications = false;

  signOut() async {
    String bloodType = widget.userData['bloodType'];
    String topic;
    topic = bloodType.substring(0, bloodType.length - 1);

    if (bloodType[bloodType.length - 1] == '+') {
      topic = topic + '_p';
    }
    if (bloodType[bloodType.length - 1] == '-') {
      topic = topic + '_n';
    }

    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);

    await FirebaseAuth.instance.signOut();
  }

  // Widget checkVerified(isVerified) {
  //   if (isVerified) {
  //     return SettingsTile(
  //       title: 'Donate Blood',
  //       subtitle: 'Click here to get verified',
  //       titleTextStyle:
  //           TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700),
  //       subtitleTextStyle: TextStyle(fontFamily: 'Montserrat'),
  //       leading: Icon(
  //         Icons.opacity,
  //         color: red,
  //         size: 30,
  //       ),
  //       onPressed: (BuildContext context) {
  //         widget.changePageToGetVerified();
  //       },
  //     );
  //   } else {
  //     return SettingsTile(
  //       title: 'Donate Blood And Get Verified',
  //       subtitle: 'Click here to get verified',
  //       titleTextStyle:
  //           TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700),
  //       subtitleTextStyle: TextStyle(fontFamily: 'Montserrat'),
  //       leading: Icon(
  //         Icons.how_to_reg,
  //         color: red,
  //         size: 30,
  //       ),
  //       onPressed: (BuildContext context) {
  //         widget.changePageToGetVerified();
  //       },
  //     );
  //   }
  // }
  //
  // Widget checkVerified2(isVerified) {
  //   if (isVerified) {
  //     return SettingsTile(
  //       title: 'Donate Blood',
  //       subtitle: 'Click here to get verified',
  //       titleTextStyle:
  //           TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700),
  //       subtitleTextStyle: TextStyle(fontFamily: 'Montserrat'),
  //       leading: Icon(
  //         Icons.opacity,
  //         color: red,
  //         size: 30,
  //       ),
  //       onPressed: (BuildContext context) {
  //         widget.changePageToGetVerified();
  //       },
  //     );
  //   } else {
  //     return SettingsTile(
  //       title: 'Donate Blood And Get Verified',
  //       subtitle: 'Click here to get verified',
  //       titleTextStyle:
  //           TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700),
  //       subtitleTextStyle: TextStyle(fontFamily: 'Montserrat'),
  //       leading: Icon(
  //         Icons.how_to_reg,
  //         color: red,
  //         size: 30,
  //       ),
  //       onPressed: (BuildContext context) {
  //         widget.changePageToGetVerified();
  //       },
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SettingsList(
          sections: [
            widget.userData['donatedBefore'] == true
                ? SettingsSection(
                    tiles: [
                      // SettingsTile.switchTile(
                      //   title: 'Notification',
                      //   subtitle: 'Allow notifications',
                      //   titleTextStyle: TextStyle(
                      //       fontFamily: 'Montserrat',
                      //       fontWeight: FontWeight.w700),
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
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700),
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
                        title: 'About the app',
                        subtitle: 'why this app exists',
                        titleTextStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700),
                        subtitleTextStyle: TextStyle(fontFamily: 'Montserrat'),
                        leading: Icon(
                          Icons.help,
                          color: red,
                          size: 30,
                        ),
                        onPressed: (BuildContext context) {
                          Navigator.pushReplacementNamed(
                              context, "/introduction");
                        },
                      ),
                      SettingsTile(
                        title: 'Read the rules',
                        subtitle: 'Click here to read the rules for donation',
                        titleTextStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700),
                        subtitleTextStyle: TextStyle(fontFamily: 'Montserrat'),
                        leading: Icon(
                          Icons.rule,
                          color: red,
                          size: 30,
                        ),
                        onPressed: (BuildContext context) {
                          showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (BuildContext context) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: SingleChildScrollView(
                                      child: RulePage(
                                        ruleBeforeDonation: true,
                                        changeBool: () {},
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
                      SettingsTile(
                        title: 'Donation History',
                        subtitle: 'Click here to get verified',
                        titleTextStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700),
                        subtitleTextStyle: TextStyle(fontFamily: 'Montserrat'),
                        leading: Icon(
                          Icons.book,
                          color: red,
                          size: 30,
                        ),
                        onPressed: (BuildContext context) {
                          widget.changePageToDonationHistory();
                        },
                      ),
                      SettingsTile(
                        title: 'Sign Out',
                        subtitle: 'Click here to sign out',
                        titleTextStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700),
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
                  )
                : SettingsSection(
                    tiles: [
                      // SettingsTile.switchTile(
                      //   title: 'Notification',
                      //   subtitle: 'Allow notifications',
                      //   titleTextStyle: TextStyle(
                      //       fontFamily: 'Montserrat',
                      //       fontWeight: FontWeight.w700),
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
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700),
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
                        title: 'About the app',
                        subtitle: 'why this app exists',
                        titleTextStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700),
                        subtitleTextStyle: TextStyle(fontFamily: 'Montserrat'),
                        leading: Icon(
                          Icons.help,
                          color: red,
                          size: 30,
                        ),
                        onPressed: (BuildContext context) {
                          Navigator.pushReplacementNamed(
                              context, "/introduction");
                        },
                      ),
                      SettingsTile(
                        title: 'Read the rules',
                        subtitle: 'Click here to read the rules for donation',
                        titleTextStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700),
                        subtitleTextStyle: TextStyle(fontFamily: 'Montserrat'),
                        leading: Icon(
                          Icons.rule,
                          color: red,
                          size: 30,
                        ),
                        onPressed: (BuildContext context) {
                          showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (BuildContext context) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: SingleChildScrollView(
                                      child: RulePage(
                                        ruleBeforeDonation: true,
                                        changeBool: () {},
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
                      SettingsTile(
                        title: 'Delete Data',
                        subtitle: 'if the data inputted is wrong',
                        titleTextStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700),
                        subtitleTextStyle: TextStyle(fontFamily: 'Montserrat'),
                        leading: Icon(
                          Icons.delete,
                          color: red,
                          size: 30,
                        ),
                        onPressed: (BuildContext context) {
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: const Text(
                                        'Are you sure that you want to delete your data'),
                                    content: const Text(
                                        'If yes then you will have to re-login and input the data again.'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, 'Cancel');
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          User user =
                                              FirebaseAuth.instance.currentUser;
                                          UserDatabase userFunc =
                                              UserDatabase(user);
                                          bool temp = await userFunc
                                              .deleteUser(widget.userData);
                                          print(temp);
                                          signOut();
                                          Navigator.pop(context, 'Ok');
                                        },
                                        child: const Text('Yes'),
                                      ),
                                    ],
                                  ));
                        },
                      ),
                      SettingsTile(
                        title: 'Sign Out',
                        subtitle: 'Click here to sign out',
                        titleTextStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700),
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
                  )
          ],
        ),
      ),
    );
  }
}
