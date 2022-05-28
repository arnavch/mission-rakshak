import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'resetpassword_ page.dart';
import 'sign_up.dart';

class LoginWrapper extends StatefulWidget {
  @override
  _LoginWrapperState createState() => _LoginWrapperState();
}

class _LoginWrapperState extends State<LoginWrapper> {
  int pageNum = 1;

  changePageLogin() {
    setState(() {
      pageNum = 0;
    });
  }

  changePageSignUp() {
    setState(() {
      pageNum = 1;
    });
  }

  changePageForgotPassword() {
    setState(() {
      pageNum = 2;
    });
  }

  Widget cPage(val) {
    if (val == 1) {
      return SignUpScreen(changePageLogin);
    } else if (val == 0) {
      return LoginScreen(changePageSignUp, changePageForgotPassword);
      // add the name of the widget here instead of login... i already put the function needed to be passed
    } else if (val == 2) {
      return ResetPasswordPage(changePageLogin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return cPage(pageNum);
  }
}
