import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mission_rakshak/Database/Userdata.dart';
import 'package:mission_rakshak/components/admin%20components/user_data_display.dart';
import 'package:mission_rakshak/components/auth_components.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:mission_rakshak/pages/autherized/auth_profile_page.dart';
import 'package:mission_rakshak/styles/colors.dart';
import 'package:mission_rakshak/styles/text_styles.dart';
import 'package:status_alert/status_alert.dart';

class QRScanner extends StatefulWidget {
  QRScanner(this.centerData, this.userData);
  Map<String, dynamic> centerData;
  Map<String, dynamic> userData;
  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  String uuidcode = '';
  Future<void> _scan() async {
    return await FlutterBarcodeScanner.scanBarcode(
            '#e94139', 'Go Back', true, ScanMode.QR)
        .then((value) => setState(() => uuidcode = value));
  }

  String centerNameDropDownVal;
  Map<String, dynamic> centerDataLoc;

  getCenters() {
    List centerName = [];
    centerDataLoc.forEach((key, value) {
      centerName.add(key);
    });
    return centerName;
  }

  List centerNames;

  getDropDownCenterNames() {
    return centerNames.map((e) {
      return DropdownMenuItem<String>(
        value: e,
        child: Text(
          e,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
        ),
      );
    }).toList();
  }

  List<DropdownMenuItem<String>> dropDownCenterNames;

  Widget getButton(
      {@required isVerified,
      @required uid,
      @required firstName,
      @required lastName,
      @required mobileNumber,
      @required dob,
      @required bloodType,
      @required centerName,
      @required email}) {
    if (isVerified) {
      return Container(
        margin: EdgeInsets.only(top: 5),
        width: 350,
        height: 40,
        child: Material(
          color: Color(0xFFE94139),
          borderRadius: BorderRadius.circular(30.0),
          child: MaterialButton(
            onPressed: () async {
              String name = firstName + ' ' + lastName;

              bool temp2 = await DonationHistoryData.createDonationLog(
                  name: name,
                  bloodType: bloodType,
                  centerName: centerName,
                  userId: uuidcode);

              StatusAlert.show(
                context,
                duration: Duration(seconds: 2),
                title: 'successful',
                subtitle: 'The donation has been added',
                configuration: IconConfiguration(icon: Icons.done),
              );

              setState(() {
                uuidcode = '';
              });
            },
            child: Text(
              'Add to donation history',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Montserrat',
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      );
    }
    return Container(
      margin: EdgeInsets.only(top: 5),
      width: 300,
      height: 60,
      child: Material(
        color: Color(0xFFE94139),
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: () async {
            bool temp = await UserDatabase.makeUserVerified(
                firstName: firstName,
                lastName: lastName,
                mobileNumber: mobileNumber,
                DOB: dob,
                bloodType: bloodType,
                uid: uid,
                email: email);

            print(temp);

            String name = firstName + ' ' + lastName;

            bool temp2 = await DonationHistoryData.createDonationLog(
                name: name,
                bloodType: bloodType,
                centerName: centerName,
                userId: uuidcode);

            StatusAlert.show(
              context,
              duration: Duration(seconds: 2),
              title: 'successful',
              subtitle: 'User verified and donation added',
              configuration: IconConfiguration(icon: Icons.done),
            );

            setState(() {
              uuidcode = '';
            });
          },
          child: Text(
            'Verify User and add to donation history',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Montserrat',
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    centerDataLoc = widget.centerData['center_location'];
    centerNames = getCenters();
    centerNameDropDownVal = widget.userData['centerName'];
    dropDownCenterNames = getDropDownCenterNames();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: red,
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Hi, ',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Administrator',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ],
                      ),
                      uuidcode != ''
                          ? FutureBuilder<DocumentSnapshot>(
                              future: UserDatabase.userDataCollection
                                  .doc(uuidcode)
                                  .get(),
                              // CenterData.getNearestCenterWithDocument(
                              //     latitude: latitude, longitude: longitude, index: centerData),

                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                print(uuidcode);
                                if (snapshot.hasError) {
                                  return Text(
                                    "Check your internet connection and try again",
                                    style: addressTextStyleBlack,
                                  );
                                }

                                if ((snapshot.hasData &&
                                    !snapshot.data.exists)) {
                                  return Text(
                                    "There was an error in scanning or check your internet connection and try again.",
                                    style: addressTextStyleBlack,
                                  );
                                  // showDialog<String>(
                                  //     context: context,
                                  //     builder: (BuildContext context) =>
                                  // AlertDialog(
                                  //   title: const Text(
                                  //       'There was an error'),
                                  //   content: const Text(
                                  //       'Either you dont have internet or the scanning was not correct. try agian'),
                                  //   actions: <Widget>[
                                  //     TextButton(
                                  //       onPressed: () {
                                  //         Navigator.pop(context, 'Ok');
                                  //       },
                                  //       child: const Text('Ok'),
                                  //     ),
                                  //   ],
                                  // ));
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  Map<String, dynamic> userData =
                                      snapshot.data.data();
                                  String name = userData['firstName'] +
                                      ' ' +
                                      userData['lastName'];
                                  String mobileNumber =
                                      userData['mobileNumber'];
                                  String email = userData['emailId'];
                                  String bloodType = userData['bloodType'];
                                  bool isVerified = userData['donatedBefore'];

                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      UserDataDisplay(
                                        name: name,
                                        email: email,
                                        mobileNumber: mobileNumber,
                                        bloodType: bloodType,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20.0),
                                        child: Container(
                                          height: 60,
                                          width: 200,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            color: red,
                                          ),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 13,
                                              ),
                                              Icon(
                                                Icons.apartment,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Theme(
                                                data: ThemeData(
                                                  canvasColor:
                                                      Color(0xFFE94139),
                                                ),
                                                child: DropdownButton(
                                                  items: dropDownCenterNames,
                                                  // underline: Container(height: 0),
                                                  value: centerNameDropDownVal,
                                                  icon: Icon(
                                                    Icons.expand_more,
                                                    color: Colors.white,
                                                  ),
                                                  hint: Text(
                                                    'Center Name',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontWeight:
                                                            FontWeight.w200),
                                                  ),
                                                  onChanged: (val) {
                                                    setState(() {
                                                      centerNameDropDownVal =
                                                          val;
                                                    });
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      getButton(
                                          isVerified: isVerified,
                                          firstName: userData['firstName'],
                                          lastName: userData['lastName'],
                                          mobileNumber: mobileNumber,
                                          email: email,
                                          bloodType: bloodType,
                                          uid: uuidcode,
                                          dob: userData['DOB'],
                                          centerName: centerNameDropDownVal),
                                    ],
                                  );
                                }

                                return Text(
                                  "Loading...",
                                  style: addressTextStyleBlack,
                                );
                              },
                            )
                          : Container(
                              height: 0,
                            ),
                      SizedBox(height: 150),
                      ActionButton(
                        enabled: true,
                        text: 'Scan QR Code',
                        onPressed: () => _scan(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
