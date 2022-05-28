import 'package:flutter/material.dart';
import 'package:mission_rakshak/styles/colors.dart';
import 'package:mission_rakshak/styles/text_styles.dart';

class FormText extends StatefulWidget {
  FormText(
      {this.icon,
      this.hintText,
      this.controller,
      this.type,
      this.shouldObscure,
      this.validFunc});

  final IconData icon;
  final String hintText;
  final TextEditingController controller;
  final TextInputType type;
  final bool shouldObscure;
  final Function validFunc;

  @override
  _FormTextState createState() => _FormTextState();
}

class _FormTextState extends State<FormText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: red,
      ),
      child: TextFormField(
        obscureText: widget.shouldObscure,
        obscuringCharacter: widget.shouldObscure ? "⬤" : " ",
        keyboardType: widget.type,
        controller: widget.controller,
        style: inputTextStyle,
        validator: widget.validFunc,
        decoration: InputDecoration(
          errorStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          prefixIcon: Icon(
            widget.icon,
            color: Colors.white,
          ),
          hintText: widget.hintText,
          hintStyle:
              TextStyle(color: Colors.white, fontWeight: FontWeight.w200),
          fillColor: red,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: red,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: red,
            ),
          ),
        ),
      ),
    );
  }
}

class AlternateAuthMethodButton extends StatelessWidget {
  AlternateAuthMethodButton({this.imagePath});

  final String imagePath;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Material(
        elevation: 6.0,
        shadowColor: altAuthShadowColor,
        child: Container(
          decoration: BoxDecoration(
            color: altAuthColor,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          height: 50.0,
          width: 50.0,
          child: Center(
            child: Container(
              child: Image.asset(imagePath),
              width: 32,
              height: 32,
            ),
          ),
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  ActionButton({this.text, this.onPressed, this.enabled});

  final String text;
  final Function onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Material(
        elevation: 6.0,
        color: enabled ? red : Colors.grey,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: () {
            enabled ? onPressed() : print(".");
          },
          minWidth: 200.0,
          height: 42.0,
          child: Text(text, style: actionButtonTextStyle),
        ),
      ),
    );
  }
}

class SmallerActionButton extends StatelessWidget {
  SmallerActionButton({this.text, this.onPressed, this.enabled});

  final String text;
  final Function onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Material(
        elevation: 6.0,
        color: enabled ? red : Colors.grey,
        borderRadius: BorderRadius.circular(30.0),
        child: Container(
          child: MaterialButton(
            onPressed: () {
              enabled ? onPressed() : print(".");
            },
            child: Text(text, style: smallerActionButtonTextStyle),
          ),
          width: 100.0,
          height: 40.0,
        ),
      ),
    );
  }
}
