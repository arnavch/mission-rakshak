import 'package:flutter/material.dart';
import 'package:mission_rakshak/components/auth_components.dart';
import 'package:mission_rakshak/components/error_messages.dart';

import 'package:mission_rakshak/styles/colors.dart';
import 'package:mission_rakshak/styles/text_styles.dart';

import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordPage extends StatefulWidget {
  ChangePasswordPage({this.changePageToSettings, this.userData});
  final Function changePageToSettings;
  final Map userData;
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool ok = true;
  var error_msg;

  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final _formKey8 = GlobalKey<FormState>();

  String error;

  getErrorMessage(e, message) {
    setState(() {
      error = CorrectMessages.getErrorMessageForLogin(e, message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Mission Rakshak",
            style: appBarTextStyle,
          ),
          backgroundColor: red,
          elevation: 0.0,
          centerTitle: true,
        ),
        backgroundColor: red,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Image.asset(
                            'assets/images/illustrations/forgotpass.png'),
                        width: 400,
                        height: MediaQuery.of(context).size.height < 700
                            ? MediaQuery.of(context).size.height * 1.5 / 10
                            : MediaQuery.of(context).size.height * 2 / 10,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 30),
                        child: Text(
                          'Change Your Password',
                          style: authTitleTextStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Form(
                          autovalidateMode: AutovalidateMode.always,
                          key: _formKey8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FormText(
                                icon: Icons.lock,
                                hintText: 'Current Password',
                                controller: currentPasswordController,
                                type: TextInputType.text,
                                shouldObscure: true,
                                validFunc: (value) {
                                  // if (value.isEmpty) {
                                  //   return "password cant be empty";
                                  // } else if (value.length < 8) {
                                  //   return 'Password length should be at least 8';
                                  // } else
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              FormText(
                                icon: Icons.lock,
                                hintText: 'New Password',
                                controller: passwordController,
                                type: TextInputType.text,
                                shouldObscure: true,
                                validFunc: (value) {
                                  if (value.isEmpty) {
                                    return "password cant be empty";
                                  } else if (value.length < 8) {
                                    return 'Password length should be at least 8';
                                  } else
                                    return null;
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              FormText(
                                icon: Icons.lock,
                                hintText: 'Confirm Password',
                                controller: confirmPasswordController,
                                shouldObscure: true,
                                type: TextInputType.text,
                                validFunc: (value) {
                                  if (value.isEmpty) {
                                    return "password can not be empty";
                                  }
                                  if (confirmPasswordController.text !=
                                      passwordController.text) {
                                    return 'passwords does not match';
                                  } else
                                    return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      error == null
                          ? Container(
                              height: 0,
                            )
                          : Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: ErrorMessage(error),
                            ),
                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        child: ActionButton(
                            text: 'Change Password',
                            enabled: true,
                            onPressed: () async {
                              String message = '';
                              if (_formKey8.currentState.validate()) {
                                User user = _firebaseAuth.currentUser;
                                EmailAuthCredential credential =
                                    EmailAuthProvider.credential(
                                        email: user.email,
                                        password:
                                            currentPasswordController.text);
                                try {
                                  await user
                                      .reauthenticateWithCredential(credential);
                                  await user
                                      .updatePassword(passwordController.text);
                                  widget.changePageToSettings();
                                } on FirebaseAuthException catch (e) {
                                  print(e);
                                  error_msg = e.code;
                                  message = e.message;
                                  print(error_msg);
                                  ok = false;
                                } finally {
                                  if (ok) {
                                    // Navigator.pushReplacementNamed(
                                    //     context, "/auth");
                                  } else {
                                    getErrorMessage(error_msg, message);
                                  }
                                }
                              }
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5),
                            Container(
                              margin: EdgeInsets.only(top: 10, bottom: 10),
                              child: SmallerActionButton(
                                text: 'Go Back',
                                enabled: true,
                                onPressed: () {
                                  // Navigator.pushReplacementNamed(
                                  //     context, "/signup");
                                  widget.changePageToSettings();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
