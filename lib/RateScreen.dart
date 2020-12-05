import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meet_and_eat/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:meet_and_eat/MealScreen.dart';

class RatingScreen extends StatefulWidget {
  final String uid;

  const RatingScreen ({ Key key, this.uid }): super(key: key);
  @override
  _RatingScreen createState() => _RatingScreen();
}

class _RatingScreen extends State<RatingScreen>{
  DateFormat _dateFormat;
  @override
  Widget build(BuildContext context) {
    return Text("Rating Screen");
  }
}