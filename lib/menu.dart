import 'package:flutter/material.dart';
import 'package:meet_and_eat/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Profile.dart';
class Menu extends StatelessWidget {
  final String title;

  Menu({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uid = context.watch<AuthenticationService>().getUserId();
    return Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: Column(
          children: [
            Expanded(
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: <Widget>[
                  SizedBox(
                    height: 80,
                    child: DrawerHeader(
                      margin: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                      child: Text(
                        'Settings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text('Profile'),
                    onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Profile(uid)),
                      );
                      // Update the state of the app
                      // ...
                      // Then close the drawer
                      //Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('Item 2'),
                    onTap: () {
                      // Update the state of the app
                      // ...
                      // Then close the drawer
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: () {
                context.read<AuthenticationService>().signOut();
              },
              child: Text("Sign out"),
            ),
          ],
        ),
      );
  }
}