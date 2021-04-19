import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nearbyexplorer/core/constants.dart';
import 'package:nearbyexplorer/core/services/locationServices.dart';
import 'package:nearbyexplorer/core/widgets/customButton.dart';
import 'package:nearbyexplorer/core/widgets/raizedText.dart';
import 'package:nearbyexplorer/screens/mainscreen/ui/mainScreen.dart';

import '../Responsive.dart';

class LocationDenied extends StatelessWidget {
  const LocationDenied({Key key}) : super(key: key);

  checkLocationaccess(context) async {
    await LocationServices.determinePosition(context);
    print(
        "?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????");
    print(Constants.isLocationdenied);
    if (Constants.isLocationdenied == false) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Flexible(
                flex: 2,
                child: SvgPicture.asset("assets/locationDenied.svg"),
              ),
              Flexible(
                  flex: 1,
                  child: RaizedText(
                      text:
                          "Location Access is needed to show you the nearby restaurants, please allow location access in the settings.")),
              SizedBox(
                height: 20,
              ),
              Flexible(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    checkLocationaccess(context);
                  },
                  child: Container(
                    width: getProportionateScreenWidth(100),
                    height: getProportionateScreenHeight(70),
                    decoration: BoxDecoration(
                      color: Constants.kCBlueGrey,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      boxShadow: [
                        //background color of box
                        BoxShadow(
                          color: Constants.kCBlueGrey.withOpacity(0.3),
                          blurRadius: 5.0, // soften the shadow
                          spreadRadius: .5, //extend the shadow
                          offset: Offset(
                            1.0, // Move to right 10  horizontally
                            1.0, // Move to bottom 10 Vertically
                          ),
                        )
                      ],
                    ),
                    child: Center(
                        child: Text(
                      "Allow Access",
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
