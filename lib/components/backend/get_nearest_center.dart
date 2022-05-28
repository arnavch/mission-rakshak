import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:mission_rakshak/Database/centerData.dart';
import 'package:mission_rakshak/components/address_button.dart';
import 'package:mission_rakshak/components/findmore_button.dart';
import 'package:mission_rakshak/styles/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class GetNearestCenter extends StatelessWidget {
  GetNearestCenter({
    @required this.userData,
    @required this.longitude,
    @required this.latitude,
    @required this.centerData,
    @required this.nearestCenterCache,
    @required this.setNearestCenterCache,
  });
  final double longitude;
  final double latitude;
  final Map userData;
  final dynamic centerData;
  dynamic nearestCenterCache;
  final Function setNearestCenterCache;

  Widget getWidget(doc) {
    if (nearestCenterCache == null) {
      return FutureBuilder<DocumentSnapshot>(
        future: CenterData.getNearestCenter(
            latitude: latitude, longitude: longitude),
        // CenterData.getNearestCenterWithDocument(
        //     latitude: latitude, longitude: longitude, index: centerData),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text(
              "Something went wrong",
              style: addressTextStyleWhite,
            );
          }

          if ((snapshot.hasData && !snapshot.data.exists)) {
            return Text(
              "Something went wrong",
              style: addressTextStyleWhite,
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> nearestCenter = snapshot.data.data();
            String nearestAddress = nearestCenter['address'];
            String centerName = nearestCenter['name'];
            setNearestCenterCache(nearestCenter);

            double distance = Geolocator.distanceBetween(
                  userData['location'].latitude,
                  userData['location'].longitude,
                  nearestCenter['location'].latitude,
                  nearestCenter['location'].longitude,
                ).toInt() /
                1000;

            final Uri emailLaunchUri = Uri(
                scheme: 'mailto',
                path: nearestCenter['emailId'],
                queryParameters: {'subject': ''});

            return Padding(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${centerName[0].toUpperCase()}${centerName.substring(1)}',
                          style: TextStyle(
                              fontSize: 23,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 5),
                          child: SelectableText(
                            '($distance KM)',
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      nearestAddress,
                      style: addressTextStyleWhite,
                    ),
                    SizedBox(
                      height: 5,
                    ),
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
                                "tel:${nearestCenter['mobileNumber']}");
                          },
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        AddressButton(
                            icon: Icons.email,
                            label: 'Email',
                            func: () async {
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
                              nearestCenter['location'].latitude,
                              nearestCenter['location'].longitude,
                            );
                            final availableMaps =
                                await MapLauncher.installedMaps;
                            await availableMaps.first.showMarker(
                              coords: cords,
                              title: "Donation center ${nearestCenter['name']}",
                            );
                          },
                        ),
                      ],
                    ),
                    FindMoreButtonWithDataForNearestCenter(
                        nearestCenterData: nearestCenter),
                  ]),
            );
          }

          return Text(
            "Loading...",
            style: addressTextStyleWhite,
          );
        },
      );
    } else {
      String nearestAddress = nearestCenterCache['address'];
      final Uri emailLaunchUri = Uri(
          scheme: 'mailto',
          path: nearestCenterCache['emailId'],
          queryParameters: {'subject': ''});

      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          nearestAddress,
          style: addressTextStyleWhite,
        ),
        SizedBox(
          height: 5,
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            AddressButton(
              icon: Icons.phone,
              label: 'Call',
              func: () async {
                await launch("tel:${nearestCenterCache['mobileNumber']}");
              },
            ),
            SizedBox(
              width: 7,
            ),
            AddressButton(
              icon: Icons.email,
              label: 'Email',
              func: () async {
                await launch(emailLaunchUri.toString());
              },
            ),
            SizedBox(
              width: 7,
            ),
            AddressButton(
              icon: Icons.directions,
              label: 'View on Map',
              func: () async {
                Coords cords = Coords(
                  nearestCenterCache['location'].latitude,
                  nearestCenterCache['location'].longitude,
                );
                final availableMaps = await MapLauncher.installedMaps;
                await availableMaps.first.showMarker(
                  coords: cords,
                  title: "Donation center ${nearestCenterCache['name']}",
                );
              },
            ),
          ],
        ),
        FindMoreButtonWithDataForNearestCenter(
            nearestCenterData: nearestCenterCache),
      ]);
    }

    // else {
    //   return FutureBuilder<DocumentSnapshot>(
    //     future: CenterData.getNearestCenter(
    //         latitude: latitude, longitude: longitude),
    //     builder:
    //         (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    //       if (snapshot.hasError) {
    //         return Text(
    //           "Something went wrong",
    //           style: addressTextStyleWhite,
    //         );
    //       }
    //
    //       if ((snapshot.hasData && !snapshot.data.exists)) {
    //         return Text(
    //           "Something went wrong",
    //           style: addressTextStyleWhite,
    //         );
    //       }
    //
    //       if (snapshot.connectionState == ConnectionState.done) {
    //         Map<String, dynamic> nearestCenter = snapshot.data.data();
    //         String nearestAddress = nearestCenter['address'];
    //         return Text(
    //           nearestAddress,
    //           style: addressTextStyleWhite,
    //         );
    //       }
    //
    //       return Text(
    //         "Loading...",
    //         style: addressTextStyleWhite,
    //       );
    //     },
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return getWidget(centerData);
  }
}
