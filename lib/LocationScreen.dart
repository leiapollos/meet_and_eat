import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meet_and_eat/ChatSystem.dart';
import 'package:meet_and_eat/ProfileScreen.dart';
import 'package:meet_and_eat/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class LocationScreen extends StatefulWidget {
  final String uid;

  const LocationScreen ({ Key key, this.uid }): super(key: key);
  @override
  _LocationScreen createState() => _LocationScreen();
}

class _LocationScreen extends State<LocationScreen>{
  DateFormat _dateFormat;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff3d405b),
      ),
      body: Text("hello"),
    );
  }
}