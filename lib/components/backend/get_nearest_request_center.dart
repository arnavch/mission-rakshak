import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mission_rakshak/components/blood_request_cards.dart';
import 'package:mission_rakshak/pages/dashboard_screen.dart';
import 'package:mission_rakshak/styles/text_styles.dart';

class NearestRequestCenter extends StatelessWidget {
  const NearestRequestCenter({
    Key key,
    @required this.nearestRequest,
    @required this.widget,
  }) : super(key: key);

  final Future<List> nearestRequest;
  final DashboardPage widget;

  Widget getWidget() {
    return FutureBuilder<List>(
      future: nearestRequest,
      // CenterData.getNearestCenterWithDocument(
      //     latitude: latitude, longitude: longitude, index: centerData),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasError) {
          return Text(
            "Something went wrong",
            style: addressTextStyleBlack,
          );
        }

        if ((snapshot.hasData && !snapshot.data[0][0].exists)) {
          return NoBloodRequestCard();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: snapshot.data.map((center) {
              Map<String, dynamic> nearestRequestData = center[0].data();
              String nearestAddress = nearestRequestData['address'];
              String centerName = nearestRequestData['name'];

              double distance = Geolocator.distanceBetween(
                    widget.data['location'].latitude,
                    widget.data['location'].longitude,
                    nearestRequestData['location'].latitude,
                    nearestRequestData['location'].longitude,
                  ).toInt() /
                  1000;

              return Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: BloodRequestCard(
                  centerName: centerName,
                  distance: distance,
                  nearestAddress: nearestAddress,
                  nearestRequestCenterData: nearestRequestData,
                  priority: center[1],
                ),
              );
            }).toList(),
          );
        }

        return Text(
          "Loading...",
          style: addressTextStyleBlack,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return getWidget();
  }
}
