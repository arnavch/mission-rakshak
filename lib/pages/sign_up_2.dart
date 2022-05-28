import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mission_rakshak/components/auth_components.dart';
import 'package:mission_rakshak/components/loading_screen.dart';
import 'package:mission_rakshak/pages/rule_page.dart';
import 'package:mission_rakshak/styles/colors.dart';
import 'package:mission_rakshak/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:mission_rakshak/models/constants.dart';
import 'package:status_alert/status_alert.dart';

import 'package:geolocator/geolocator.dart';

import 'package:mission_rakshak/Database/Userdata.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/constants.dart';

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  TextEditingController firstName = new TextEditingController();
  TextEditingController lastName = new TextEditingController();
  TextEditingController mobileNumber = new TextEditingController();
  TextEditingController address = new TextEditingController();

  double latitude;
  double longitude;

  //DOB have to do
  DateTime dateOfBirth;
  DateTime today = DateTime.now();
  // gender selected Enum -- connected
  Gender _gender = Gender.male;

  // checkbox checking variable -- connected
  bool isDataCorrect = false;
  bool readed = false;

  List<DropdownMenuItem> dropDownItems = bloodGroups.map((e) {
    return DropdownMenuItem(
      value: e,
      child: Text(
        e,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
      ),
    );
  }).toList();

  // blood group selected variable -- connected
  String bloodGroupVal = 'O+';

  // database

  final _formKey1 = GlobalKey<FormState>();

  bool _isBusy = false;

  UserDatabase data = UserDatabase(FirebaseAuth.instance.currentUser);

  writeUserData(bloodType, gender) {
    data.updateUnauthorizedUserDataFromSignIn(
      firstName: firstName.text,
      lastName: lastName.text,
      mobileNumber: mobileNumber.text,
      bloodType: bloodType,
      gender: gender,
      DOB: Timestamp.fromDate(dateOfBirth),
      address: address.text,
      latitude: latitude,
      longitude: longitude,
    );
  }

  // ignore: non_constant_identifier_names
  String DOBText = 'DD/MM/YY';

  getDOBText(dateOfBirth) {
    if (dateOfBirth == null) {
      setState(() {
        DOBText = 'DD/MM/YY';
      });
    } else
      setState(() {
        DOBText = dateOfBirth.day.toString() +
            "/" +
            dateOfBirth.month.toString() +
            "/" +
            dateOfBirth.year.toString();
      });
  }

  Future<Position> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      setState(() {
        _isBusy = false;
      });
      return value;
    });
    return position;
  }

  @override
  void initState() {
    super.initState();
    // data.createUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE94139),
      body: _isBusy
          ? Loading()
          : SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    child: Text(
                      'Mission Rakshak',
                      style: appBarTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 30, top: 60),
                              child: Text(
                                'We need some more info',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                            // THE FORM

                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Form(
                                autovalidateMode: AutovalidateMode.always,
                                key: _formKey1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    FormText(
                                      icon: Icons.person,
                                      hintText: 'First Name',
                                      shouldObscure: false,
                                      controller: firstName,
                                      type: TextInputType.name,
                                      validFunc: (value) {
                                        if (value.isEmpty) {
                                          return "First Name cant be empty";
                                        }
                                        if (value.length > 20) {
                                          return "First Name cant be greater than 20";
                                        } else
                                          return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    FormText(
                                      icon: Icons.person,
                                      hintText: 'Last Name',
                                      shouldObscure: false,
                                      controller: lastName,
                                      type: TextInputType.name,
                                      validFunc: (value) {
                                        if (value.isEmpty) {
                                          return "Last Name cant be empty";
                                        }
                                        if (value.length > 20) {
                                          return "Last Name cant be greater than 20";
                                        } else
                                          return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    FormText(
                                      icon: Icons.phone,
                                      hintText: 'Mobile Number',
                                      controller: mobileNumber,
                                      shouldObscure: false,
                                      type: TextInputType.phone,
                                      validFunc: (value) {
                                        if (value.length < 8) {
                                          return 'we need a valid mobile number';
                                        }
                                        if (value.length > 10) {
                                          return "Mobile Number cant be greater than 10";
                                        } else
                                          return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    FormText(
                                      icon: Icons.home,
                                      hintText: 'Address',
                                      controller: address,
                                      shouldObscure: false,
                                      type: TextInputType.name,
                                      validFunc: (value) {
                                        if (value.length < 1) {
                                          return 'Address can\'t be empty';
                                        }
                                        if (value.length > 100) {
                                          return "Address can\'t be greater than 100 characters";
                                        } else
                                          return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
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
                                            Icons.opacity,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Theme(
                                            data: ThemeData(
                                              canvasColor: Color(0xFFE94139),
                                            ),
                                            child: DropdownButton(
                                              items: dropDownItems,
                                              // underline: Container(height: 0),
                                              value: bloodGroupVal,
                                              icon: Icon(
                                                Icons.expand_more,
                                                color: Colors.white,
                                              ),
                                              hint: Text(
                                                'Blood Group',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight:
                                                        FontWeight.w200),
                                              ),
                                              onChanged: (val) {
                                                setState(() {
                                                  bloodGroupVal = val;
                                                });
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 10, left: 5),
                                      child: Text(
                                        'Gender',
                                        style: dataTitleStyle,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Radio<Gender>(
                                          activeColor: Color(0xFFE94139),
                                          value: Gender.male,
                                          groupValue: _gender,
                                          onChanged: (Gender value) {
                                            setState(
                                              () {
                                                _gender = value;
                                                print(_gender);
                                              },
                                            );
                                          },
                                        ),
                                        Text(
                                          'Male',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            color: Colors.black,
                                            fontFamily: 'Montserrat',
                                            fontSize: 15,
                                          ),
                                        ),
                                        MediaQuery.of(context).size.width > 350
                                            ? SizedBox(
                                                width: 80,
                                              )
                                            : SizedBox(width: 30),
                                        Radio<Gender>(
                                          activeColor: Color(0xFFE94139),
                                          value: Gender.female,
                                          groupValue: _gender,
                                          onChanged: (Gender value) {
                                            setState(
                                              () {
                                                _gender = value;
                                                print(_gender);
                                              },
                                            );
                                          },
                                        ),
                                        Text(
                                          'Female',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontFamily: 'Montserrat',
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: Text(
                                        'Your house location',
                                        style: dataTitleStyle,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 5),
                                      width: 250,
                                      height: 33,
                                      child: Material(
                                        color: Color(0xFFE94139),
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        child: MaterialButton(
                                          onPressed: () async {
                                            LocationPermission permission =
                                                await Geolocator
                                                    .checkPermission();
                                            if (permission ==
                                                LocationPermission.denied) {
                                              permission = await Geolocator
                                                  .requestPermission();
                                              if (permission ==
                                                  LocationPermission.denied) {
                                                showDialog<String>(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        AlertDialog(
                                                          title: const Text(
                                                              'You have denied permission'),
                                                          content: const Text(
                                                              'Please allow permission so we can get your location'),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context,
                                                                    'Cancel');
                                                              },
                                                              child: const Text(
                                                                  'Cancel'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context,
                                                                    'Ok');
                                                              },
                                                              child: const Text(
                                                                  'Ok'),
                                                            ),
                                                          ],
                                                        ));
                                                return Future.error(
                                                    'Location permissions are denied');
                                              }
                                            }

                                            if (permission ==
                                                LocationPermission
                                                    .deniedForever) {
                                              // Permissions are denied forever, handle appropriately.
                                              showDialog<String>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                            title: const Text(
                                                                'You have denied permission forever'),
                                                            content: const Text(
                                                                'To get location you will have to allow permission from settings'),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context,
                                                                      'Cancel');
                                                                },
                                                                child: const Text(
                                                                    'Cancel'),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context,
                                                                      'Ok');
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'Ok'),
                                                              ),
                                                            ],
                                                          ));
                                            } else {
                                              // When we reach here, permissions are granted and we can
                                              // continue accessing the position of the device.
                                              setState(() {
                                                _isBusy = true;
                                              });
                                              Position position =
                                                  await getLocation();
                                              if (position == null) {
                                                StatusAlert.show(
                                                  context,
                                                  duration:
                                                      Duration(seconds: 3),
                                                  title: 'Try again',
                                                  subtitle:
                                                      'Check your internet connection and try again',
                                                  configuration:
                                                      IconConfiguration(
                                                          icon: Icons.error),
                                                );
                                              } else {
                                                latitude = position.latitude;
                                                longitude = position.longitude;
                                                print(latitude);
                                                print(longitude);

                                                StatusAlert.show(
                                                  context,
                                                  duration:
                                                      Duration(seconds: 2),
                                                  title: 'successful',
                                                  subtitle: 'Location received',
                                                  configuration:
                                                      IconConfiguration(
                                                          icon: Icons.done),
                                                );
                                              }
                                              // Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                                              // latitude = position.latitude;
                                              // longitude = position.longitude;
                                              // print(latitude);
                                              // print(longitude);
                                            }
                                          },
                                          child: Text(
                                            'Get Home Location',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'Montserrat',
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(
                                        latitude == null || longitude == null
                                            ? 'Only do this in your house'
                                            : 'location has been received successfully',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Montserrat',
                                          color: red,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 10, left: 5),
                                      child: Text(
                                        'Date of Birth',
                                        style: dataTitleStyle,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 10, left: 5),
                                      child: Text(
                                        DOBText,
                                        style: dataTitleStyle.copyWith(
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 5),
                                      width: 170,
                                      height: 33,
                                      child: Material(
                                        color: Color(0xFFE94139),
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        child: MaterialButton(
                                          onPressed: () async {
                                            setState(() async {
                                              dateOfBirth = await showDatePicker(
                                                  context: context,
                                                  initialDate: today,
                                                  firstDate: today.subtract(
                                                      Duration(
                                                          days: 366 * 100)),
                                                  helpText:
                                                      "Select Date of Birth",
                                                  initialEntryMode:
                                                      DatePickerEntryMode
                                                          .calendar,
                                                  lastDate: today);
                                              getDOBText(dateOfBirth);
                                            });
                                          },
                                          child: Text(
                                            'Select DOB',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'Montserrat',
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

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
                                  'Is the given data correct?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Montserrat'),
                                ),
                              ],
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Container(
                                    margin: EdgeInsets.only(top: 5),
                                    width: 170,
                                    height: 33,
                                    child: Material(
                                      color: Color(0xFFE94139),
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: MaterialButton(
                                        onPressed: () {
                                          showModalBottomSheet<void>(
                                              context: context,
                                              isScrollControlled: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              builder: (BuildContext context) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(20),
                                                            topRight:
                                                                Radius.circular(
                                                                    20)),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10),
                                                    child:
                                                        SingleChildScrollView(
                                                      child: RulePage(
                                                        ruleBeforeDonation:
                                                            false,
                                                        changeBool: () {
                                                          setState(() {
                                                            readed = true;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                        child: Text(
                                          'Read Rules',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'Montserrat',
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 6,
                                ),
                                Checkbox(
                                    activeColor: red,
                                    value: readed,
                                    onChanged: (val) {
                                      setState(() {
                                        readed = val;
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
                                  text: 'Continue',
                                  enabled: (isDataCorrect && readed),
                                  onPressed: () {
                                    lastName.text = lastName.text.trim();
                                    firstName.text = firstName.text.trim();
                                    firstName.text =
                                        firstName.text.toLowerCase();
                                    lastName.text = lastName.text.toLowerCase();

                                    address.text = address.text.trim();
                                    mobileNumber.text =
                                        mobileNumber.text.trim();

                                    if (latitude == null || longitude == null) {
                                      showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                title: const Text(
                                                    'Please us give your location'),
                                                content: const Text(
                                                    'Please press on the button \'Get Current Location\' and allow permission to continue'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, 'Ok');
                                                    },
                                                    child: const Text('Ok'),
                                                  ),
                                                ],
                                              ));
                                    } else if (_formKey1.currentState
                                            .validate() &&
                                        dateOfBirth != null) {
                                      String gender;
                                      _gender == Gender.male
                                          ? gender = 'Male'
                                          : gender = 'Female';
                                      writeUserData(bloodGroupVal, gender);
                                      Navigator.pushReplacementNamed(
                                          context, "/auth");
                                    } else {
                                      if (dateOfBirth == null) {
                                        StatusAlert.show(
                                          context,
                                          duration: Duration(seconds: 3),
                                          title:
                                              'Please enter your date of birth',
                                          subtitle: null,
                                          configuration: IconConfiguration(
                                              icon: Icons.error),
                                        );
                                      } else {
                                        StatusAlert.show(
                                          context,
                                          duration: Duration(seconds: 3),
                                          title: 'Incorrect Data',
                                          subtitle:
                                              'Name, address, or mobile number is incorrect',
                                          configuration: IconConfiguration(
                                              icon: Icons.error),
                                        );
                                      }
                                    }
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
