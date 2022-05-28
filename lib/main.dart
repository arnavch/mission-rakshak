import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mission_rakshak/pages/about_app.dart';

import 'package:mission_rakshak/pages/data_receiver.dart';
import 'package:mission_rakshak/pages/login_wrapper.dart';
import 'package:mission_rakshak/pages/sign_up_2.dart';
import 'package:mission_rakshak/pages/splash_screen.dart';

import 'pages/splash_screen.dart';

// Future<void> main(List<String> args) async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MaterialApp(
//     initialRoute: '/splash',
//     debugShowCheckedModeBanner: false,
//     routes: {
//       '/splash': (context) => SplashScreen(),
//       '/login': (context) => LoginScreen(),
//       '/signup': (context) => SignUpScreen(),
//       '/signupinfo': (context) => InputPage(),
//       //'/dash': (context) => DashBoard(),
//       '/settings': (context) => SettingsPage(),
//       '/dashboard': (context) => DashboardPage(),
//       '/profile': (context) => ProfilePage(),
//       '/dashboard_wrapper': (context) => DashboardWrapper(),
//       // '/account': (context) => AccountPage()
//       //test_---
//       '/auth': (context) => AuthenticationWrapper(),
//     },
//   ));
// }

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    (MyApp()),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', 'IN'),
      ],
      locale: Locale('en'),
      home: StartPage(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/splash': (context) => SplashScreen(),
        '/loginwrapper': (context) => LoginWrapper(),
        '/signupinfo': (context) => InputPage(),
        //'/dash': (context) => DashBoard(),
        // '/dashboard': (context) => DashboardPage(),
        // '/profile': (context) => ProfilePage(),
        '/dataReceiver': (context) => UserDataReceiver(),
        '/introduction': (context) => OnBoardingPage(),
        // '/account': (context) => AccountPage()
        //test_---
        '/auth': (context) => Root(),
      },
    );
  }
}

class StartPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Something Went wrong"),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Root();
        }
        //loading
        return Scaffold(
          body: Center(
            child: SplashScreen(),
          ),
        );
      },
    );
  }
}

// class AuthenticationWrapper extends StatelessWidget {
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   // FirebaseAuth.instance.authStateChanges().listen((User user) {
//   // if (user == null) {
//   // return LoginScreen();
//   // } else {
//   // return DashBoard();
//   // }
//   // });
//
//   Widget getCorrectPage() {
//     User user = auth.currentUser;
//     if (user == null) {
//       print('login');
//       return LoginWrapper();
//     } else {
//       print('dashboard');
//       return UserDataReceiver();
//     }
//   }
//
//   // final _authState = watch(authStateProvider);
//   // return _authState.when(
//   //   data: (value) {
//   //     if (value != null) {
//   //       return LoginScreen();
//   //     }
//   //     return DashboardWrapper();
//   //   },
//   //   loading: () {
//   //     return SplashScreen();
//   //   },
//   //   error: (_, __) {
//   //     return Scaffold(
//   //       body: Center(
//   //         child: Text("OOPS"),
//   //       ),
//   //     );
//   //   },
//   // );
//   // final firebaseUser = context.watch<User>();
//
//   //   if (firebaseUser == null) {
//   //     return InputPage();
//   //   }
//   //   return DashBoard();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return getCorrectPage();
//   }
// }

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<User> get user => _auth.authStateChanges();
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data?.uid == null) {
            return LoginWrapper();
          } else {
            return UserDataReceiver();
          }
        } else {
          return SplashScreen();
        }
      }, //Auth stream
    );
  }
}
