import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:mission_rakshak/components/address_button.dart';
import 'package:mission_rakshak/components/findmore_button.dart';
import 'package:mission_rakshak/styles/colors.dart';
import 'package:mission_rakshak/styles/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class BloodRequestCard extends StatelessWidget {
  BloodRequestCard({
    Key key,
    @required this.distance,
    @required this.nearestAddress,
    @required this.centerName,
    @required this.nearestRequestCenterData,
    @required this.priority,
  }) : super(key: key);

  final double distance;
  final String nearestAddress;
  final int priority;
  final String centerName;

  final Map<String, dynamic> nearestRequestCenterData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: red, borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            //TODO: may have to put FOR here
            'For Your Blood Type',
            style: TextStyle(
                fontSize: 22,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                priority == 1
                    ? Chip(
                        avatar: CircleAvatar(
                          backgroundColor: Color.fromRGBO(255, 100, 44, 0),
                          child: Icon(
                            Icons.notification_important,
                            color: Color.fromRGBO(255, 100, 44, 0.6),
                          ),
                        ),
                        backgroundColor: Color.fromRGBO(255, 100, 44, 0.08),
                        label: Text(
                          'Urgent',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(255, 100, 44, 0.87),
                          ),
                        ),
                      )
                    : SizedBox(),

                priority == 0
                    ? Chip(
                        avatar: CircleAvatar(
                          backgroundColor: Color.fromRGBO(244, 67, 54, 0),
                          child: Icon(
                            Icons.notification_important,
                            color: Color.fromRGBO(244, 67, 54, 1),
                          ),
                        ),
                        backgroundColor: Color.fromRGBO(244, 67, 54, 0.2),
                        label: Text(
                          'Emergency',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(244, 67, 54, 1),
                          ),
                        ),
                      )
                    : SizedBox(),

                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    '${centerName[0].toUpperCase()}${centerName.substring(1)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),

                Row(
                  children: [
                    Icon(
                      Icons.room,
                      size: 30,
                    ),
                    SelectableText(
                      '$distance KM',
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Montserrat',
                      ),
                    )
                  ],
                ),

                SelectableText(
                  nearestAddress,
                  style: addressTextStyleBlack,
                ),

                // the 4 buttons

                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    AddressButton(
                        icon: Icons.phone,
                        label: 'Call',
                        func: () async {
                          await launch(
                              "tel:${nearestRequestCenterData['mobileNumber']}");
                        }),
                    SizedBox(
                      width: 7,
                    ),
                    AddressButton(
                        icon: Icons.email,
                        label: 'Email',
                        func: () async {
                          final Uri emailLaunchUri = Uri(
                              scheme: 'mailto',
                              path: nearestRequestCenterData['emailId'],
                              queryParameters: {'subject': ''});

                          await launch(emailLaunchUri.toString());
                        }),
                    SizedBox(
                      width: 7,
                    ),
                    AddressButton(
                      icon: Icons.directions,
                      label: 'View on Map',
                      func: () async {
                        Coords cords = Coords(
                          nearestRequestCenterData['location'].latitude,
                          nearestRequestCenterData['location'].longitude,
                        );
                        final availableMaps = await MapLauncher.installedMaps;
                        await availableMaps.first.showMarker(
                          coords: cords,
                          title:
                              "Donation center ${nearestRequestCenterData['name']}",
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          FindMoreButtonWithData(
              nearestRequestCenterData: nearestRequestCenterData,
              distance: distance),
        ],
      ),
    );
  }
}

class DisplayBloodRequestCard extends StatelessWidget {
  DisplayBloodRequestCard({
    Key key,
    @required this.distance,
    @required this.nearestAddress,
    @required this.centerName,
    @required this.centerData,
  }) : super(key: key);

  final double distance;
  final String nearestAddress;
  final String centerName;
  final Map centerData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: red, borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          // Text(
          //   //TODO: may have to put FOR here
          //   'Your Blood Type',
          //   style: TextStyle(
          //       fontSize: 22,
          //       fontFamily: 'Montserrat',
          //       fontWeight: FontWeight.w700,
          //       color: Colors.white),
          // ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.room,
                      size: 30,
                    ),
                    SelectableText(
                      '$distance KM',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Montserrat',
                      ),
                    )
                  ],
                ),

                SelectableText(
                  '${centerName[0].toUpperCase()}${centerName.substring(1)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Montserrat',
                  ),
                ),

                SelectableText(
                  nearestAddress,
                  style: addressTextStyleBlack,
                ),

                // the 4 buttons

                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    AddressButton(
                      icon: Icons.phone,
                      label: 'Call',
                      func: () async {
                        await launch("tel:${centerData['mobileNumber']}");
                      },
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    AddressButton(
                        icon: Icons.email,
                        label: 'Email',
                        func: () async {
                          final Uri emailLaunchUri = Uri(
                              scheme: 'mailto',
                              path: centerData['emailId'],
                              queryParameters: {'subject': ''});

                          await launch(emailLaunchUri.toString());
                        }),
                    SizedBox(
                      width: 7,
                    ),
                    AddressButton(
                      icon: Icons.directions,
                      label: 'View on Map',
                      func: () async {
                        Coords cords = Coords(
                          centerData['location'].latitude,
                          centerData['location'].longitude,
                        );
                        final availableMaps = await MapLauncher.installedMaps;
                        await availableMaps.first.showMarker(
                          coords: cords,
                          title: "Donation center ${centerData['name']}",
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NoBloodRequestCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: red, borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            'No urgent blood requests',
            style: TextStyle(
                fontSize: 22,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'There are no urgent donation requests',
            style: addressTextStyleWhite,
          ),
        ],
      ),
    );
  }
}
