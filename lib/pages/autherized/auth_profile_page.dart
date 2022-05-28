import 'package:flutter/material.dart';
import 'package:mission_rakshak/components/auth_components.dart';
import 'package:mission_rakshak/components/loading_screen.dart';
import 'package:mission_rakshak/styles/colors.dart';
import 'package:mission_rakshak/components/top_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:status_alert/status_alert.dart';
import 'package:mission_rakshak/Database/Userdata.dart';

class AuthProfilePage extends StatefulWidget {
  AuthProfilePage(this.data, this.centerData);
  final Map<String, dynamic> data;
  final Map<String, dynamic> centerData;
  @override
  _AuthProfilePageState createState() => _AuthProfilePageState();
}

class _AuthProfilePageState extends State<AuthProfilePage> {
  // final TextEditingController firstNameController = TextEditingController();
  // final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();

  final _formKey6 = GlobalKey<FormState>();

  Future<bool> updateData(UserDatabase database) async {
    await database.updateAuthorizedUserDataFromProfilePage(
      mobileNumber: mobileNumberController.text,
      centerName: centerNameDropDownVal,
      firstName: widget.data['firstName'],
      lastName: widget.data['lastName'],
      oldMobileNumber: oldMobileNumber,
      oldCenterName: oldCenterName,
    );
    return true;
  }

  String oldMobileNumber;
  String oldCenterName;

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
    mobileNumberController.text = widget.data['mobileNumber'];
    oldMobileNumber = widget.data['mobileNumber'];
    oldCenterName = widget.data['centerName'];

    centerDataLoc = widget.centerData['center_location'];
    centerNames = getCenters();
    centerNameDropDownVal = widget.data['centerName'];
    dropDownCenterNames = getDropDownCenterNames();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding:
                EdgeInsets.only(top: 20.0, left: 20, right: 20, bottom: 13),
            child: Column(
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
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
                ]),
                Column(
                  children: [
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
                        key: _formKey6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
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
                              height: 10,
                            ),
                            Container(
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
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
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
                          if (_formKey6.currentState.validate()) {
                            UserDatabase database =
                                UserDatabase(FirebaseAuth.instance.currentUser);
                            bool temp = await updateData(database);
                            Navigator.pushReplacementNamed(context, "/auth");
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
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
