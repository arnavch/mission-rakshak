import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mission_rakshak/components/auth_components.dart';
import 'package:mission_rakshak/styles/colors.dart';
import 'package:mission_rakshak/styles/text_styles.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GetVerifiedPage extends StatefulWidget {
  GetVerifiedPage(
      {this.changePageToSettings, this.changePageToQRgen, this.userData});
  final Function changePageToSettings;
  final Function changePageToQRgen;
  final Map<String, dynamic> userData;

  @override
  _GetVerifiedPageState createState() => _GetVerifiedPageState();
}

class _GetVerifiedPageState extends State<GetVerifiedPage> {
  bool isDataCorrect = false;
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
                        'Donate blood',
                        style: authTitleTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        'Generate QR and get it scanned at blood donation center ',
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            fontFamily: 'Montserrat'),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 10)),
                    Row(
                      children: [
                        SizedBox(
                          width: 6,
                        ),
                        Checkbox(
                            activeColor: red,
                            value: isDataCorrect,
                            onChanged: (val) {
                              setState(() {
                                isDataCorrect = val;
                              });
                            }),
                        Text(
                          'I have you read the rules',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Montserrat'),
                        ),
                      ],
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        child: ActionButton(
                            text: 'Generate QR',
                            enabled: isDataCorrect,
                            onPressed: () {
                              widget.changePageToQRgen();
                            })),
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
      ),
    );
  }
}
