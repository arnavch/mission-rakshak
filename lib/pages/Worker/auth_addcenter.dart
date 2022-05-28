import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mission_rakshak/Database/centerData.dart';
import 'package:mission_rakshak/components/auth_components.dart';
import 'package:mission_rakshak/styles/text_styles.dart';
import 'package:status_alert/status_alert.dart';

class Auth_AddCenter extends StatefulWidget {
  @override
  _Auth_AddCenterState createState() => _Auth_AddCenterState();
}

// ignore: camel_case_types
class _Auth_AddCenterState extends State<Auth_AddCenter> {
  double latitude;
  double longitude;
  bool isUserAuth = false;

  String error;

  bool _isBusy = false;

  final TextEditingController centereEmailController = TextEditingController();
  final TextEditingController centereNameController = TextEditingController();
  final TextEditingController centereAddressController =
      TextEditingController();
  final TextEditingController centereMobileNumberController =
      TextEditingController();
  final _formKey6 = GlobalKey<FormState>();

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
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
                      SizedBox(
                        height: 30,
                      ),

                      Container(
                        margin: EdgeInsets.only(bottom: 30),
                        child: Text(
                          'Add a center',
                          style: authTitleTextStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Form(
                          autovalidateMode: AutovalidateMode.always,
                          key: _formKey6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FormText(
                                icon: Icons.apartment,
                                hintText: 'Center name',
                                controller: centereNameController,
                                type: TextInputType.text,
                                shouldObscure: false,
                                validFunc: (value) {
                                  if (value.isEmpty) {
                                    return "center name cant be empty";
                                  } else if (value.length > 50) {
                                    return 'center name length should be lower than 50';
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
                                controller: centereAddressController,
                                type: TextInputType.text,
                                shouldObscure: false,
                                validFunc: (value) {
                                  if (value.isEmpty) {
                                    return "Address can\t be empty";
                                  } else if (value.length > 200) {
                                    return 'Address length should be lower than 200';
                                  } else
                                    return null;
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              FormText(
                                icon: Icons.mail,
                                hintText: 'Email',
                                controller: centereEmailController,
                                shouldObscure: false,
                                type: TextInputType.emailAddress,
                                validFunc: (value) {
                                  if (value.isEmpty) {
                                    return "Email can\t be empty";
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
                                controller: centereMobileNumberController,
                                shouldObscure: false,
                                type: TextInputType.phone,
                                validFunc: (value) {
                                  if (value.length < 8) {
                                    return 'Need a valid mobile number';
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

                              Container(
                                margin: EdgeInsets.only(top: 5),
                                width: 250,
                                height: 33,
                                child: Material(
                                  color: Color(0xFFE94139),
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: MaterialButton(
                                    onPressed: () async {
                                      LocationPermission permission =
                                          await Geolocator.checkPermission();
                                      if (permission ==
                                          LocationPermission.denied) {
                                        permission = await Geolocator
                                            .requestPermission();
                                        if (permission ==
                                            LocationPermission.denied) {
                                          showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                    title: const Text(
                                                        'You have denied permission'),
                                                    content: const Text(
                                                        'Please allow permission so we can get your location'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(context,
                                                              'Cancel');
                                                        },
                                                        child: const Text(
                                                            'Cancel'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context, 'Ok');
                                                        },
                                                        child: const Text('Ok'),
                                                      ),
                                                    ],
                                                  ));
                                        }
                                      }

                                      if (permission ==
                                          LocationPermission.deniedForever) {
                                        // Permissions are denied forever, handle appropriately.
                                        showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                                  title: const Text(
                                                      'You have denied permission forever'),
                                                  content: const Text(
                                                      'To get location you will have to allow permission from settings'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(
                                                            context, 'Cancel');
                                                      },
                                                      child:
                                                          const Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(
                                                            context, 'Ok');
                                                      },
                                                      child: const Text('Ok'),
                                                    ),
                                                  ],
                                                ));
                                      } else {
                                        setState(() {
                                          _isBusy = true;
                                        });
                                        Position position = await getLocation();
                                        if (position == null) {
                                          StatusAlert.show(
                                            context,
                                            duration: Duration(seconds: 3),
                                            title: 'Try again',
                                            subtitle:
                                                'Check your internet connection and try again',
                                            configuration: IconConfiguration(
                                                icon: Icons.error),
                                          );
                                        } else {
                                          latitude = position.latitude;
                                          longitude = position.longitude;
                                          print(latitude);
                                          print(longitude);

                                          StatusAlert.show(
                                            context,
                                            duration: Duration(seconds: 2),
                                            title: 'successful',
                                            subtitle:
                                                'Location successfully received',
                                            configuration: IconConfiguration(
                                                icon: Icons.done),
                                          );
                                        }
                                      }
                                    },
                                    child: Text(
                                      'Get Current Location',
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

                              // error == null
                              //     ? Container(
                              //         height: 0,
                              //       )
                              //     : Padding(
                              //         padding: const EdgeInsets.only(top: 10),
                              //         child: ErrorMessage(error),
                              //       ),
                              Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                child: ActionButton(
                                    text: 'Add Center',
                                    enabled: true,
                                    onPressed: () async {
                                      centereNameController.text =
                                          centereNameController.text.trim();
                                      centereNameController.text =
                                          centereNameController.text
                                              .toLowerCase();

                                      centereAddressController.text =
                                          centereAddressController.text.trim();

                                      centereMobileNumberController.text =
                                          centereMobileNumberController.text
                                              .trim();

                                      centereEmailController.text =
                                          centereEmailController.text.trim();
                                      centereEmailController.text =
                                          centereEmailController.text
                                              .toLowerCase();

                                      if (latitude == null ||
                                          longitude == null) {
                                        showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                                  title: const Text(
                                                      'the location of center is not defined'),
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
                                      } else {
                                        dynamic query = await FirebaseFirestore
                                            .instance
                                            .collection('bloodDonationCenters')
                                            .where('name',
                                                isEqualTo:
                                                    centereNameController.text)
                                            .get();

                                        if (query.docs.length > 0) {
                                          showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                    title: const Text(
                                                        'Invalid center name'),
                                                    content: const Text(
                                                        'Center with this name already exists. please change the name'),
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
                                        } else if (_formKey6.currentState
                                            .validate()) {
                                          await CenterData
                                              .createBloodDonationCenter(
                                            name: centereNameController.text,
                                            address:
                                                centereAddressController.text,
                                            mobileNumber:
                                                centereMobileNumberController
                                                    .text,
                                            emailId:
                                                centereEmailController.text,
                                            latitude: latitude,
                                            longitude: longitude,
                                          );
                                          centereNameController.text = '';

                                          centereAddressController.text = '';

                                          centereMobileNumberController.text =
                                              '';

                                          centereEmailController.text = '';

                                          latitude = null;
                                          longitude = null;

                                          StatusAlert.show(
                                            context,
                                            duration: Duration(seconds: 2),
                                            title: 'Center added',
                                            subtitle:
                                                'Center has been added successfully',
                                            configuration: IconConfiguration(
                                                icon: Icons.done),
                                          );
                                        } else {
                                          StatusAlert.show(
                                            context,
                                            duration: Duration(seconds: 3),
                                            title: 'Incorrect Data',
                                            subtitle:
                                                'Please check your input information again',
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

                      //new box
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
