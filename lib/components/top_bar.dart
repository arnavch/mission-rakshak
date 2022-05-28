import 'package:flutter/material.dart';
import 'package:mission_rakshak/styles/colors.dart';

class TopBar extends StatefulWidget {
  TopBar(this.bloodType, this.firstName, this.verified);
  final String bloodType;
  final String firstName;
  final bool verified;

  @override
  _TopBarState createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  getVerifiedIndicator(verified) {
    if (verified) {
      return Chip(
        avatar: Icon(
          Icons.check_circle,
          color: Color.fromRGBO(71, 180, 132, 0.6),
        ),
        backgroundColor: Color.fromRGBO(71, 180, 132, .1),
        label: Text(
          'Verified',
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            color: Color.fromRGBO(71, 180, 132, 0.9),
          ),
        ),
      );
    } else {
      return Chip(
        avatar: Icon(
          Icons.cancel,
          color: Color.fromRGBO(233, 65, 57, 0.6),
        ),
        backgroundColor: Color.fromRGBO(233, 65, 57, 0.1),
        label: Text(
          'Unverified',
          style: TextStyle(
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              color: Color.fromRGBO(233, 65, 57, 0.9)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: MediaQuery.of(context).size.width > 340 ? 45 : 30,
            backgroundImage: AssetImage('assets/images/logo.png'),
          ),
          SizedBox(
            width: 25,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Hi, ',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${widget.firstName[0].toUpperCase()}${widget.firstName.substring(1)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Montserrat'),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    getVerifiedIndicator(widget.verified),
                    SizedBox(
                      width: 5,
                    ),
                    MediaQuery.of(context).size.width > 340
                        ? Container(
                            margin: EdgeInsets.only(top: 2.5),
                            // padding: EdgeInsets.only(top: 4, left: 13),
                            width: 55,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(99, 71, 180, 0.20),
                              borderRadius: BorderRadius.all(
                                Radius.circular(25),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                widget.bloodType,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromRGBO(99, 71, 180, 0.9)),
                              ),
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.only(top: 2.5),
                            // padding: EdgeInsets.only(top: 4, left: 13),
                            width: 55,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(99, 71, 180, 0.20),
                              borderRadius: BorderRadius.all(
                                Radius.circular(25),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                widget.bloodType,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromRGBO(99, 71, 180, 0.9)),
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
