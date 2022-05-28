import 'package:flutter/material.dart';
import 'package:mission_rakshak/components/auth_components.dart';
import 'package:mission_rakshak/components/rules.dart';
import 'package:mission_rakshak/styles/colors.dart';
import 'package:mission_rakshak/styles/text_styles.dart';

class RulePage extends StatefulWidget {
  RulePage({
    @required this.ruleBeforeDonation,
    @required this.changeBool,
  });
  final bool ruleBeforeDonation;
  final Function changeBool;
  @override
  _RulePageState createState() => _RulePageState();
}

class _RulePageState extends State<RulePage> {
  bool acceptedTerms = false;
  bool gernerateQr = false;

  List ruleList = [];

  @override
  void initState() {
    ruleList = widget.ruleBeforeDonation == true
        ? rulesBeforeDonation
        : rulesBeforeSignUp;
    super.initState();

    acceptedTerms = widget.ruleBeforeDonation == true ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    int count = 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(top: 30, bottom: 30),
                child: Text(
                  'Rules for donating',
                  style: authTitleTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 6),
                child: Text(
                  'Please read the rules before you continue ',
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      fontFamily: 'Montserrat'),
                ),
              ),
              Column(
                children: ruleList.map((e) {
                  count = count + 1;
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$count)',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            e,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              // for (var rule in rules)
              //   Text(
              //     rule,
              //     style: addressTextStyleBlack,
              //   ),
              Row(
                children: [
                  SizedBox(
                    width: 6,
                  ),
                  Checkbox(
                      activeColor: red,
                      value: acceptedTerms,
                      onChanged: (val) {
                        setState(() {
                          acceptedTerms = val;
                        });
                      }),
                  Text(
                    'I have read all the rules',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontFamily: 'Montserrat'),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: ActionButton(
                  text: 'Continue',
                  enabled: acceptedTerms,
                  onPressed: () {
                    widget.changeBool();
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
