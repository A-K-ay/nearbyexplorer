import 'package:flutter/material.dart';
import 'package:nearbyexplorer/core/Responsive.dart';
import 'package:nearbyexplorer/core/models/restaurant.dart';
import 'package:nearbyexplorer/screens/restaurantInfoScreen/restaurantInfoScreen.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'customButton.dart';

class ImageCardFull extends StatelessWidget {
  final Restaurant restaurant;

  const ImageCardFull({Key key, this.restaurant}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(getProportionateScreenWidth(16)),
          width: getProportionateScreenWidth(140),
          height: getProportionateScreenHeight(140),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          constraints: BoxConstraints(
              minHeight: getProportionateScreenHeight(200),
              minWidth: getProportionateScreenHeight(400)),
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
            child: Image.network(
              restaurant.imgurl,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
              colorBlendMode: BlendMode.darken,
              color: Colors.black38,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(getProportionateScreenWidth(16)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            // gradient: LinearGradient(
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            //   colors: [
            //     Color(0xFF343434).withOpacity(0.6),
            //     Color(0xFF343434).withOpacity(0.3),
            //   ],
            // ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
                top: getProportionateScreenHeight(16),
                left: getProportionateScreenWidth(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: getProportionateScreenWidth(200),
                  height: 54,
                  child: Text(
                    restaurant.name,
                    softWrap: true,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(5),
                ),
                SizedBox(
                  width: 200,
                  height: 36,
                  child: Text(
                    restaurant.adress,
                    softWrap: true,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[400]),
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      height: 35,
                      width: 90,
                      col: Colors.yellow,
                      txt: "View More",
                      fuc: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RestaurantInfo(
                                restaurant: restaurant,
                              ),
                            ));
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        right: getProportionateScreenWidth(20),
                      ),
                      child: Row(
                        children: [
                          RatingBarIndicator(
                            rating: restaurant.rating,
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 25.0,
                            direction: Axis.horizontal,
                          ),
                          Text(
                            restaurant.rating.toString(),
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
