import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mission_rakshak/components/auth_components.dart';
import 'package:mission_rakshak/components/error_messages.dart';
import 'package:mission_rakshak/styles/colors.dart';
import 'package:mission_rakshak/styles/text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:status_alert/status_alert.dart';

class ResetPasswordPage extends StatefulWidget {
  ResetPasswordPage(this.func);
  final Function func;
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final _formKey7 = GlobalKey<FormState>();

  String error;

  getErrorMessage(e, message) {
    setState(() {
      error = CorrectMessages.getErrorMessageForForgotPassword(e, message);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool ok = true;
    dynamic error_msg;
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
        backgroundColor: Color(0xFFE94139),
        body: SafeArea(
          child: Column(
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(height: 100),
                          Container(
                            child: Image.asset(
                                'assets/images/illustrations/forgotpass.png'),
                            width: 400,
                            height: MediaQuery.of(context).size.height * 2 / 10,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 30, bottom: 30),
                            child: Text(
                              'Reset Password',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          // THE FORM

                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Form(
                              autovalidateMode: AutovalidateMode.always,
                              key: _formKey7,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                ],
                              ),
                            ),
                          ),

                          // BUTTON

                          error == null
                              ? Container(
                                  height: 0,
                                )
                              : ErrorMessage(error),

                          Container(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            child: ActionButton(
                              text: 'Forgot Password?',
                              enabled: true,
                              onPressed: () async {
                                String errorMessaage = '';
                                if (_formKey7.currentState.validate()) {
                                  try {
                                    await _firebaseAuth.sendPasswordResetEmail(
                                      email: emailController.text,
                                    );

                                    ok = true;
                                  } on FirebaseAuthException catch (e) {
                                    print(e);
                                    error_msg = e.code;
                                    errorMessaage = e.message;
                                    print(error_msg);
                                    ok = false;
                                  } finally {
                                    if (ok) {
                                      StatusAlert.show(context,
                                          duration: Duration(seconds: 3),
                                          title: 'Successful',
                                          subtitle: 'Reset password email sent',
                                          configuration: IconConfiguration(
                                              icon: Icons
                                                  .mark_email_read_outlined));
                                      widget.func();
                                      // Navigator.pushReplacementNamed(
                                      //     context, "/auth");
                                    } else {
                                      getErrorMessage(error_msg, errorMessaage);
                                    }
                                  }
                                }
                              },
                            ),
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
                                      widget.func();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
