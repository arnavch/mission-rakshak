import 'package:mission_rakshak/components/auth_components.dart';
import 'package:mission_rakshak/styles/colors.dart';
import 'package:mission_rakshak/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:status_alert/status_alert.dart';
import 'package:mission_rakshak/Database/Userdata.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthInputPage extends StatefulWidget {
  AuthInputPage(this.centerData);
  Map<String, dynamic> centerData;
  @override
  _AuthInputPageState createState() => _AuthInputPageState();
}

class _AuthInputPageState extends State<AuthInputPage> {
  TextEditingController firstName = new TextEditingController();
  TextEditingController lastName = new TextEditingController();
  TextEditingController mobileNumber = new TextEditingController();
  TextEditingController centerName = new TextEditingController();

  // checkbox checking variable -- connected
  bool isDataCorrect = false;

// database

  final _formKey5 = GlobalKey<FormState>();

  UserDatabase data = UserDatabase(FirebaseAuth.instance.currentUser);

//TODO: idk but could have to convert DOB into string
  writeUserData() {
    data.updateAuthorizedUserDataFromSignIn(
      firstName: firstName.text,
      lastName: lastName.text,
      mobileNumber: mobileNumber.text,
      centerName: centerNameDropDownVal,
    );
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

  @override
  void initState() {
    centerDataLoc = widget.centerData['center_location'];
    centerNames = getCenters();
    centerNameDropDownVal = centerNames[0];
    dropDownCenterNames = getDropDownCenterNames();
    super.initState();
    // data.createUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE94139),
      body: SafeArea(
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
                          'We need your info',
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
                          key: _formKey5,
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
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 0),
                                child: Container(
                                  height: 60,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
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
                                          canvasColor: Color(0xFFE94139),
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
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w200),
                                          ),
                                          onChanged: (val) {
                                            setState(() {
                                              centerNameDropDownVal = val;
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              // FormText(
                              //   icon: Icons.home,
                              //   hintText: 'your center name',
                              //   controller: centerName,
                              //   shouldObscure: false,
                              //   type: TextInputType.name,
                              //   validFunc: (value) {
                              //     if (value.length < 1) {
                              //       return 'Center name can\'t be empty';
                              //     }
                              //     if (value.length > 50) {
                              //       return "Center name can\'t be greater than 50 characters";
                              //     } else
                              //       return null;
                              //   },
                              // ),
                              SizedBox(
                                height: 10,
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

                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        child: ActionButton(
                            text: 'Continue',
                            enabled: isDataCorrect,
                            onPressed: () {
                              lastName.text = lastName.text.trim();
                              firstName.text = firstName.text.trim();
                              firstName.text = firstName.text.toLowerCase();
                              lastName.text = lastName.text.toLowerCase();
                              centerName.text = centerName.text.trimRight();
                              centerName.text = centerName.text.toLowerCase();
                              print('here');
                              if (_formKey5.currentState.validate()) {
                                print('here2');
                                // if the data is correct

                                writeUserData();
                                Navigator.pushReplacementNamed(
                                    context, "/auth");
                              } else {
                                StatusAlert.show(
                                  context,
                                  duration: Duration(seconds: 3),
                                  title: 'Incorrect Data',
                                  subtitle:
                                      'Name, center name, or mobile number is incorrect',
                                  configuration:
                                      IconConfiguration(icon: Icons.error),
                                );
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
