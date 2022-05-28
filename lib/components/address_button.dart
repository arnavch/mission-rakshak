import 'package:flutter/material.dart';
import 'package:mission_rakshak/styles/colors.dart';

class AddressButton extends StatelessWidget {
  AddressButton({this.icon, this.label, this.func});

  final String label;
  final IconData icon;
  final Function func;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        func();
      },
      child: Material(
        color: Colors.red,
        elevation: 10.0,
        shadowColor: altAuthShadowColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 7),
          height: MediaQuery.of(context).size.width > 330 ? 30.0 : 30.0,
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: MediaQuery.of(context).size.width > 340 ? 25 : 0.0,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Podkova',
                  fontSize: MediaQuery.of(context).size.width > 340 ? 15 : 17.0,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
