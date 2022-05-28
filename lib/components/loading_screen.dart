import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Center(
                child: Transform.scale(
                  scale: 7.2,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    strokeWidth: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
