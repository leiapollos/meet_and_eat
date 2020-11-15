import 'package:flutter/material.dart';
import 'package:meet_and_eat/menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meet_and_eat/authentication_service.dart';
import 'package:meet_and_eat/AddUser.dart';
import 'package:meet_and_eat/GetUsers.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  final String documentId;

  Profile(this.documentId);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('profiles');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          //return Text("Full Name: ${data['name']} ${data['lastName']}");
          return Scaffold(
            appBar: AppBar(
              title: Text('Profile'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(data['name'] + " " + data['lastName']),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Profile'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //GetUsers(),
                //AddUser("John", "Doe", 25)
                Text("Profile"),
              ],
            ),
          ),
        );
      },
    );

  }
}
