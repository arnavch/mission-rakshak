import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mission_rakshak/Database/Userdata.dart';
import 'package:mission_rakshak/components/auth_components.dart';
import 'package:mission_rakshak/components/error_messages.dart';
import 'package:mission_rakshak/components/loading_screen.dart';
import 'package:mission_rakshak/styles/colors.dart';
import 'package:mission_rakshak/styles/text_styles.dart';
import 'package:status_alert/status_alert.dart';

class AuthDashboard extends StatefulWidget {
  // AuthDashboard(this.data);
  // Map<String, dynamic> data;
  @override
  _AuthDashboardState createState() => _AuthDashboardState();
}

class _AuthDashboardState extends State<AuthDashboard> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  double latitude;
  double longitude;

  //final TextEditingController centereEmailController = TextEditingController();
  //final TextEditingController centereNameController = TextEditingController();
  //final TextEditingController centereAddressController =
  //    TextEditingController();
  // final TextEditingController centereMobileNumberController =
  //    TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final _formKey3 = GlobalKey<FormState>();

  //final _formKey6 = GlobalKey<FormState>();

  bool isUserAuth = false;
  bool isUserWorker = false;

  String error;

  bool _isBusy = false;

  getErrorMessage(e, message) {
    setState(() {
      error = CorrectMessages.getErrorMessageForSignIn(e, message);
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
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: red,
      body: SafeArea(
        child: _isBusy
            ? Loading()
            : Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
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
                                ]),

                            SizedBox(
                              height: 20,
                            ),

                            Container(
                              margin: EdgeInsets.only(bottom: 30),
                              child: Text(
                                'Create An Account',
                                style: authTitleTextStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Form(
                                autovalidateMode: AutovalidateMode.always,
                                key: _formKey3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FormText(
                                      icon: Icons.mail,
                                      hintText: 'Email',
                                      controller: emailController,
                                      type: TextInputType.emailAddress,
                                      shouldObscure: false,
                                      validFunc: (value) {
                                        if (value.isEmpty) {
                                          return "Email cant be empty";
                                        } else
                                          return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    FormText(
                                      icon: Icons.lock,
                                      hintText: 'Password',
                                      controller: passwordController,
                                      type: TextInputType.text,
                                      shouldObscure: true,
                                      validFunc: (value) {
                                        if (value.isEmpty) {
                                          return "password cant be empty";
                                        } else if (value.length < 8) {
                                          return 'Password length should be at least 8';
                                        } else
                                          return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    FormText(
                                      icon: Icons.lock,
                                      hintText: 'Confirm Password',
                                      controller: confirmPasswordController,
                                      shouldObscure: true,
                                      type: TextInputType.text,
                                      validFunc: (value) {
                                        if (value.isEmpty) {
                                          return "password cant be empty";
                                        }
                                        if (confirmPasswordController.text !=
                                            passwordController.text) {
                                          return 'passwords don\'t match';
                                        } else
                                          return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Authorized Account?',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: red,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Switch(
                                          value: isUserAuth,
                                          onChanged: (value) {
                                            if (isUserAuth) {
                                              setState(() {
                                                isUserAuth = false;
                                                isUserWorker = false;
                                              });
                                            } else {
                                              showDialog<String>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                  title: const Text(
                                                      'Are you sure?'),
                                                  content: const Text(
                                                      'Are you sure you want to make this user admin?'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          isUserAuth = false;
                                                        });
                                                        Navigator.pop(
                                                            context, 'Cancel');
                                                      },
                                                      child:
                                                          const Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          isUserAuth = true;
                                                          isUserWorker = false;
                                                        });
                                                        Navigator.pop(
                                                            context, 'Ok');
                                                      },
                                                      child: const Text('Yes'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                          },
                                          activeTrackColor: red,
                                          activeColor: Colors.redAccent,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Worker Account?',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: red,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Switch(
                                          value: isUserWorker,
                                          onChanged: (value) {
                                            if (isUserWorker) {
                                              setState(() {
                                                isUserWorker = false;
                                                isUserAuth = false;
                                              });
                                            } else {
                                              showDialog<String>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                  title: const Text(
                                                      'Are you sure?'),
                                                  content: const Text(
                                                      'Are you sure you want to make this user autherized?'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          isUserWorker = false;
                                                        });
                                                        Navigator.pop(
                                                            context, 'Cancel');
                                                      },
                                                      child:
                                                          const Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          isUserWorker = true;
                                                          isUserAuth = false;
                                                        });
                                                        Navigator.pop(
                                                            context, 'Ok');
                                                      },
                                                      child: const Text('Yes'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                          },
                                          activeTrackColor: red,
                                          activeColor: Colors.redAccent,
                                        ),
                                      ],
                                    ),
                                    error == null
                                        ? Container(
                                            height: 0,
                                          )
                                        : Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: ErrorMessage(error),
                                          ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: 10, bottom: 10),
                                      child: ActionButton(
                                          text: 'Create account',
                                          enabled: true,
                                          onPressed: () async {
                                            if (_formKey3.currentState
                                                .validate()) {
                                              if (isUserWorker) {
                                                bool ok;
                                                String error_msg = '';
                                                String message = '';
                                                FirebaseApp app = await Firebase
                                                    .initializeApp(
                                                        name: 'Secondary',
                                                        options: Firebase.app()
                                                            .options);
                                                try {
                                                  UserCredential
                                                      userCredential =
                                                      await FirebaseAuth
                                                              .instanceFor(
                                                                  app: app)
                                                          .createUserWithEmailAndPassword(
                                                              email:
                                                                  emailController
                                                                      .text,
                                                              password:
                                                                  passwordController
                                                                      .text);
                                                  UserDatabase data =
                                                      UserDatabase(
                                                          userCredential.user);
                                                  await data.createWorkerUser();
                                                  await app.delete();

                                                  passwordController.text = '';
                                                  emailController.text = '';
                                                  confirmPasswordController
                                                      .text = '';

                                                  StatusAlert.show(
                                                    context,
                                                    duration:
                                                        Duration(seconds: 2),
                                                    title: 'Account Created',
                                                    subtitle:
                                                        'Account has been successfully created',
                                                    configuration:
                                                        IconConfiguration(
                                                            icon: Icons.done),
                                                  );
                                                } on FirebaseAuthException catch (e) {
                                                  print(e);
                                                  error_msg = e.code;
                                                  message = e.message;
                                                  print(error_msg);
                                                  ok = false;
                                                } finally {
                                                  if (ok) {
                                                    print('made user');
                                                  } else {
                                                    getErrorMessage(
                                                        error_msg, message);
                                                    await app.delete();
                                                  }
                                                }
                                              } else if (isUserAuth) {
                                                bool ok;
                                                String error_msg = '';
                                                String message = '';
                                                FirebaseApp app = await Firebase
                                                    .initializeApp(
                                                        name: 'Secondary',
                                                        options: Firebase.app()
                                                            .options);
                                                try {
                                                  UserCredential
                                                      userCredential =
                                                      await FirebaseAuth
                                                              .instanceFor(
                                                                  app: app)
                                                          .createUserWithEmailAndPassword(
                                                              email:
                                                                  emailController
                                                                      .text,
                                                              password:
                                                                  passwordController
                                                                      .text);
                                                  UserDatabase data =
                                                      UserDatabase(
                                                          userCredential.user);
                                                  if (isUserAuth) {
                                                    await data
                                                        .createAuthorizedUser();
                                                  }
                                                  await app.delete();

                                                  passwordController.text = '';
                                                  emailController.text = '';
                                                  confirmPasswordController
                                                      .text = '';

                                                  StatusAlert.show(
                                                    context,
                                                    duration:
                                                        Duration(seconds: 2),
                                                    title: 'Account Created',
                                                    subtitle:
                                                        'Account has been successfully created',
                                                    configuration:
                                                        IconConfiguration(
                                                            icon: Icons.done),
                                                  );
                                                } on FirebaseAuthException catch (e) {
                                                  print(e);
                                                  error_msg = e.code;
                                                  message = e.message;
                                                  print(error_msg);
                                                  ok = false;
                                                } finally {
                                                  if (ok) {
                                                    print('made user');
                                                  } else {
                                                    getErrorMessage(
                                                        error_msg, message);
                                                    await app.delete();
                                                  }
                                                }
                                              } else {
                                                bool ok;
                                                String error_msg = '';
                                                String message = '';
                                                FirebaseApp app = await Firebase
                                                    .initializeApp(
                                                        name: 'Secondary',
                                                        options: Firebase.app()
                                                            .options);
                                                try {
                                                  UserCredential
                                                      userCredential =
                                                      await FirebaseAuth
                                                              .instanceFor(
                                                                  app: app)
                                                          .createUserWithEmailAndPassword(
                                                              email:
                                                                  emailController
                                                                      .text,
                                                              password:
                                                                  passwordController
                                                                      .text);
                                                  UserDatabase data =
                                                      UserDatabase(
                                                          userCredential.user);
                                                  await data
                                                      .createUnauthorizedUser();
                                                  await app.delete();

                                                  passwordController.text = '';
                                                  emailController.text = '';
                                                  confirmPasswordController
                                                      .text = '';

                                                  StatusAlert.show(
                                                    context,
                                                    duration:
                                                        Duration(seconds: 2),
                                                    title: 'Account Created',
                                                    subtitle:
                                                        'Account has been successfully created',
                                                    configuration:
                                                        IconConfiguration(
                                                            icon: Icons.done),
                                                  );
                                                } on FirebaseAuthException catch (e) {
                                                  print(e);
                                                  error_msg = e.code;
                                                  message = e.message;
                                                  print(error_msg);
                                                  ok = false;
                                                } finally {
                                                  if (ok) {
                                                    print('made user');
                                                  } else {
                                                    getErrorMessage(
                                                        error_msg, message);
                                                    await app.delete();
                                                  }
                                                }
                                              }
                                            }
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 30,
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

// class CenterAddWidget extends StatelessWidget {
//   const CenterAddWidget({
//     Key key,
//     @required GlobalKey<FormState> formKey6,
//     @required this.centereNameController,
//     @required this.centereAddressController,
//     @required this.centereEmailController,
//     @required this.centereMobileNumberController,
//   })  : _formKey6 = formKey6,
//         super(key: key);
//
//   final GlobalKey<FormState> _formKey6;
//   final TextEditingController centereNameController;
//   final TextEditingController centereAddressController;
//   final TextEditingController centereEmailController;
//   final TextEditingController centereMobileNumberController;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 15),
//       child: Form(
//         autovalidateMode: AutovalidateMode.always,
//         key: _formKey6,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             FormText(
//               icon: Icons.apartment,
//               hintText: 'Center name',
//               controller: centereNameController,
//               type: TextInputType.text,
//               shouldObscure: false,
//               validFunc: (value) {
//                 if (value.isEmpty) {
//                   return "center name cant be empty";
//                 } else if (value.length > 50) {
//                   return 'center name length should be lower than 50';
//                 } else
//                   return null;
//               },
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             FormText(
//               icon: Icons.home,
//               hintText: 'Address',
//               controller: centereAddressController,
//               type: TextInputType.text,
//               shouldObscure: false,
//               validFunc: (value) {
//                 if (value.isEmpty) {
//                   return "Address can\t be empty";
//                 } else if (value.length > 200) {
//                   return 'Address length should be lower than 200';
//                 } else
//                   return null;
//               },
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             FormText(
//               icon: Icons.mail,
//               hintText: 'Email',
//               controller: centereEmailController,
//               shouldObscure: false,
//               type: TextInputType.emailAddress,
//               validFunc: (value) {
//                 if (value.isEmpty) {
//                   return "Email can\t be empty";
//                 } else
//                   return null;
//               },
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             FormText(
//               icon: Icons.phone,
//               hintText: 'Mobile Number',
//               controller: centereMobileNumberController,
//               shouldObscure: false,
//               type: TextInputType.phone,
//               validFunc: (value) {
//                 if (value.length < 8) {
//                   return 'Need a valid mobile number';
//                 }
//                 if (value.length > 10) {
//                   return "Mobile Number cant be greater than 10";
//                 } else
//                   return null;
//               },
//             ),
//             SizedBox(
//               height: 10,
//             ),
//
//             Container(
//               margin: EdgeInsets.only(top: 5),
//               width: 250,
//               height: 33,
//               child: Material(
//                 color: Color(0xFFE94139),
//                 borderRadius: BorderRadius.circular(15.0),
//                 child: MaterialButton(
//                   onPressed: () async {
//                     LocationPermission permission =
//                     await Geolocator.checkPermission();
//                     if (permission ==
//                         LocationPermission.denied) {
//                       permission = await Geolocator
//                           .requestPermission();
//                       if (permission ==
//                           LocationPermission.denied) {
//                         showDialog<String>(
//                             context: context,
//                             builder: (BuildContext context) =>
//                                 AlertDialog(
//                                   title: const Text(
//                                       'You have denied permission'),
//                                   content: const Text(
//                                       'Please allow permission so we can get your location'),
//                                   actions: <Widget>[
//                                     TextButton(
//                                       onPressed: () {
//                                         Navigator.pop(context,
//                                             'Cancel');
//                                       },
//                                       child: const Text(
//                                           'Cancel'),
//                                     ),
//                                     TextButton(
//                                       onPressed: () {
//                                         Navigator.pop(
//                                             context, 'Ok');
//                                       },
//                                       child: const Text('Ok'),
//                                     ),
//                                   ],
//                                 ));
//                         return Future.error(
//                             'Location permissions are denied');
//                       }
//                     }
//
//                     if (permission ==
//                         LocationPermission.deniedForever) {
//                       // Permissions are denied forever, handle appropriately.
//                       showDialog<String>(
//                           context: context,
//                           builder: (BuildContext context) =>
//                               AlertDialog(
//                                 title: const Text(
//                                     'You have denied permission forever'),
//                                 content: const Text(
//                                     'To get location you will have to allow permission from settings'),
//                                 actions: <Widget>[
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.pop(
//                                           context, 'Cancel');
//                                     },
//                                     child:
//                                     const Text('Cancel'),
//                                   ),
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.pop(
//                                           context, 'Ok');
//                                     },
//                                     child: const Text('Ok'),
//                                   ),
//                                 ],
//                               ));
//                       // return Future.error(
//                       //     'Location permissions are permanently denied, we cannot request permissions.');
//                     }
//
//                     // When we reach here, permissions are granted and we can
//                     // continue accessing the position of the device.
//                     Position position =
//                     await Geolocator.getCurrentPosition(
//                         desiredAccuracy:
//                         LocationAccuracy.high);
//                     latitude = position.latitude;
//                     longitude = position.longitude;
//                     print(latitude);
//                     print(longitude);
//                   },
//
//                   child: Text(
//                     'Get Current Location',
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontFamily: 'Montserrat',
//                       color: Colors.white,
//                       fontWeight: FontWeight.w800,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//             // error == null
//             //     ? Container(
//             //         height: 0,
//             //       )
//             //     : Padding(
//             //         padding: const EdgeInsets.only(top: 10),
//             //         child: ErrorMessage(error),
//             //       ),
//             Container(
//               margin: EdgeInsets.only(top: 10, bottom: 10),
//               child: ActionButton(
//                   text: 'Add Center',
//                   enabled: true,
//                   onPressed: () async {
//                     centereNameController.text =
//                         centereNameController.text.trimRight();
//                     centereNameController.text =
//                         centereNameController.text.toLowerCase();
//
//                     centereAddressController.text =
//                         centereAddressController.text.trimRight();
//
//                     centereMobileNumberController.text =
//                         centereMobileNumberController.text.trimRight();
//
//                     centereEmailController.text =
//                         centereEmailController.text.trimRight();
//                     centereEmailController.text =
//                         centereEmailController.text.toLowerCase();
//
//                     if (_formKey6.currentState.validate()) {
//                       await CenterData.createBloodDonationCenter(
//                         name: centereNameController.text,
//                         address: centereAddressController.text,
//                         mobileNumber: centereMobileNumberController.text,
//                         emailId: centereEmailController.text,
//                       );
//                       centereNameController.text = '';
//
//                       centereAddressController.text = '';
//
//                       centereMobileNumberController.text = '';
//
//                       centereEmailController.text = '';
//
//                       StatusAlert.show(
//                         context,
//                         duration: Duration(seconds: 2),
//                         title: 'Center added',
//                         subtitle: 'Center has been added successfully',
//                         configuration: IconConfiguration(icon: Icons.done),
//                       );
//                     } else {
//                       StatusAlert.show(
//                         context,
//                         duration: Duration(seconds: 3),
//                         title: 'Incorrect Data',
//                         subtitle: 'Please check your input information again',
//                         configuration: IconConfiguration(icon: Icons.error),
//                       );
//                     }
//                   }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
