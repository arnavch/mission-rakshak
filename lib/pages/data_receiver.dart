import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mission_rakshak/Database/Userdata.dart';
import 'package:mission_rakshak/Database/centerData.dart';
import 'package:mission_rakshak/pages/Worker/auth_input_page.dart';
import 'package:mission_rakshak/pages/Worker/worker_auth_dashboard_wrapper.dart';
import 'package:mission_rakshak/pages/autherized/auth_dashboard_wrapper.dart';
import 'package:mission_rakshak/pages/autherized/auth_input_page.dart';
import 'package:mission_rakshak/pages/nointernet.dart';

import '../Database/Userdata.dart';
import 'dashboard_wrapper.dart';
import 'sign_up_2.dart';
import 'splash_screen.dart';

// dynamic data;
// getUserData() async {
//   data = await UserDatabase.userDataCollection
//       .doc(FirebaseAuth.instance.currentUser.uid)
//       .get();
//   data = data.data();
// }

// UserDatabase database=UserDatabase(FirebaseAuth.instance.currentUser.);

//
// String getUserName() {
//   return data.firstName;
// }

class UserDataReceiver extends StatefulWidget {
  @override
  _UserDataReceiverState createState() => _UserDataReceiverState();
}

class _UserDataReceiverState extends State<UserDataReceiver> {
  @override
  Widget build(BuildContext context) {
    Future<List<DocumentSnapshot>> getData() async {
      DocumentSnapshot userData = await UserDatabase.userDataCollection
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get();
      DocumentSnapshot centerData =
          await CenterData.centerDataCollection.doc('index').get();
      if (!centerData.exists) {
        return null;
      }
      return [userData, centerData];
    }

    return FutureBuilder<List<DocumentSnapshot>>(
      future: getData(),
      builder: (BuildContext context,
          AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasError) {
          return NoInternetPage();
        }

        if ((snapshot.hasData)) {
          List data = snapshot.data;
          if (!data[0].exists) {
            return InputPage();
          }
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == null) {
            return NoInternetPage();
          }
          List data = snapshot.data;
          Map<String, dynamic> userData = data[0].data();
          Map<String, dynamic> centerData = data[1].data();

          if (userData['authorized']) {
            if (userData['authLevel'] == 2) {
              if (userData['correctData']) {
                return AuthDashboardWrapper(userData, centerData);
              }
              return AuthInputPage(centerData);
            }
            if (userData['authLevel'] == 1) {
              if (userData['correctData']) {
                return WorkerAuthDashboardWrapper(userData, centerData);
              }
              return WorkerAuthInputPage(centerData);
            }
          }
          if (userData['correctData']) {
            if (userData['authorized']) {
              // return DashboardPage(data);
            }
            return DashboardWrapper(userData, centerData);
          }
          return InputPage();
        }

        return SplashScreen();
      },
    );
  }
}

// static Future<UserCredential> register(String email, String password) async {
// FirebaseApp app = await Firebase.initializeApp(
// name: 'Secondary', options: Firebase.app().options);
// try {
// UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
//     .createUserWithEmailAndPassword(email: email, password: password);
// }
// on FirebaseAuthException catch (e) {
// // Do something with exception. This try/catch is here to make sure
// // that even if the user creation fails, app.delete() runs, if is not,
// // next time Firebase.initializeApp() will fail as the previous one was
// // not deleted.
// }
//
// await app.delete();
// return Future.sync(() => userCredential);
// }

// class _UserDataReceiverState extends State<UserDataReceiver> {
//   Stream documentStream = UserDatabase.userDataCollection
//       .doc('FirebaseAuth.instance.currentUser.uid')
//       .snapshots();
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//         stream: documentStream,
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           if (snapshot.hasError) {
//             return Center(child: Text('Restart the app'));
//           }
//
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return SplashScreen();
//           } else {
//             print(snapshot.data.data());
//             List<DocumentSnapshot> data = snapshot.data.docs;
//             print(data);
//             if (!data[0].exists) {
//               return InputPage();
//             } else {
//               dynamic d = data[0].data();
//               if (data[d]['correctData']) {
//                 return DashboardWrapper(d);
//               }
//             }
//             return InputPage();
//           }
//         });
//   }
// }
