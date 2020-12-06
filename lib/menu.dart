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
    CollectionReference users = FirebaseFirestore.instance.collection('profiles');
    final uid = context.watch<AuthenticationService>().getUserId();
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(uid).get(),
    builder:
    (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

    CollectionReference users = FirebaseFirestore.instance.collection('profiles');
    print("hello");
    if (snapshot.hasError) {
    return Text("Something went wrong");
    }

    if (snapshot.connectionState == ConnectionState.done) {
    Map<String, dynamic> data = snapshot.data.data();

    if(snapshot.data.exists){
      return  Drawer(
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
                    data == null || data['url'] == null || data['url'] == "" ? 'https://cdn.pixabay.com/photo/2013/07/13/12/07/avatar-159236_640.png' : data['url'],
                  ),
                  radius: 70.0,
                ),
                Text(
                  data == null || data.isEmpty || data['name'] == "" ? "Name LastName" : data['name'] + " " + data['lastName'],
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
                          child: Icon(IconData(0xe848, fontFamily: 'MaterialIcons'), size: 22),
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
    return  Drawer(
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
                    'https://cdn.pixabay.com/photo/2013/07/13/12/07/avatar-159236_640.png',
                  ),
                  radius: 70.0,
                ),
                Text(
                  "Name LastName",
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
    );
  }
}
