import 'package:flutter/material.dart';
import 'package:mission_rakshak/components/backend/get_nearest_center.dart';
import 'package:mission_rakshak/components/backend/get_nearest_request_center.dart';
import 'package:mission_rakshak/styles/colors.dart';
import 'package:mission_rakshak/components/top_bar.dart';
import '../styles/colors.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({
    this.data,
    this.centerData,
    this.setNearestCenterFunc,
    this.nearestCenterData,
    this.nearestRequest,
  });
  Map<String, dynamic> data;
  Map<String, dynamic> centerData;
  dynamic nearestCenterData;
  dynamic nearestRequest;
  Function setNearestCenterFunc;

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String firstName;
  String bloodType;

  //if the user is autherized
  bool isAutherized = false;

  @override
  void initState() {
    firstName = widget.data['firstName'];
    bloodType = widget.data['bloodType'];

    // DonationHistoryData.createDonationLog(
    //   name: firstName + ' ' + widget.data['lastName'],
    //   bloodType: bloodType,
    //   centerName: 'nerul',
    //   userId: FirebaseAuth.instance.currentUser.uid,
    // );

    // RequestData.createBloodDonationRequest(
    //   name: 'seawoods',
    //   bloodType: 'O+',
    //   geoPoint: GeoPoint(19.0055253, 73.0159388),
    //   address: 'nri Phase 2',
    // );

    // RequestData.deleteBloodDonationRequest(
    //   name: 'vashi',
    //   bloodType: 'O+',
    // );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: red,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        TopBar(
                            bloodType, firstName, widget.data['donatedBefore']),

                        SizedBox(
                          height: 20,
                        ),

                        // address card

                        Container(
                          padding: EdgeInsets.all(10),
                          // height: 200,
                          decoration: BoxDecoration(
                              color: red,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.room,
                                size: 40,
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Nearest Donation Center From Your House',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                              GetNearestCenter(
                                userData: widget.data,
                                latitude: widget.data['location'].latitude,
                                longitude: widget.data['location'].longitude,
                                centerData: widget.centerData,
                                nearestCenterCache: widget.nearestCenterData,
                                setNearestCenterCache:
                                    widget.setNearestCenterFunc,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 30,
                        ),

                        Text(
                          'Open Donation Requests',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        SizedBox(
                          height: 20,
                        ),

                        //new box

                        NearestRequestCenter(
                          nearestRequest: widget.nearestRequest,
                          widget: widget,
                        ),

                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
