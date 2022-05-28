import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mission_rakshak/components/auth_components.dart';
import 'package:mission_rakshak/components/error_messages.dart';
import 'package:mission_rakshak/styles/colors.dart';
import 'package:mission_rakshak/styles/text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen(this.func, this.func2);
  final Function func;
  final Function func2;
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  String error;

  getErrorMessage(e, message) {
    setState(() {
      error = CorrectMessages.getErrorMessageForLogin(e, message);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool ok = true;
    dynamic error_msg;
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
        backgroundColor: Color(0xFFE94139),
        body: SafeArea(
          child: Column(
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Image.asset(
                              'assets/images/illustrations/auth.png'),
                          width: 400,
                          height: MediaQuery.of(context).size.height * 2 / 10,
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 30),
                          child: Text(
                            'Welcome Back!',
                            style: TextStyle(
                              fontSize: 30,
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
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
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
                                  height: 20,
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
                                    } else
                                      return null;
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),

                        //LOGIN BUTTON

                        error == null
                            ? Container(
                                height: 0,
                              )
                            : ErrorMessage(error),

                        Container(
                          margin: EdgeInsets.only(top: 10, bottom: 10),
                          child: ActionButton(
                            text: 'Login',
                            enabled: true,
                            onPressed: () async {
                              String errorMessaage = '';
                              if (_formKey.currentState.validate()) {
                                try {
                                  await _firebaseAuth
                                      .signInWithEmailAndPassword(
                                          email: emailController.text,
                                          password: passwordController.text);
                                  ok = true;
                                } on FirebaseAuthException catch (e) {
                                  print(e);
                                  error_msg = e.code;
                                  errorMessaage = e.message;
                                  print(error_msg);
                                  ok = false;
                                } finally {
                                  if (ok) {
                                    // Navigator.pushReplacementNamed(
                                    //     context, "/auth");
                                  } else {
                                    getErrorMessage(error_msg, errorMessaage);
                                    // Fluttertoast.showToast(
                                    //     msg: error_msg,
                                    //     toastLength: Toast.LENGTH_SHORT,
                                    //     gravity: ToastGravity.BOTTOM,
                                    //     timeInSecForIosWeb: 1,
                                    //     backgroundColor: Colors.red,
                                    //     textColor: Colors.white,
                                    //     fontSize: 16.0);
                                    // print('try again');
                                  }
                                }
                              }
                            },
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 15, top: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFFE94139),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      //horizontal: 5,
                                      ),
                                  child: Material(
                                    elevation: 6.0,
                                    color: red,
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: Container(
                                      child: MaterialButton(
                                        onPressed: () {
                                          widget.func2();
                                        },
                                        child: Text(
                                          'Forgot Password?',
                                          style: smallerActionButtonTextStyle,
                                        ),
                                      ),
                                      width: 170.0,
                                      height: 40.0,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'New here? Create Your Account',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFFE94139),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                top: 10,
                                bottom: 10,
                                left: 8,
                              ),
                              child: SmallerActionButton(
                                text: 'Sign Up',
                                enabled: true,
                                onPressed: () {
                                  // Navigator.pushReplacementNamed(
                                  //     context, "/signup");
                                  widget.func();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

//
// Container(
// margin: EdgeInsets.only(top: 15),
// child: Text(
// 'OR',
// textAlign: TextAlign.center,
// style: TextStyle(
// fontSize: 20,
// fontWeight: FontWeight.w800,
// ),
// ),
// ),
// Container(
// margin: EdgeInsets.only(bottom: 20),
// child: Text(
// 'Sign Up With',
// textAlign: TextAlign.center,
// style: TextStyle(
// fontSize: 25,
// fontWeight: FontWeight.w400,
// wordSpacing: 0.5,
// color: Colors.black54),
// ),
// ),

// // THE FOUR ICON BUTTONS
//
// Container(
// margin: EdgeInsets.only(bottom: 10),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// AlternateAuthMethodButton(
// imagePath: 'assets/images/auth/google.png'),
// SizedBox(
// width: 20,
// ),
// AlternateAuthMethodButton(
// imagePath: 'assets/images/auth/apple.png'),
// SizedBox(
// width: 20,
// ),
// AlternateAuthMethodButton(
// imagePath:
// 'assets/images/auth/microsoft.png'),
// SizedBox(
// width: 20,
// ),
// AlternateAuthMethodButton(
// imagePath: 'assets/images/auth/facebook.png'),
// ],
// ),
// )
// ],
// ),
// ),
