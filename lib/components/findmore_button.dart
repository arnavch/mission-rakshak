import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mission_rakshak/Database/centerData.dart';
import 'package:mission_rakshak/components/auth_components.dart';
import 'package:mission_rakshak/components/blood_request_cards.dart';
import 'package:mission_rakshak/styles/colors.dart';
import 'package:flutter/services.dart';

class FindMoreButton extends StatefulWidget {
  const FindMoreButton({
    Key key,
    @required this.centerName,
    @required this.userData,
  }) : super(key: key);

  final String centerName;
  final Map userData;

  @override
  _FindMoreButtonState createState() => _FindMoreButtonState();
}

class _FindMoreButtonState extends State<FindMoreButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: GestureDetector(
          child: Material(
            color: Colors.red,
            elevation: 10.0,
            shadowColor: altAuthShadowColor,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 7),
              height: 30.0,
              child: Text(
                'More Info',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontSize: 15,
                ),
              ),
            ),
          ),
          onTap: () async {
            DocumentSnapshot nearestRequestCenterDataSnapshot = await CenterData
                .centerDataCollection
                .doc(widget.centerName)
                .get();
            if (nearestRequestCenterDataSnapshot.exists) {
              Map nearestRequestCenterData =
                  nearestRequestCenterDataSnapshot.data();
              int distance = Geolocator.distanceBetween(
                      nearestRequestCenterData['location'].latitude,
                      nearestRequestCenterData['location'].longitude,
                      widget.userData['location'].latitude,
                      widget.userData['location'].longitude)
                  .toInt();
              showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return Container(
                      height: 600,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, bottom: 10),
                                child: Text(
                                  'Contact Us through',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: DisplayBloodRequestCard(
                                  distance: distance / 1000,
                                  nearestAddress:
                                      nearestRequestCenterData['address'],
                                  centerName: nearestRequestCenterData['name'],
                                  centerData: nearestRequestCenterData,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Contact Details',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize:
                                      MediaQuery.of(context).size.width > 340
                                          ? 20
                                          : 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              nearestRequestCenterData['contactName'] != null &&
                                      nearestRequestCenterData['contactName'] !=
                                          ""
                                  ? Container(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Name  :  ',
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      340
                                                  ? 20
                                                  : 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Flexible(
                                            child: SelectableText(
                                              nearestRequestCenterData[
                                                  'contactName'],
                                              style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: MediaQuery.of(context)
                                                            .size
                                                            .width >
                                                        340
                                                    ? 20
                                                    : 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : SizedBox(),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Mobile Number  :  ',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize:
                                            MediaQuery.of(context).size.width >
                                                    340
                                                ? 20
                                                : 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Flexible(
                                      child: SelectableText(
                                        nearestRequestCenterData[
                                            'mobileNumber'],
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  340
                                              ? 20
                                              : 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Email  :  ',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize:
                                            MediaQuery.of(context).size.width >
                                                    340
                                                ? 20
                                                : 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Flexible(
                                      child: SelectableText(
                                        nearestRequestCenterData['emailId'],
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  340
                                              ? 20
                                              : 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Container(
                                  margin: EdgeInsets.only(top: 10, bottom: 10),
                                  child: SmallerActionButton(
                                    text: 'Go Back',
                                    enabled: true,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            } else {
              showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: const Text('Error'),
                        content: const Text(
                            'There was an error while retrieving data. Please ensure that you have internet and try again'),
                        actions: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            child: SmallerActionButton(
                              text: 'Go Back',
                              enabled: true,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ));
            }
          }),
    );
  }
}

class FindMoreButtonWithData extends StatelessWidget {
  const FindMoreButtonWithData({
    Key key,
    @required this.nearestRequestCenterData,
    @required this.distance,
  }) : super(key: key);

  final Map<String, dynamic> nearestRequestCenterData;
  final double distance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: GestureDetector(
        child: Material(
          color: Colors.red,
          elevation: 10.0,
          shadowColor: altAuthShadowColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 7),
            height: 30.0,
            child: Text(
              'More Info',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontSize: 15,
              ),
            ),
          ),
        ),
        onTap: () {
          showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (BuildContext context) {
                return Container(
                  height: 600,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: Text(
                              'Contact Us through',
                              style: TextStyle(
                                fontSize: 30,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: DisplayBloodRequestCard(
                              distance: distance,
                              nearestAddress:
                                  nearestRequestCenterData['address'],
                              centerName: nearestRequestCenterData['name'],
                              centerData: nearestRequestCenterData,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Contact Details',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: MediaQuery.of(context).size.width > 340
                                  ? 20
                                  : 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          nearestRequestCenterData['contactName'] != null &&
                                  nearestRequestCenterData['contactName'] != ""
                              ? Container(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Name  :  ',
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  340
                                              ? 20
                                              : 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Flexible(
                                        child: SelectableText(
                                          nearestRequestCenterData[
                                              'contactName'],
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    340
                                                ? 20
                                                : 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : SizedBox(),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mobile Number  :  ',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize:
                                        MediaQuery.of(context).size.width > 340
                                            ? 20
                                            : 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Flexible(
                                  child: SelectableText(
                                    nearestRequestCenterData['mobileNumber'],
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize:
                                          MediaQuery.of(context).size.width >
                                                  340
                                              ? 20
                                              : 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Email  :  ',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize:
                                        MediaQuery.of(context).size.width > 340
                                            ? 20
                                            : 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Flexible(
                                  child: SelectableText(
                                    nearestRequestCenterData['emailId'],
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize:
                                          MediaQuery.of(context).size.width >
                                                  340
                                              ? 20
                                              : 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            child: SmallerActionButton(
                              text: 'Go Back',
                              enabled: true,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}

class FindMoreButtonWithDataForNearestCenter extends StatelessWidget {
  const FindMoreButtonWithDataForNearestCenter({
    Key key,
    @required this.nearestCenterData,
  }) : super(key: key);

  final Map<String, dynamic> nearestCenterData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: GestureDetector(
        child: Material(
          color: Colors.red,
          elevation: 10.0,
          shadowColor: altAuthShadowColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 7),
            height: 30.0,
            child: Text(
              'More Info',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontSize: 15,
              ),
            ),
          ),
        ),
        onTap: () {
          showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (BuildContext context) {
                return Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: Text(
                              'Contact Us through',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width > 340
                                        ? 20
                                        : 15,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Text(
                            'Contact Details',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: MediaQuery.of(context).size.width > 340
                                  ? 20
                                  : 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          nearestCenterData['contactName'] != null &&
                                  nearestCenterData['contactName'] != ""
                              ? Container(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Name  :  ',
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  340
                                              ? 20
                                              : 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Flexible(
                                        child: SelectableText(
                                          nearestCenterData['contactName'],
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    340
                                                ? 20
                                                : 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : SizedBox(),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mobile Number  :  ',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize:
                                        MediaQuery.of(context).size.width > 340
                                            ? 20
                                            : 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Flexible(
                                  child: SelectableText(
                                    nearestCenterData['mobileNumber'],
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize:
                                          MediaQuery.of(context).size.width >
                                                  340
                                              ? 20
                                              : 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 200,
                          ),
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Email  :  ',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize:
                                        MediaQuery.of(context).size.width > 340
                                            ? 20
                                            : 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Flexible(
                                  child: SelectableText(
                                    nearestCenterData['emailId'],
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width >
                                                  340
                                              ? 20
                                              : 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Container(
                              margin: EdgeInsets.only(top: 10, bottom: 10),
                              child: SmallerActionButton(
                                text: 'Go Back',
                                enabled: true,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
