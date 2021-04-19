import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nearbyexplorer/core/Responsive.dart';
import 'package:nearbyexplorer/core/constants.dart';
import 'package:nearbyexplorer/core/models/restaurant.dart';
import 'package:nearbyexplorer/screens/restaurantInfoScreen/restaurantInfoScreen.dart';

import 'customButton.dart';

class ImageCardRow extends StatelessWidget {
  final Restaurant restaurant;

  const ImageCardRow({Key key, this.restaurant}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: getProportionateScreenWidth(16),
          left: getProportionateScreenWidth(16),
          right: getProportionateScreenWidth(16)),
      // width: getProportionateScreenWidth(140),
      // height: getProportionateScreenHeight(140),
      decoration: BoxDecoration(),
      child: Row(
        children: [
          SizedBox(
            width: getProportionateScreenWidth(140),
            height: getProportionateScreenHeight(140),
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              child: Expanded(
                child: Image.network(
                  restaurant.imgurl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(10),
              vertical: getProportionateScreenHeight(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: getProportionateScreenWidth(160),
                  height: getProportionateScreenHeight(24),
                  child: Text(
                    restaurant.name,
                    overflow: TextOverflow.clip,
                    softWrap: true,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Constants.kCDarkestBlue),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(8),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(160),
                  height: getProportionateScreenHeight(38),
                  child: Text(
                    restaurant.adress,
                    overflow: TextOverflow.clip,
                    softWrap: true,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: restaurant.rating,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 20.0,
                      direction: Axis.horizontal,
                    ),
                    Text(
                      restaurant.rating.toString(),
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                CustomButton(
                  fuc: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RestaurantInfo(
                            restaurant: restaurant,
                          ),
                        ));
                  },
                  height: 38,
                  width: 84,
                  txt: "View More",
                  col: Constants.kMediumBlue,
                  txtCol: Colors.white,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
