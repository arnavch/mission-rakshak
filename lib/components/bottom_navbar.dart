import 'package:flutter/material.dart';
import 'package:mission_rakshak/components/address.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:mission_rakshak/styles/colors.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar(this.cIndex, this.func);
  final int cIndex;
  final Function func;

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  void _pageChange(int index) {
    // just remove this if statement when the location and profile pages are made and connected

    if (index == 1) {
      index = 0;
    }
  }

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
            icon: Icon(Icons.home),
            title: Text(
              'Home',
              style: TextStyle(fontFamily: 'Montserrat'),
            ),
            activeColor: Colors.white,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.room),
            textAlign: TextAlign.center,
            title: Text(
              'Location',
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
            icon: Icon(Icons.opacity_rounded),
            textAlign: TextAlign.center,
            title: Text(
              'Blood',
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
          ),
        ]);
  }
}

// BottomNavigationBar(
// items: const <BottomNavigationBarItem>[
// BottomNavigationBarItem(
// icon: Icon(Icons.home),
// label: 'Home',
// backgroundColor: Colors.red,
// ),
// BottomNavigationBarItem(
// icon: Icon(Icons.room),
// label: 'location',
// backgroundColor: Colors.red,
// ),
// BottomNavigationBarItem(
// icon: Icon(Icons.account_circle),
// label: 'Profile',
// backgroundColor: Colors.red,
// ),
// BottomNavigationBarItem(
// icon: Icon(Icons.settings),
// label: 'Settings',
// backgroundColor: Colors.red,
// ),
// ],
// currentIndex: widget.cIndex,
// onTap: (int index) {
// widget.func(index);
// },
//
// // can change color of the icon when selected instead of white. but white goes with the theme..........
//
// //selectedItemColor: ,
// );
