import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mission_rakshak/components/auth_components.dart';
import 'package:mission_rakshak/pages/rule_page.dart';
import 'package:mission_rakshak/styles/colors.dart';
import 'package:mission_rakshak/styles/text_styles.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BloodDonationPage extends StatefulWidget {
  BloodDonationPage({this.changePageQRCode});
  final Function changePageQRCode;
  @override
  _BloodDonationPageState createState() => _BloodDonationPageState();
}

class _BloodDonationPageState extends State<BloodDonationPage> {
  bool acceptedTerms = false;
  bool gernerateQr = false;

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
                    gernerateQr == false
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                child: SmallerActionButton(
                                  text: 'Read Rules',
                                  enabled: true,
                                  onPressed: () {
                                    showModalBottomSheet<void>(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (BuildContext context) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  topRight:
                                                      Radius.circular(20)),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: SingleChildScrollView(
                                                child: RulePage(
                                                  ruleBeforeDonation: true,
                                                  changeBool: () {
                                                    setState(() {
                                                      acceptedTerms = true;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Checkbox(
                                      activeColor: red,
                                      value: acceptedTerms,
                                      onChanged: (val) {
                                        setState(() {
                                          acceptedTerms = val;
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
                                  enabled: acceptedTerms,
                                  onPressed: () {
                                    setState(() {});
                                    gernerateQr = true;
                                  },
                                ),
                              ),
                            ],
                          )
                        : SizedBox(),
                    gernerateQr == true
                        ? Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 40),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                QrImage(
                                  data: FirebaseAuth.instance.currentUser.uid
                                      .toString(),
                                  version: QrVersions.auto,
                                  size: 320,
                                  gapless: false,
                                  // embeddedImage:
                                  //     AssetImage('assets/images/logo.png'),
                                  embeddedImageStyle: QrEmbeddedImageStyle(
                                    size: Size(80, 80),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Container(
                                  margin: EdgeInsets.only(top: 10, bottom: 10),
                                  child: SmallerActionButton(
                                    text: 'Go Back',
                                    enabled: true,
                                    onPressed: () {
                                      setState(() {
                                        gernerateQr = false;
                                        acceptedTerms = false;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),
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
