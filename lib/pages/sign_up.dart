import 'package:flutter/material.dart';
import 'package:mission_rakshak/components/auth_components.dart';
import 'package:mission_rakshak/components/error_messages.dart';
import 'package:mission_rakshak/styles/colors.dart';
import 'package:mission_rakshak/styles/text_styles.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen(this.func);
  final Function func;
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool ok = true;
  var error_msg;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  String error;

  getErrorMessage(e, message) {
    setState(() {
      error = CorrectMessages.getErrorMessageForSignIn(e, message);
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
                        child:
                            Image.asset('assets/images/illustrations/auth.png'),
                        width: 400,
                        height: MediaQuery.of(context).size.height < 700
                            ? MediaQuery.of(context).size.height * 1.5 / 10
                            : MediaQuery.of(context).size.height * 2 / 10,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 30),
                        child: Text(
                          'Create Your Account',
                          style: authTitleTextStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Form(
                          autovalidateMode: AutovalidateMode.always,
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FormText(
                                icon: Icons.mail,
                                hintText: 'Email',
                                controller: emailController,
                                type: TextInputType.emailAddress,
                                shouldObscure: false,
                                validFunc: (value) {
                                  if (value.isEmpty) {
                                    return "Email cant be empty";
                                  } else
                                    return null;
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              FormText(
                                icon: Icons.lock,
                                hintText: 'Password',
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
                                height: 20,
                              ),
                              FormText(
                                icon: Icons.lock,
                                hintText: 'Confirm Password',
                                controller: confirmPasswordController,
                                shouldObscure: true,
                                type: TextInputType.text,
                                validFunc: (value) {
                                  if (value.isEmpty) {
                                    return "password cant be empty";
                                  }
                                  if (confirmPasswordController.text !=
                                      passwordController.text) {
                                    return 'passwords don\'t match';
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

                      SizedBox(
                        height: 10,
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        child: ActionButton(
                            text: 'Sign Up',
                            enabled: true,
                            onPressed: () async {
                              String message = '';
                              if (_formKey.currentState.validate()) {
                                if (confirmPasswordController.text !=
                                    passwordController.text) {
                                  Fluttertoast.showToast(
                                      msg: "The passwords dont match",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                  print('try again');
                                } else if ((passwordController.text).length <
                                    8) {
                                  Fluttertoast.showToast(
                                      msg:
                                          "Password length should be at least 8",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                  print('try again');
                                } else {
                                  try {
                                    await _firebaseAuth
                                        .createUserWithEmailAndPassword(
                                            email: emailController.text,
                                            password: passwordController.text);
                                    Navigator.pushReplacementNamed(
                                        context, "/introduction");
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
                                      // Fluttertoast.showToast(
                                      //     msg: error_msg,
                                      //     toastLength: Toast.LENGTH_SHORT,
                                      //     gravity: ToastGravity.BOTTOM,
                                      //     timeInSecForIosWeb: 1,
                                      //     backgroundColor: Colors.red,
                                      //     textColor: Colors.white,
                                      //     fontSize: 16.0);
                                      // print('try again');
                                    }
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
                              margin: EdgeInsets.only(left: 5),
                              child: Text(
                                'Already have an Account? Press here',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFE94139),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10, bottom: 10),
                              child: SmallerActionButton(
                                text: 'Login',
                                enabled: true,
                                onPressed: () {
                                  // Navigator.pushReplacementNamed(
                                  //     context, "/signup");
                                  widget.func();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Container(
                      //       margin: EdgeInsets.only(top: 10, bottom: 10),
                      //       child: SmallerActionButton(
                      //         text: 'Login',
                      //         enabled: true,
                      //         onPressed: () {
                      //           Navigator.pushReplacementNamed(
                      //               context, "/login");
                      //         },
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
