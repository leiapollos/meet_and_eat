import 'package:flutter/material.dart';
import 'package:meet_and_eat/BookingsScreen.dart';
import 'package:meet_and_eat/RateScreen.dart';
import 'package:meet_and_eat/home_page_content.dart';
import 'package:meet_and_eat/menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meet_and_eat/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:meet_and_eat/GetUsers.dart';
import 'dart:developer';

import 'MealScreen.dart';
import 'ProfileScreen.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    final uid = context.watch<AuthenticationService>().getUserId();
    List<Widget> _widgetOptions = <Widget>[
      HomePageContent(),
      /*Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GetUsers(),
          Text(uid)
        ],
      ),*/
      RatingScreen(uid: uid),
      BookingsScreen(),
    ];
    return Scaffold(
      drawer: Menu(title: 'Meet&Eat'),
      appBar: AppBar(
        backgroundColor: Color(0xff3d405b),
        title: Text('Meet&Eat'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search),
              onPressed: (){
                showSearch(context: context, delegate: DataSearch());
          })
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            label: 'Bookings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xff3d405b),
        onTap: _onItemTapped,
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String>{
  /// TODO: USE BACKEND DATA AND UPDATE RECENTPEOPLE


  @override
  List<Widget> buildActions(BuildContext context) {
    // Action for app bar
   return [IconButton(icon: Icon(Icons.clear), onPressed: (){
     query = '';
   })];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Leading icon on the of the app bar
    return IconButton(icon: AnimatedIcon(
      icon: AnimatedIcons.menu_arrow,
      progress: transitionAnimation,
    ),
     onPressed: (){
      close(context, null);
     });
  }

  @override
  Widget buildResults(BuildContext context) {
    // Show result base on the selection
    /*return Card(
      color: Colors.blue,
      child: Center(
        child: Text(profile[0]['lastName']),
      ),
    );*/
    print(query);
    final people = FirebaseFirestore.instance.collection(
        'profiles').where('name',  isGreaterThanOrEqualTo: query.toString())
        .where('name', isLessThan: query.toString() + 'z');
    final mealsdb = FirebaseFirestore.instance.collection(
        'meals').where('mealName',  isGreaterThanOrEqualTo: query.toString())
        .where('mealName', isLessThan: query.toString() + 'z');


    return Column(
      children: <Widget>[
       Flexible(
          child: StreamBuilder(
              stream: people.snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot1) {
                if (snapshot1.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot1.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }
                final profiles = snapshot1.data.docs;
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  //shrinkWrap: true,
                  itemCount: profiles.length,
                  itemBuilder: (context, index) =>
                      Container(
                        width: MediaQuery.of(context).size.width * 0.94,
                        child: FlatButton(
                          onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProfileScreen(uid: profiles[index].id)),
                            )
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: Colors.white,
                            elevation: 3,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: MediaQuery.of(context).size.width * 0.28,
                                      maxHeight: MediaQuery.of(context).size.width * 0.28,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(200),
                                      child: (profiles[index]['url'] != null && profiles[index]['url'].toString().isNotEmpty)
                                          ? Image.network(profiles[index]['url']) : NetworkImage(
                                        'https://cdn.pixabay.com/photo/2013/07/13/12/07/avatar-159236_640.png',
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListTile(title: Text(profiles[index]['name'] + " " + profiles[index]['lastName'], style: const TextStyle(fontSize: 19.0, fontWeight: FontWeight.w700),),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(left: 0, top: 5, right: 0, bottom: 0),
                                      child: Text(profiles[index]['age'].toString(), style: const TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500),),
                                    ),),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                );
              }),
        ),
        Flexible(
          child: StreamBuilder(
              stream: mealsdb.snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot1) {
                if (snapshot1.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot1.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }
                final meals = snapshot1.data.docs;
                print(meals.length);
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  //shrinkWrap: true,
                  itemCount: meals.length,
                  itemBuilder: (context, index) =>
                      Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: FlatButton(
                          onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MealScreen(uid: meals[index].id)),
                            )
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: Colors.white,
                            elevation: 3,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: ListTile(title: Text(meals[index]['mealName'] + " " + meals[index]['date'], style: const TextStyle(fontSize: 19.0, fontWeight: FontWeight.w700),),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(left: 0, top: 5, right: 0, bottom: 0),
                                      child: Text(meals[index]['seats'].toString(), style: const TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500),),
                                    ),),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                );
              }),
        ),
      ],
    );
   /* return StreamBuilder<QuerySnapshot>(
        stream: people.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot1) {
          final profiles = snapshot1.data.docs;
          return StreamBuilder<QuerySnapshot>(
            stream: mealsdb.snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
                if (snapshot1.hasError || snapshot2.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot1.connectionState == ConnectionState.waiting || snapshot2.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }
                final meals = snapshot2.data.docs;
                return Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    //shrinkWrap: true,
                    itemCount: profiles.length + meals.length,
                    itemBuilder: (context, index) =>
                        Container(
                          width: MediaQuery.of(context).size.width * 0.94,
                          child: FlatButton(
                            onPressed: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ProfileScreen(uid: profiles[index].id)),
                              )
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              color: Colors.white,
                              elevation: 3,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: MediaQuery.of(context).size.width * 0.28,
                                        maxHeight: MediaQuery.of(context).size.width * 0.28,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(200),
                                        child: (profiles[index]['url'] != null && profiles[index]['url'].toString().isNotEmpty)
                                            ? Image.network(profiles[index]['url']) : Image.asset('assets/images/chimo.png', fit: BoxFit.fill),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListTile(title: Text(profiles[index]['name'] + " " + profiles[index]['lastName'], style: const TextStyle(fontSize: 19.0, fontWeight: FontWeight.w700),),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(left: 0, top: 5, right: 0, bottom: 0),
                                        child: Text(profiles[index]['age'].toString(), style: const TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500),),
                                      ),),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                  ),
                );
              }
          );


        });*/
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Suggestion search
    final people = FirebaseFirestore.instance.collection(
        'profiles').where('name',  isGreaterThanOrEqualTo: query.toString())
        .where('name', isLessThan: query.toString() + 'z');
    final mealsdb = FirebaseFirestore.instance.collection(
        'meals').where('mealName',  isGreaterThanOrEqualTo: query.toString())
        .where('mealName', isLessThan: query.toString() + 'z');

    return Column(
      children: [
        Flexible(
          child: StreamBuilder<QuerySnapshot>(
              stream: people.snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }
              final profiles = snapshot.data.docs;
            return ListView.builder(
              itemBuilder: (context, index) => ListTile(
              onTap: (){//ON CLICK
                query = profiles[index]['name'];
                showResults(context);
              },
                leading: Icon(Icons.people),
                title: RichText(
                 text: TextSpan(
                     text: profiles[index]['name'] + " ",
                     style: TextStyle(
                       color: Colors.black, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: profiles[index]['lastName'],
                          style: TextStyle(color: Colors.grey)
                        )
                      ]
                 ),
                ),
              ),
            itemCount: profiles.length,
          );

  }),
        ),
        Flexible(
          child: StreamBuilder<QuerySnapshot>(
              stream: mealsdb.snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
                if (snapshot2.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot2.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }
                final meals = snapshot2.data.docs;
                return ListView.builder(
                  itemBuilder: (context, index) => ListTile(
                    onTap: (){//ON CLICK
                      query = meals[index]['mealName'];
                      showResults(context);
                    },
                    leading: Icon(Icons.food_bank),
                    title: RichText(
                      text: TextSpan(
                          text: meals[index]['mealName'] + " ",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                                text: (meals[index]['seats'] - meals[index]['seats_occupied']).toString(),
                                style: TextStyle(color: Colors.grey)
                            )
                          ]
                      ),
                    ),
                  ),
                  itemCount: meals.length,
                );

              }),
        ),
      ],
    );
  
}
}