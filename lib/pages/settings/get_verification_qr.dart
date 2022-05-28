import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mission_rakshak/components/auth_components.dart';
import 'package:mission_rakshak/styles/colors.dart';
import 'package:mission_rakshak/styles/text_styles.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRgen extends StatefulWidget {
  QRgen({this.changePageToGetVerified});
  final Function changePageToGetVerified;

  @override
  _QRgenState createState() => _QRgenState();
}

currentUser() {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final User user = _firebaseAuth.currentUser;
  final uuid = user.uid.toString();
  return uuid;
}

class _QRgenState extends State<QRgen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

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
                      margin: EdgeInsets.only(top: 30, bottom: 30),
                      child: Text(
                        'QR Code to scan',
                        style: authTitleTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 40),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              QrImage(
                                data: currentUser(),
                                version: QrVersions.auto,
                                size: 320,
                                gapless: false,
                                // embeddedImage:
                                //     AssetImage('assets/images/logo.png'),
                                embeddedImageStyle: QrEmbeddedImageStyle(
                                  size: Size(80, 80),
                                ),
                              )
                            ])),
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
                                widget.changePageToGetVerified();
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
      ),
    );
  }
}
