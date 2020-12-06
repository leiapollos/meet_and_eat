import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meet_and_eat/RateScreen.dart';
import 'package:meet_and_eat/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:meet_and_eat/MealScreen.dart';

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
    Widget passed;
    Widget result;
    List<Widget> mealList = new List<Widget>();
    List<Widget> passedMealList = new List<Widget>();



    Widget Meal(var mealId, bool passed){
      return FutureBuilder(
          future: mealsdb.doc(mealId).get(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshotMeal) {
              var meal = snapshotMeal.data?.data();
              if(meal == null)
                return Center();
              print(meal['mealName']);
              if((!passed && DateTime.parse(meal['date']).isBefore(DateTime.now())) || (passed && DateTime.parse(meal['date']).isAfter(DateTime.now()))){
                return Center();
              }
              return Center(
                child: FlatButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => passed ? RatingScreen(uid: mealId) : MealScreen(uid: mealId)),
                    );
                  },
                  height: 100,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                    color: Color(0xfffafafa),
                    elevation: 0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 100,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: Image.network(meal['url'] == "" ? "https://media.istockphoto.com/photos/picking-slice-of-pepperoni-pizza-picture-id1133727757?k=6&m=1133727757&s=612x612&w=0&h=6wLUhTKLTudlkgLXQxdOZIVr6D9zuIcMJhpgTVmOWMo%3D" : meal['url']),
                          ),
                        ),
                        Center(
                          child: Column(
                            children: [
                              Center(
                                child: Text(meal['mealName'], textAlign: TextAlign.center,
                                    style: TextStyle(color: Color(0xff3d405b), fontSize: 20.0, fontWeight:FontWeight.bold)),
                              ),
                              SizedBox(height: 8,),
                              Center(
                                child: Row(
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
                      ],
                    ),
                  ),
                ),
              );
          }
          );
    }

    Widget getMyMeals(bool passed) {
      return FutureBuilder(
        future: usersdb.doc(uid).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshotUser) {
          mealList.clear();
          passedMealList.clear();
          var me = snapshotUser.data?.data();
          if(me == null)
            return Center();
          if(me['meals'].length == 0){
            return Text("No booked meals!");
          }
          if(me['meals'].length == 1){
              if(me['meals'][0] == ""){
                return Text("No booked meals!");
              }
          }
          for(int i = 0; i < me['meals'].length; i++){
            var m = me['meals'][i].toString();
            if(m != ""){
              mealList.add(Meal(m, false));
              passedMealList.add(Meal(m, true));
            }
            print(i);
          }
          if(!passed){
            if(mealList.length > 0)
              return Container(
                child: ListView(
                  children: <Widget>[
                    ...mealList,
                  ],
                ),
              );
            else
              return Center(
                child: Text("No meals!"),
              );
          }else{
            if(passedMealList.length > 0)
              return Container(
                child: ListView(
                  children: <Widget>[
                    ...passedMealList,
                  ],
                ),
              );
            else
              return Center(
                child: Text("No passed meals!"),
              );
          }

        },
      );
    }

    result = getMyMeals(false);
    passed = getMyMeals(true);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: TabBar(
            unselectedLabelColor: Color(0xffc1c1c1),
              labelColor: Color(0xff4a4d66),
              indicatorColor: Color(0xffc1c1c1),
              onTap: (index) {
                // Tab index when user select it, it start from zero
              },
              tabs: [
                Container(
                  child: Center(
                      child: Text(
                          "Accepted",
                          style: TextStyle(fontSize: 19),
                      )
                  ),
                  height: 40,
                ),
                Container(
                  child: Center(
                      child: Text(
                          "Passed",
                          style: TextStyle(fontSize: 19),
                      )
                  ),
                  height: 40,
                ),
              ],
            ),
          body: TabBarView(
            children: [
             result,
             passed,
            ],
          ),
        ),
      );
  }
}