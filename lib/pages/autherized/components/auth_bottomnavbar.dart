import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:mission_rakshak/styles/colors.dart';

class AuthBottomNavbar extends StatefulWidget {
  AuthBottomNavbar(this.cIndex, this.func);
  final int cIndex;
  final Function func;

  @override
  _AuthBottomNavbarState createState() => _AuthBottomNavbarState();
}

class _AuthBottomNavbarState extends State<AuthBottomNavbar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavyBar(
        selectedIndex: widget.cIndex,
        animationDuration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        showElevation: false, // use this to remove appBar's elevation
        backgroundColor: red,
        onItemSelected: (int index) {
          widget.func(index);
        },
        items: [
          BottomNavyBarItem(
            textAlign: TextAlign.center,
            icon: Icon(Icons.add_moderator),
            title: Text(
              'Accounts',
              style: TextStyle(fontFamily: 'Montserrat'),
            ),
            activeColor: Colors.white,
          ),
          // BottomNavyBarItem(
          //   textAlign: TextAlign.center,
          //   icon: Icon(Icons.add_business_outlined),
          //   title: Text(
          //     'Centers',
          //     style: TextStyle(fontFamily: 'Montserrat'),
          //   ),
          //   activeColor: Colors.white,
          // ),
          BottomNavyBarItem(
            icon: Icon(Icons.qr_code_scanner),
            textAlign: TextAlign.center,
            title: Text(
              'ScanQR',
              style: TextStyle(fontFamily: 'Montserrat'),
            ),
            activeColor: Colors.white,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.account_circle),
            textAlign: TextAlign.center,
            title: Text(
              'Profile',
              style: TextStyle(fontFamily: 'Montserrat'),
            ),
            activeColor: Colors.white,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.settings),
            textAlign: TextAlign.center,
            title: Text(
              'Settings',
              style: TextStyle(fontFamily: 'Montserrat'),
            ),
            activeColor: Colors.white,
          )
        ]);
  }
}

class WorkerAuthBottomNavbar extends StatefulWidget {
  WorkerAuthBottomNavbar(this.cIndex, this.func);
  final int cIndex;
  final Function func;

  @override
  _WorkerAuthBottomNavbarState createState() => _WorkerAuthBottomNavbarState();
}

class _WorkerAuthBottomNavbarState extends State<WorkerAuthBottomNavbar> {
  @override
  @override
  Widget build(BuildContext context) {
    return BottomNavyBar(
        selectedIndex: widget.cIndex,
        animationDuration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        showElevation: false, // use this to remove appBar's elevation
        backgroundColor: red,
        onItemSelected: (int index) {
          widget.func(index);
        },
        items: [
          // BottomNavyBarItem(
          //   textAlign: TextAlign.center,
          //   icon: Icon(Icons.add_moderator),
          //   title: Text(
          //     'Accounts',
          //     style: TextStyle(fontFamily: 'Montserrat'),
          //   ),
          //   activeColor: Colors.white,
          // ),
          // BottomNavyBarItem(
          //   textAlign: TextAlign.center,
          //   icon: Icon(Icons.add_business_outlined),
          //   title: Text(
          //     'Centers',
          //     style: TextStyle(fontFamily: 'Montserrat'),
          //   ),
          //   activeColor: Colors.white,
          // ),
          BottomNavyBarItem(
            icon: Icon(Icons.qr_code_scanner),
            textAlign: TextAlign.center,
            title: Text(
              'ScanQR',
              style: TextStyle(fontFamily: 'Montserrat'),
            ),
            activeColor: Colors.white,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.account_circle),
            textAlign: TextAlign.center,
            title: Text(
              'Profile',
              style: TextStyle(fontFamily: 'Montserrat'),
            ),
            activeColor: Colors.white,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.settings),
            textAlign: TextAlign.center,
            title: Text(
              'Settings',
              style: TextStyle(fontFamily: 'Montserrat'),
            ),
            activeColor: Colors.white,
          )
        ]);
  }
}
