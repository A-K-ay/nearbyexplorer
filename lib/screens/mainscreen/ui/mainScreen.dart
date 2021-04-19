import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nearbyexplorer/core/constants.dart';
import 'package:nearbyexplorer/core/models/restaurant.dart';
import 'package:nearbyexplorer/core/services/authentication.dart';
import 'package:nearbyexplorer/core/services/locationServices.dart';
import 'package:nearbyexplorer/core/widgets/circularIconButton.dart';
import 'package:nearbyexplorer/core/widgets/imageCardFull.dart';
import 'package:nearbyexplorer/core/widgets/imageCardRow.dart';
import 'package:nearbyexplorer/core/widgets/locationDeniedScreen.dart';
import 'package:nearbyexplorer/screens/profilePage/ui/profileScreen.dart';
import '../../../core/Responsive.dart';

import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Restaurant> restaurantList = [];
  bool isLoaded = false;
  bool isSearching = false;
  Position locationData;
  bool gotlocation = false;
  String keyWord = "Restaurant";
  TextEditingController searchController = TextEditingController();

  String mapKey = "AIzaSyANiDLfEbYMlo2Cd_jEYyuOBJyjTvhUq38";

  Future getPermission() async {
    // LocationPermission permission = await Geolocator.requestPermission();
    bool gotperm = await LocationServices.determinePosition(context);
    if (gotperm = true) {
      checkIfLocationDenied();
    }
  }

  searchKeyword() async {
    if (searchController != null) {
      setState(() {
        isSearching = true;
      });
      keyWord = searchController.text.trim();
      print(keyWord);
      await getRestaurantsData();
      setState(() {
        isSearching = false;
      });
    }
  }

  Future getlocation() async {
    locationData = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(" We got the location: ${locationData.latitude}");
    if (gotlocation != null) {
      setState(() {
        gotlocation = true;
      });
    }
  }

  checkIfLocationDenied() {
    if (Constants.isLocationdenied == true) {
      print(Constants.isLocationdenied);
      print(
          "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Pushing user to location denied screen");
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LocationDenied(),
          ));
    }
  }

  getEverything() async {
    await getPermission();
    await checkIfLocationDenied();
    await getlocation();
    await getRestaurantsData();
    await AuthService().updateUserDetails();
  }

  getRestaurantsData() async {
    restaurantList.clear();
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${locationData.latitude},${locationData.longitude}&radius=5000&type=restaurant&keyword=$keyWord&key=$mapKey');
    var response = await http.post(url, body: {});
    print('Response status: ${response.statusCode}');
    var jsonData = jsonDecode(response.body);
    List results = jsonData['results'];
    print(results.runtimeType);
    results.forEach(
      (element) {
        String imgUrl =
            "https://cdn.pixabay.com/photo/2016/06/06/18/29/meat-skewer-1440105_1280.jpg";
        try {
          String pr = (element['photos'][0]['photo_reference']);
          imgUrl =
              "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$pr&key=$mapKey";
          print("img added");
        } catch (e) {
          print("placeholder used");
        }
        var rat = element['rating'];
        if (rat.runtimeType == int) {
          rat = 0.0;
        }
        print(element['rating'].runtimeType);
        try {
          Restaurant res = Restaurant(
            imgurl: imgUrl,
            adress: element['vicinity'],
            rating: rat,
            name: element['name'],
            lat: element['geometry']['location']['lat'],
            long: element['geometry']['location']['lng'],
            isopened: element['opening_hours']['open_now'],
          );
          print(res.name);
          restaurantList.add(res);
        } catch (e) {
          print("error setting up restaurant : $e");
        }
      },
    );
    setState(() {
      print("set is loaded to true");
      print(restaurantList.length.toString() + "length of list");
      isLoaded = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEverything();
  }

  @override
  Widget build(BuildContext context) {
    Responsive().init(context);
    return Scaffold(
      backgroundColor: Constants.kCLightBlue,
      body: SafeArea(
        child: !isLoaded || !gotlocation
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: getProportionateScreenHeight(2),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.all(getProportionateScreenWidth(20)),
                        height: getProportionateScreenHeight(40),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            //background color of box
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 5.0, // soften the shadow
                              spreadRadius: .5, //extend the shadow
                              offset: Offset(
                                1.0, // Move to right 10  horizontally
                                1.0, // Move to bottom 10 Vertically
                              ),
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(40),
                              width: getProportionateScreenHeight(200),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 0.0),
                                child: TextFormField(
                                  controller: searchController,
                                  onFieldSubmitted: (value) {
                                    searchKeyword();
                                  },
                                  decoration: InputDecoration(
                                      focusColor: Constants.kCDarkestBlue,
                                      fillColor: Constants.kCDarkestBlue,
                                      hoverColor: Constants.kCDarkestBlue,
                                      border: InputBorder.none,
                                      hintText: "Search nearby"),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                searchKeyword();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.search),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(),
                              ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularIconButton(icon: Icons.person),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                    child: Text(
                      "Restaurants Near You",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(40),
                        ),
                      ),
                      child: isSearching
                          ? Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              itemCount: restaurantList.length,
                              itemBuilder: (context, index) {
                                return ImageCardRow(
                                  restaurant: restaurantList[index],
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ListView(
//                 children: [
//                   ImageCardFull(
//                     restaurant: Restaurant(
//                         imgurl:
//                             "https://cdn.pixabay.com/photo/2020/05/24/02/00/barber-shop-5212059__480.jpg",
//                         name: "Bob Unisex Saloon",
//                         adress: "1374  Hide A Way Road",
//                         rating: 4.9),
//                   ),
//                   ImageCardFull(
//                     restaurant: Restaurant(
//                         imgurl:
//                             "https://cdn.pixabay.com/photo/2016/06/12/21/41/barber-1453064_1280.jpg",
//                         name: "Hair Desirable",
//                         adress: "1930  Maple Court",
//                         rating: 4.0),
//                   ),
//                   ImageCardFull(
//                     restaurant: Restaurant(
//                         imgurl:
//                             "https://cdn.pixabay.com/photo/2017/03/22/17/37/barber-2165745_1280.jpg",
//                         name: "HairZilla",
//                         adress: "862  Langtown Road",
//                         rating: 4.5),
//                   ),
//                   ImageCardFull(
//                     restaurant: Restaurant(
//                         imgurl:
//                             "https://cdn.pixabay.com/photo/2015/11/01/19/43/barber-1017457_1280.jpg",
//                         name: "Saloonous",
//                         adress: "59 Talbot Ave.Vincentown, NJ 08088",
//                         rating: 4.7),
//                   ),
//                   ImageCardFull(
//                     restaurant: Restaurant(
//                         imgurl:
//                             "https://cdn.pixabay.com/photo/2017/08/29/12/17/hairdressing-salon-2693077_1280.jpg",
//                         name: "Lotus Saloon",
//                         adress: "188 Indian Summer St.Norwich, CT 06360",
//                         rating: 4.8),
//                   ),
//                   ImageCardFull(
//                     restaurant: Restaurant(
//                         imgurl:
//                             "https://cdn.pixabay.com/photo/2015/10/26/20/51/barber-1007902_1280.jpg",
//                         name: "Rage Beauty",
//                         adress: "247 Grandrose St.Millington, TN 38053",
//                         rating: 4.4),
//                   ),
//                   ImageCardFull(
//                     restaurant: Restaurant(
//                         imgurl:
//                             "https://cdn.pixabay.com/photo/2017/05/07/11/46/barber-2292168_1280.jpg",
//                         name: "Khan Cuts",
//                         adress: "348 Saxon St.",
//                         rating: 4.1),
//                   ),
//                   ImageCardRow(
//                     restaurant: Restaurant(
//                         imgurl:
//                             "https://cdn.pixabay.com/photo/2020/05/14/12/37/barber-5194406_1280.jpg",
//                         name: "Beautzen",
//                         adress: "831 Lakewood Road",
//                         rating: 4.3),
//                   ),
//                   ImageCardRow(
//                     restaurant: Restaurant(
//                         imgurl:
//                             "https://cdn.pixabay.com/photo/2020/05/24/02/00/barber-shop-5212058_1280.jpg",
//                         name: "Natty Catty",
//                         adress: "247 Grandrose St",
//                         rating: 4.9),
//                   ),
//                 ],
//               ),
