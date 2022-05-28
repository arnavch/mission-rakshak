import 'package:flutter/material.dart';
import 'package:mission_rakshak/styles/colors.dart';

// ignore: must_be_immutable
class ErrorMessage extends StatefulWidget {
  ErrorMessage(this.error);
  String error;

  @override
  _ErrorMessageState createState() => _ErrorMessageState();
}

class _ErrorMessageState extends State<ErrorMessage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.error_outline,
            color: red,
            size: 25,
          ),
          SizedBox(
            width: 5,
          ),
          Flexible(
            child: Text(
              widget.error,
              style: TextStyle(
                color: Color(0xFFE94139),
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
              // softWrap: false,
              // maxLines: 3,
            ),
          )
        ],
      ),
    );
  }
}

class CorrectMessages {
  static String getErrorMessageForLogin(e, message) {
    switch (e) {
      case "invalid-email":
        return "Your email address appears to be badly formatted.";
        break;
      case "wrong-password":
        return "Your password is wrong.";
        break;
      case "user-not-found":
        return "User with this email doesn't exist.";
        break;
      case "user-disabled":
        return "User with this email has been disabled.";
        break;
      case "too-many-requests":
        return "Too many requests. Try again later.";
        break;
      case "operation-not-allowed":
        return "Signing in with Email and Password is not enabled.";
        break;
      case "network-request-failed":
        return "Network error. please check your internet and try again";
        break;
      default:
        return message;
    }
  }

  static String getErrorMessageForSignIn(e, message) {
    switch (e) {
      case "operation-not-allowed":
        return "Anonymous accounts are not enabled";
        break;
      case "weak-password":
        return "Your password is too weak";
        break;
      case "invalid-email":
        return "Your email is invalid";
        break;
      case "email-already-in-use":
        return "Email is already in use on different account";
        break;
      case "invalid-credential":
        return "Your email is invalid";
        break;
      case "network-request-failed":
        return "Network error. please check your internet and try again";
        break;

      default:
        return message;
    }
  }

  static String getErrorMessageForForgotPassword(e, message) {
    switch (e) {
      case "user-not-found":
        return "User with this email doesn't exist.";
        break;
      case "invalid-email":
        return "Your email address appears to be badly formatted.";
        break;
      case "network-request-failed":
        return "Network error. please check your internet and try again";
        break;

      default:
        return message;
    }
  }
}
