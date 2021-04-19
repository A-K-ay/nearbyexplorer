import 'package:flutter/material.dart';

class Restaurant {
  final String imgurl, adress, name, placeId;
  final bool isopened;
  final double lat, long, rating;

  Restaurant(
      {this.imgurl,
      this.adress,
      this.name,
      this.placeId,
      this.isopened,
      this.lat,
      this.long,
      this.rating});
}
