import 'package:flutter/material.dart';
import 'package:meet_and_eat/menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meet_and_eat/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:meet_and_eat/GetUsers.dart';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'MealScreen.dart';

class HomePageContent extends StatefulWidget {
  HomePageContent({Key key}) : super(key: key);

  @override
  _HomePageContent createState() => _HomePageContent();
}

class _HomePageContent extends State<HomePageContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              "Nearby",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
          ),
          MealsNearby(),
          Text(
            "Cuisines",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
          ),
          MealsNearby(),
        ],
      ),
    );
  }
}

class MealsNearby extends StatefulWidget {
  MealsNearby({Key key}) : super(key: key);

  @override
  _MealsNearby createState() => _MealsNearby();
}

class _MealsNearby extends State<MealsNearby> {
  @override
  Widget build(BuildContext context) {
    final double categoryHeight = MediaQuery.of(context).size.height * 0.25 - 50;
    final mealsdb = FirebaseFirestore.instance.collection('meals');
    final profiles = FirebaseFirestore.instance.collection('profiles');

    return Expanded(
      child: StreamBuilder(
          stream: mealsdb.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          final meals = snapshot.data.docs;
          print(meals.length);
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(0.0),
            shrinkWrap: true,
            itemCount: meals.length,
            itemBuilder: (context, index) =>
                Container(
                  width: MediaQuery.of(context).size.width * 0.60,
                  child: FlatButton(
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MealScreen(uid: meals[index].id)),
                      )
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      color: Colors.white,
                      elevation: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 134.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                    image: NetworkImage(meals[index]['url'] == "" ? "https://media.istockphoto.com/photos/picking-slice-of-pepperoni-pizza-picture-id1133727757?k=6&m=1133727757&s=612x612&w=0&h=6wLUhTKLTudlkgLXQxdOZIVr6D9zuIcMJhpgTVmOWMo%3D" : meals[index]['url']),
                                    fit: BoxFit.cover
                                )
                            ),
                          ),
                          Center(
                            child: Text(meals[index]['mealName'], textAlign: TextAlign.center,
                                style: TextStyle(color: Color(0xff3d405b), fontSize: 20.0, fontWeight:FontWeight.bold)),
                          ),
                          FutureBuilder<DocumentSnapshot>(
                            future: profiles.doc(meals[index].id).get(),
                            builder:
                            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text("Something went wrong");
                              }
                              if (snapshot.connectionState == ConnectionState.done) {
                                  Map<String, dynamic> data = snapshot.data.data();
                                  if(data.isNotEmpty && data != null)
                                    return Row(
                                    children: [
                                      SizedBox(width: 20,),
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundImage: (data['url'] != null && data['url'].toString().isNotEmpty)
                                            ? NetworkImage(data['url']) : NetworkImage(
                                          'https://cdn.pixabay.com/photo/2013/07/13/12/07/avatar-159236_640.png',
                                        ),
                                        backgroundColor: Colors.blue,
                                      ),
                                      Text("   " + data['name'], style: TextStyle(fontWeight: FontWeight.normal,
                                          height: 1.5,
                                          fontSize: 18.0,
                                          color: Color(0xff3d405b),
                                          letterSpacing: 0.5),),
                                    ],
                                  );
                                  else
                                    return Text("No profile data");
                              }
                              return Text("Name");
                            }),
                          //Text(meals[index]['date']),
                          Row(
                            children: [
                              SizedBox(width: 10,),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Icon(Icons.access_time_rounded, size: 22),
                                    ),
                                    TextSpan(
                                      //text: meals[index]['date'],
                                        text: new DateFormat.yMd().add_jm().format(DateTime.parse(meals[index]['date'])),//TODO CHANGE TIME
                                        style: TextStyle(fontWeight: FontWeight.normal,
                                            height: 1.5,
                                            fontSize: 15.5,
                                            color: Color(0xff3d405b),
                                            letterSpacing: 0.5)
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(width: 10,),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Icon(Icons.airline_seat_legroom_normal, size: 22),
                                    ),
                                    TextSpan(
                                      //text: meals[index]['date'],
                                        text: " " + (meals[index]['seats'] - meals[index]['seats_occupied']).toString() + " seats available",
                                        style: TextStyle(fontWeight: FontWeight.normal,
                                            height: 0,
                                            fontSize: 18.0,
                                            color: Color(0xff3d405b),
                                            letterSpacing: 0.5)
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          );
          /*return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: FittedBox(
                fit: BoxFit.fill,
                alignment: Alignment.topCenter,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 150,
                      margin: EdgeInsets.only(right: 10),
                      height: categoryHeight,
                      decoration: BoxDecoration(color: Colors.blue.shade400, borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://n9.cl/uc1u"
                              ),
                              fit: BoxFit.cover
                          )),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 100.0),
                        child: Container(
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4)),
                            color: Colors.black.withOpacity(0.5),
                          ),
                          child: Center(
                            child: Text("CHIMO",
                                style: TextStyle(fontSize: 15, color: Colors.white),
                                textAlign: TextAlign.center),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 150,
                      margin: EdgeInsets.only(right: 10),
                      height: categoryHeight,
                      decoration: BoxDecoration(color: Colors.blue.shade400, borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://n9.cl/uc1u"
                              ),
                              fit: BoxFit.cover
                          )),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 100.0),
                        child: Container(
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4)),
                            color: Colors.black.withOpacity(0.5),
                          ),
                          child: Center(
                            child: Text("CHIMO",
                                style: TextStyle(fontSize: 15, color: Colors.white),
                                textAlign: TextAlign.center),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 150,
                      margin: EdgeInsets.only(right: 10),
                      height: categoryHeight,
                      decoration: BoxDecoration(color: Colors.blue.shade400, borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://n9.cl/uc1u"
                              ),
                              fit: BoxFit.cover
                          )),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 100.0),
                        child: Container(
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4)),
                            color: Colors.black.withOpacity(0.5),
                          ),
                          child: Center(
                            child: Text("CHIMO",
                                style: TextStyle(fontSize: 15, color: Colors.white),
                                textAlign: TextAlign.center),
                          ),
                        ),
                      ),

                    ),
                  ],
                ),
              ),
            ),
          );*/
        }
      ),
    );
  }
}