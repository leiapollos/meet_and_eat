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
  Widget getCuisine(var name, var imageUrl){
    return Container(
      width: MediaQuery.of(context).size.width * 0.60,
      child: FlatButton(
        onPressed: () => {

        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.0),
          ),
          color: Color(0xfffafafa),
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
                        image: AssetImage("assets/images/${imageUrl}"),
                        fit: BoxFit.cover
                    )
                ),
              ),
              Center(
                child: Text(name, textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xff3d405b), fontSize: 20.0, fontWeight:FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
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
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 168),
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.all(0.0),
              shrinkWrap: true,
              children: [
              getCuisine("Asian", "image1.jpg"),
              getCuisine("Swedish", "image2.jpg"),
              getCuisine("English", "image4.jpg"),
              getCuisine("Greek", "image5.jpg"),
              ],
            ),
          ),
          Text(
            "Covid-19 safety",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 200),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 134.0,
                    width: 134,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            image: AssetImage("assets/images/covid.jpg"),
                            fit: BoxFit.cover
                        )
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "We ask all the cooks and guests to confirm that they free of COVID-19 sysmptoms before attending Meet&Eat event. We also ask participants to limit the physical contact.",
                      textAlign: TextAlign.center,
                      maxLines: 7,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff3d405b),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),


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

    return StreamBuilder(
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
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 263),
          child: ListView.builder(
            physics: ClampingScrollPhysics(),
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
                      color: Color(0xfffafafa),
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
          ),
        );
      }
    );
  }
}