import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mission_rakshak/components/auth_components.dart';
import 'package:mission_rakshak/components/loading_screen.dart';
import 'package:mission_rakshak/styles/colors.dart';
import 'package:mission_rakshak/components/top_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:status_alert/status_alert.dart';

import '../Database/Userdata.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage(this.data);
  final Map<String, dynamic> data;
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  double latitude;
  double longitude;

  final _formKey2 = GlobalKey<FormState>();

  bool _isBusy = false;

  updateData(UserDatabase database) async {
    if (!widget.data["donatedBefore"]) {
      await database.updateUnauthorizedUserDataFromProfilePage(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        mobileNumber: mobileNumberController.text,
        address: addressController.text,
        latitude: latitude,
        longitude: longitude,
        oldFirstName: oldFirstName,
        oldLastName: oldLastName,
        oldMobileNumber: oldMobileNumber,
        DOB: widget.data['DOB'],
        bloodType: widget.data['bloodType'],
      );
    } else {
      await database.updateVerifiedUserDataFromProfilePage(
        mobileNumber: mobileNumberController.text,
        address: addressController.text,
        oldMobileNumber: oldMobileNumber,
        firstName: oldFirstName,
        lastName: oldLastName,
        DOB: widget.data['DOB'],
        bloodType: widget.data['bloodType'],
        latitude: latitude,
        longitude: longitude,
      );
      return true;
    }
  }

  String getDOBText(dateOfBirth) {
    if (dateOfBirth == null) {
      return 'DD/MM/YY';
    } else
      return dateOfBirth.day.toString() +
          "/" +
          dateOfBirth.month.toString() +
          "/" +
          dateOfBirth.year.toString();
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

  String oldFirstName;
  String oldLastName;
  String oldMobileNumber;

  @override
  void initState() {
    firstNameController.text = widget.data['firstName'];
    lastNameController.text = widget.data['lastName'];
    mobileNumberController.text = widget.data['mobileNumber'];
    addressController.text = widget.data['address'];

    oldFirstName = widget.data['firstName'];
    oldLastName = widget.data['lastName'];
    oldMobileNumber = widget.data['mobileNumber'];

    latitude = widget.data['location'].latitude;
    longitude = widget.data['location'].longitude;
    super.initState();
  }

  ifVerified(bol) {
    if (!bol) {
      return Column(
        children: [
          FormText(
            icon: Icons.person,
            hintText: 'First Name',
            controller: firstNameController,
            type: TextInputType.name,
            shouldObscure: false,
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
            height: 5,
          ),
          FormText(
            icon: Icons.person,
            hintText: 'Last Name',
            controller: lastNameController,
            type: TextInputType.name,
            shouldObscure: false,
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
            height: 5,
          ),
        ],
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _isBusy
            ? Loading()
            : SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 20.0, left: 20, right: 20, bottom: 13),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          TopBar(
                              widget.data['bloodType'],
                              widget.data['firstName'],
                              widget.data['donatedBefore']),

                          //2. The 3 cards showing initial information:-
                          DisplayInformation(
                              '${widget.data['firstName']} ${widget.data['lastName']}',
                              Icons.person),
                          DisplayInformation(
                              widget.data['emailId'], Icons.email_rounded),
                          DisplayInformation(
                            widget.data['mobileNumber'] != ''
                                ? widget.data['mobileNumber']
                                : 'we don\'t have your number',
                            Icons.phone_android,
                          ),
                          DisplayInformation(
                              widget.data['address'], Icons.home),

                          //TODO: display DOB
                          // the name is DOB so data['DOB']
                          DisplayInformation(
                            getDOBText(DateTime.fromMillisecondsSinceEpoch(
                                widget.data['DOB'].seconds * 1000)),
                            // "DD/MM/YY",
                            Icons.date_range,
                          ),

                          SizedBox(
                            height: 25.0,
                          ),

                          //3. "Update Information"
                          Text(
                            'Update Information',
                            style: TextStyle(
                              fontSize: 23.0,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),

                          //4. The Form.

                          //replace the existing user data for a given user.
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Form(
                              autovalidateMode: AutovalidateMode.always,
                              key: _formKey2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  //firstName and lastName

                                  ifVerified(widget.data['donatedBefore']),

                                  FormText(
                                    icon: Icons.phone,
                                    hintText: 'Phone Number',
                                    controller: mobileNumberController,
                                    type: TextInputType.phone,
                                    shouldObscure: false,
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
                                    height: 5,
                                  ),

                                  FormText(
                                    icon: Icons.home,
                                    hintText: 'Address',
                                    controller: addressController,
                                    shouldObscure: false,
                                    type: TextInputType.name,
                                    validFunc: (value) {
                                      if (value.length < 1) {
                                        return 'Address can\'t be empty';
                                      }
                                      if (value.length > 100) {
                                        return "Address cant be greater than 100 characters";
                                      } else
                                        return null;
                                    },
                                  ),

                                  SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),

                          //5. "Change Address" button.
                          Container(
                            // margin: EdgeInsets.only(left: 14),
                            child: Padding(
                              padding: MediaQuery.of(context).size.width > 340
                                  ? EdgeInsets.fromLTRB(0.0, 0.0, 100.0, 0.0)
                                  : EdgeInsets.fromLTRB(0.0, 0.0, 150.0, 0.0),
                              child: TextButton(
                                onPressed: () async {
                                  LocationPermission permission =
                                      await Geolocator.checkPermission();
                                  if (permission == LocationPermission.denied) {
                                    permission =
                                        await Geolocator.requestPermission();
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
                                                      Navigator.pop(
                                                          context, 'Cancel');
                                                    },
                                                    child: const Text('Cancel'),
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
                                      return Future.error(
                                          'Location permissions are denied');
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
                                                  child: const Text('Cancel'),
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
                                    // return Future.error(
                                    //     'Location permissions are permanently denied, we cannot request permissions.');
                                  }

                                  // When we reach here, permissions are granted and we can
                                  // continue accessing the position of the device.
                                  else {
                                    setState(() {
                                      _isBusy = true;
                                    });
                                    Position position = await getLocation();
                                    //     await Geolocator.getCurrentPosition(
                                    //             desiredAccuracy:
                                    //                 LocationAccuracy.high)
                                    //         .then((value) {
                                    //   setState(() {
                                    //     _isBusy = false;
                                    //   });
                                    //   return value;
                                    // });
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
                                        subtitle: 'Location received',
                                        configuration:
                                            IconConfiguration(icon: Icons.done),
                                      );
                                    }
                                  }
                                },
                                child: Text(
                                  '  Change Your Home Location  ',
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(red),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 25.0,
                          ),

                          //6. "Update" button.
                          SizedBox(
                            height: 50.0,
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () async {
                                firstNameController.text =
                                    firstNameController.text.toLowerCase();
                                lastNameController.text =
                                    lastNameController.text.toLowerCase();

                                lastNameController.text =
                                    lastNameController.text.trim();
                                firstNameController.text =
                                    firstNameController.text.trim();
                                mobileNumberController.text =
                                    mobileNumberController.text.trim();
                                addressController.text =
                                    addressController.text.trim();

                                if (latitude == null ||
                                    latitude == 0.0 ||
                                    longitude == null ||
                                    longitude == 0.0) {
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
                                                  Navigator.pop(context, 'Ok');
                                                },
                                                child: const Text('Ok'),
                                              ),
                                            ],
                                          ));
                                } else if (_formKey2.currentState.validate()) {
                                  UserDatabase database = UserDatabase(
                                      FirebaseAuth.instance.currentUser);
                                  bool temp = false;
                                  temp = await updateData(database);
                                  Navigator.pushReplacementNamed(
                                      context, "/auth");
                                } else {
                                  StatusAlert.show(
                                    context,
                                    duration: Duration(seconds: 3),
                                    title: 'Incorrect Data',
                                    subtitle:
                                        'Name, address, or mobile number is incorrect',
                                    configuration:
                                        IconConfiguration(icon: Icons.error),
                                  );
                                }
                              },
                              child: Text(
                                'Update',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(red),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class DisplayInformation extends StatelessWidget {
  DisplayInformation(this.text, this.icon);
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      color: Colors.white,
      margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.black,
          size: 25.0,
        ),
        title: Text(
          text != '' ? text : 'we don\'t have your information',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
