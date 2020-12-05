import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meet_and_eat/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class BookingsScreen extends StatefulWidget {
  final String uid;

  const BookingsScreen ({ Key key, this.uid }): super(key: key);
  @override
  _BookingsScreen createState() => _BookingsScreen();
}

class _BookingsScreen extends State<BookingsScreen>{
  DateFormat _dateFormat;
  @override
  Widget build(BuildContext context) {
    CollectionReference mealsdb = FirebaseFirestore.instance.collection('meals');
    CollectionReference usersdb = FirebaseFirestore.instance.collection('profiles');
    final uid = context.watch<AuthenticationService>().getUserId();

    Widget Meal(var mealId){
      return FutureBuilder(
          future: mealsdb.doc(mealId).get(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshotMeal) {
              var meal = snapshotMeal.data.data();
              print(meal['mealName']);
              return Center(
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
                                image: NetworkImage("https://n9.cl/uc1u"),
                                fit: BoxFit.cover
                            )
                        ),
                      ),
                      Center(
                        child: Text(meal['mealName'], textAlign: TextAlign.center,
                            style: TextStyle(color: Color(0xff3d405b), fontSize: 20.0, fontWeight:FontWeight.bold)),
                      ),
                      FutureBuilder<DocumentSnapshot>(
                          future: usersdb.doc(mealId).get(),
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
                                          ? NetworkImage(data['url']) : AssetImage('assets/images/chimo.png'),
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
                                    text: new DateFormat.yMd().add_jm().format(DateTime.parse(meal['date'])),//TODO CHANGE TIME
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
                                    text: " " + (meal['seats'] - meal['seats_occupied']).toString() + " seats available",
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
              );
          }
          );
    }

    Widget getMyMeals() {
      return FutureBuilder(
        future: usersdb.doc(uid).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshotUser) {

          var me = snapshotUser.data.data();
          print(me['name']);
          List<Widget> mealList = new List<Widget>();
          for(int i = 0; i < me['meals'].length; i++){
            var m = me['meals'][i].toString();
            if(m != ""){
              mealList.add(Meal(m));
            }
            print(i);
          }
          if(mealList.length > 0)
            return Container(
              child: ListView(
                children: <Widget>[
                      ...mealList,
                ],
              ),
            );
          else
            return null;
        },
      );
    }

    Widget result = getMyMeals();
    if(result == null){
      result = Text("No meals!");
    }
    return Center(
      child: result,
    );
    /*return StreamBuilder(
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

        return StreamBuilder(
            stream: usersdb.snapshots(),
            builder: (context, snapshot2) {
              if (snapshot2.hasError) {
                return Text('Something went wrong');
              }
              if (snapshot2.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }
              final users = snapshot2.data.docs;
              print(users.length);
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.all(0.0),
                  shrinkWrap: true,
                  itemCount: meals.length,
                  itemBuilder: (context, index) => getMyMeals(meals, users, index),
              );
            });
    });*/
  }
}