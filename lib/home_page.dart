import 'package:flutter/material.dart';
import 'package:meet_and_eat/menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meet_and_eat/authentication_service.dart';
import 'package:meet_and_eat/AddUser.dart';
import 'package:meet_and_eat/GetUsers.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu(title: 'Meet&Eat'),
      appBar: AppBar(
        title: Text('Meet&Eat'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GetUsers(),
            //AddUser("John", "Doe", 25)
          ],
        ),
      ),
    );
  }
}
