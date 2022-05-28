import 'package:flutter/material.dart';
import 'package:mission_rakshak/styles/colors.dart';
import 'package:mission_rakshak/styles/text_styles.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration(seconds: 2), () {
    //   Navigator.pushReplacementNamed(context, '/dashboard_wrapper');
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: Container(
          color: red,
          child: Stack(
            children: [
              // Center(
              //   child: Image.asset(
              //     'assets/images/logo.png',
              //   ),
              // ),
              Center(
                child: CircleAvatar(
                  radius: 110,
                  backgroundImage: AssetImage('assets/images/logo.png'),
                ),
              ),
              Center(
                child: Transform.scale(
                  scale: 7.2,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 1.5,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Mission",
                        style: splashScreenTextStyle,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 200,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Rakshak", style: splashScreenTextStyle),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
