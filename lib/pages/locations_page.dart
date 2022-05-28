import 'package:flutter/material.dart';
import 'package:mission_rakshak/components/address_button.dart';
import 'package:mission_rakshak/components/findmore_button.dart';
import 'package:mission_rakshak/components/top_bar.dart';
import 'package:mission_rakshak/styles/colors.dart';
import 'package:mission_rakshak/styles/text_styles.dart';

class LocationListPage extends StatefulWidget {
  LocationListPage(this.data, this.centerData);
  Map data;
  Map centerData;
  @override
  _LocationListPageState createState() => _LocationListPageState();
}

class _LocationListPageState extends State<LocationListPage> {
  Map centers;
  @override
  void initState() {
    centers = widget.centerData['centers'];
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
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              'Our Centers',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: ListView.separated(
                    itemCount: centers.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(),
                    itemBuilder: (BuildContext context, int index) {
                      String centerName = centers.keys.elementAt(index);
                      String address = centers.values.elementAt(index);
                      return Container(
                        padding: EdgeInsets.all(10),
                        // height: 200,
                        decoration: BoxDecoration(
                            color: red,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            SelectableText(
                              '$centerName',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                            SelectableText(
                              '$address',
                              style: addressTextStyleWhite,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                FindMoreButton(
                                    centerName: centerName,
                                    userData: widget.data),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
