import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nearbyexplorer/core/Responsive.dart';
import 'package:nearbyexplorer/core/models/restaurant.dart';
import 'package:nearbyexplorer/core/models/user.dart';
import 'package:nearbyexplorer/core/widgets/circularIconButton.dart';
import 'package:nearbyexplorer/core/widgets/customButton.dart';
import 'package:nearbyexplorer/core/widgets/raizedText.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import "dart:math";
import 'package:url_launcher/url_launcher.dart';
import 'package:map_launcher/map_launcher.dart' as ml;

class RestaurantInfo extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantInfo({@required this.restaurant});

  @override
  _RestaurantInfoState createState() => _RestaurantInfoState();
}

class _RestaurantInfoState extends State<RestaurantInfo> {
  GoogleMapController mapController;
  Position locationData;
  Set<Marker> _markers = {};
  String address;
  Razorpay _razorpay;
  List<String> imageUrlList = [
    "https://cdn.pixabay.com/photo/2014/04/05/11/27/buffet-315691_1280.jpg",
    "https://cdn.pixabay.com/photo/2018/08/03/08/33/food-3581341_1280.jpg",
    "https://cdn.pixabay.com/photo/2016/02/19/10/00/food-1209007_1280.jpg",
    "https://cdn.pixabay.com/photo/2015/09/02/12/41/dish-918613_1280.jpg",
    "https://cdn.pixabay.com/photo/2017/12/09/08/18/pizza-3007395_1280.jpg",
    "https://cdn.pixabay.com/photo/2015/09/02/12/43/food-918639_1280.jpg",
  ];
  getRandomImage() {
    final random = new Random();
    var i = random.nextInt(imageUrlList.length);
    return imageUrlList[i];
  }

  launchMAP() async {
    if (await ml.MapLauncher.isMapAvailable(ml.MapType.google)) {
      await ml.MapLauncher.showMarker(
          mapType: ml.MapType.google,
          coords: ml.Coords(widget.restaurant.lat, widget.restaurant.long),
          title: widget.restaurant.name,
          description: widget.restaurant.name);
    }
  }

  launchMapURL() async {
    String lat = widget.restaurant.lat.toString();
    String long = widget.restaurant.long.toString();

    String googleMapslocationUrl =
        "https://www.google.com/maps/search/?api=1&query=$lat,$long";

    String encodedURl = Uri.encodeFull(googleMapslocationUrl);

    if (await canLaunch(encodedURl)) {
      await launch(encodedURl);
    } else {
      print('Could not launch $encodedURl');
      throw 'Could not launch $encodedURl';
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId("mark"),
        position: LatLng(widget.restaurant.lat, widget.restaurant.long),
      ));
    });
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_wPVnhPK0zj01Ka',
      'amount': 2000,
      'name': globalUser.email,
      'description': 'Payment',
      'prefill': {'contact': '9999999999', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId, timeInSecForIosWeb: 4);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        timeInSecForIosWeb: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIosWeb: 4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            child: Container(
              height: getProportionateScreenHeight(300),
              child: Image.network(getRandomImage()),
            ),
          ),
          Positioned(
            top: getProportionateScreenHeight(270),
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(getProportionateScreenWidth(30)),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: getProportionateScreenHeight(10),
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(300),
                        child: Text(
                          widget.restaurant.name,
                          style: TextStyle(fontSize: 32),
                        ),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(20),
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(300),
                        child: Text(
                          widget.restaurant.adress,
                          style: TextStyle(fontSize: 20, color: Colors.black54),
                        ),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(20),
                      ),
                      widget.restaurant.isopened
                          ? RaizedText(
                              text: "Opened",
                              col: Colors.green[500],
                            )
                          : RaizedText(
                              text: "Closed",
                              col: Colors.red[500],
                            ),
                      SizedBox(
                        height: getProportionateScreenHeight(20),
                      ),
                      Stack(
                        children: [
                          Container(
                            height: getProportionateScreenHeight(210),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            child: GoogleMap(
                              onMapCreated: _onMapCreated,
                              mapType: MapType.normal,
                              mapToolbarEnabled: false,
                              compassEnabled: false,
                              markers: _markers,
                              myLocationEnabled: true,
                              zoomControlsEnabled: false,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(widget.restaurant.lat,
                                    widget.restaurant.long),
                                zoom: 18.0,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: launchMAP,
                            child: Container(
                              width: 110,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
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
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.directions,
                                      size: 30,
                                      color: Colors.blue,
                                    ),
                                    Text("Directions")
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomButton(
                txt: "Book",
                height: 40,
                width: 120,
                fuc: openCheckout,
              ),
            ),
          ),
          Positioned(
              top: 2,
              left: 10,
              child: SafeArea(
                child: CircularIconButton(
                    icon: Icons.arrow_back_rounded,
                    fuc: () {
                      Navigator.pop(context);
                    }),
              ))
        ],
      ),
    );
  }
}
