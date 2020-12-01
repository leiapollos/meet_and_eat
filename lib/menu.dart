import 'package:flutter/material.dart';
import 'package:meet_and_eat/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'AddMeal.dart';
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
                        color: Color(0xff3d405b),
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


                  SizedBox(
                    height: 20,
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg.jpg",
                    ),
                    radius: 60.0,
                  ),
                  Text(
                    "Toni Kukoc",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Color(0xff3d405b),
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),

                  ListTile(
                    title: RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(Icons.account_circle_sharp, size: 22),
                          ),
                          TextSpan(
                              text: '  Profile',
                              style: TextStyle(fontWeight: FontWeight.normal,
                                  height: 1.5,
                                  fontSize: 18.0,
                                  color: Color(0xff3d405b),
                                  letterSpacing: 0.5)
                          ),
                        ],
                      ),
                    ),
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
                    title: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: Icon(Icons.backpack_sharp, size: 22),
                            ),
                            TextSpan(
                              text: '  Schedule a Meat&Eat',
                              style: TextStyle(fontWeight: FontWeight.normal,
                                height: 1.5,
                                fontSize: 18.0,
                                color: Color(0xff3d405b),
                                letterSpacing: 0.5)
                            ),
                          ],
                        ),
                      ),
                    focusColor: Color(0xff3d405b),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddMeal()),
                      );
                      // Update the state of the app
                      // ...
                      // Then close the drawer
                      //Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(Icons.ac_unit_sharp, size: 22),
                          ),
                          TextSpan(
                              text: '  Log out',
                              style: TextStyle(fontWeight: FontWeight.normal,
                                  height: 1.5,
                                  fontSize: 18.0,
                                  color: Color(0xff3d405b),
                                  letterSpacing: 0.5)
                          ),
                        ],
                      ),
                    ),
                    focusColor: Color(0xff3d405b),
                    onTap: () {
                      context.read<AuthenticationService>().signOut();

                    },
                  ),
                ],
              ),
            ),
            /*RaisedButton(
              onPressed: () {
                context.read<AuthenticationService>().signOut();
              },
              child: Text("Sign out"),
            ),*/
          ],
        ),
      );
  }
}