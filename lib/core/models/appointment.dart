import 'package:flutter/material.dart';

class Appointment {
  final String shopId, userId;
  final DateTime date;
  final List servicesTaken;
  final List<DateTime> timeSlot;
  final bool isAccepted;
  final double price;

  Appointment({
    this.shopId,
    this.userId,
    this.date,
    this.servicesTaken,
    this.timeSlot,
    this.isAccepted,
    this.price,
  });
}
