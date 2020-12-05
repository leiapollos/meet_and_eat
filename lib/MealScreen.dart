import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meet_and_eat/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MealScreen extends StatefulWidget {
  final String uid;

  const MealScreen ({ Key key, this.uid }): super(key: key);
  @override
  _MealScreen createState() => _MealScreen();
}

class _MealScreen extends State<MealScreen>{
  DateFormat _dateFormat;
  @override
  Widget build(BuildContext context) {

    print(widget.uid);
    CollectionReference meals = FirebaseFirestore.instance.collection('meals');
    CollectionReference users = FirebaseFirestore.instance.collection('profiles');

    Widget getScreen(var data) {
      return FutureBuilder<DocumentSnapshot>(
        future: users.doc(widget.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshotUser) {
          if (snapshotUser.hasError) {
            return Text("Something went wrong");
          }
          if (snapshotUser.connectionState == ConnectionState.done) {
            Map<String, dynamic> dataUser = snapshotUser.data.data();
            if(snapshotUser.data.exists && dataUser['url'] != null && dataUser['url'] != ""){
              return ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(0.0),
                children: <Widget>[
                  Stack(
                      children: [
                        Column(
                          children: <Widget>[
                            Container(
                              height: 200.0,
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                      image: NetworkImage("https://n9.cl/uc1u"),
                                      fit: BoxFit.cover
                                  )
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Text(data['mealName'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                height: 1.5,
                                fontSize: 25.0,
                                color: Color(0xff3d405b),
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text("by Joana Silva",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                height: 0.9,
                                fontSize: 20.0,
                                color: Colors.blueGrey,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Divider(
                              height: 8,
                              color: Colors.grey,
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Icon(
                                          Icons.access_time_rounded,
                                          color: Colors.blueGrey,
                                          size: 24.0,

                                        ),
                                        Icon(
                                          Icons.add_location_rounded,
                                          color: Colors.blueGrey,
                                          size: 24.0,

                                        ),
                                        Icon(
                                          Icons.airline_seat_legroom_normal_sharp,
                                          color: Colors.blueGrey,
                                          size: 24.0,

                                        ),

                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(new DateFormat.yMd().add_jm().format(DateTime.parse(data['date'])),

                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0,
                                            color: Color(0xff3d405b),
                                            letterSpacing: 0.5,

                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(data['address'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0,
                                            color: Color(0xff3d405b),
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(data['seats_occupied'].toString() + " guest, " + (data['seats'] - data['seats_occupied']).toString() +" seats left",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0,
                                            color: Color(0xff3d405b),
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            Divider(
                              height: 15,
                              color: Colors.grey,
                            ),
                            Container(
                              child: Text('Note from Joana',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  height: 1.5,
                                  fontSize: 25.0,
                                  color: Color(0xff3d405b),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: 16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      data['note'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w300,
                                        color: Color(0xff3d405b),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              height: 15,
                              color: Colors.grey,
                            ),
                            Container(
                              child: Text('Menu',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  height: 1.5,
                                  fontSize: 25.0,
                                  color: Color(0xff3d405b),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: 16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      data['menu'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w300,
                                        color: Color(0xff3d405b),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 70,
                            ),
                          ],
                        ),
                        Positioned(
                          top: 140.0, // (background container size) - (circle height / 2)
                          left: 140,
                          child: Container(
                            height: 120.0,
                            width: 120.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                                image: DecorationImage(
                                    image: NetworkImage(dataUser['url']),
                                    fit: BoxFit.cover
                                )
                            ),

                          ),
                        )
                      ]
                  ),
                ],
              );
            }
          }
          return ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(0.0),
                children: <Widget>[
                  Stack(
                    children: [
                      Column(
                        children: <Widget>[
                          Container(
                            height: 200.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                    image: NetworkImage("https://n9.cl/uc1u"),
                                    fit: BoxFit.cover
                                )
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Text(data['mealName'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              height: 1.5,
                              fontSize: 25.0,
                              color: Color(0xff3d405b),
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text("by Joana Silva",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              height: 0.9,
                              fontSize: 20.0,
                              color: Colors.blueGrey,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Divider(
                            height: 8,
                            color: Colors.grey,
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Icon(
                                        Icons.access_time_rounded,
                                        color: Colors.blueGrey,
                                        size: 24.0,

                                      ),
                                      Icon(
                                        Icons.add_location_rounded,
                                        color: Colors.blueGrey,
                                        size: 24.0,

                                      ),
                                      Icon(
                                        Icons.airline_seat_legroom_normal_sharp,
                                        color: Colors.blueGrey,
                                        size: 24.0,

                                      ),

                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                ),
                                Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(new DateFormat.yMd().add_jm().format(DateTime.parse(data['date'])),

                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0,
                                          color: Color(0xff3d405b),
                                          letterSpacing: 0.5,

                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(data['address'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0,
                                          color: Color(0xff3d405b),
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(data['seats_occupied'].toString() + " guest, " + (data['seats'] - data['seats_occupied']).toString() +" seats left",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0,
                                          color: Color(0xff3d405b),
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),
                          Divider(
                            height: 15,
                            color: Colors.grey,
                          ),
                          Container(
                            child: Text('Note from Joana',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                height: 1.5,
                                fontSize: 25.0,
                                color: Color(0xff3d405b),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: 16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    data['note'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xff3d405b),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            height: 15,
                            color: Colors.grey,
                          ),
                          Container(
                            child: Text('Menu',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                height: 1.5,
                                fontSize: 25.0,
                                color: Color(0xff3d405b),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: 16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    data['menu'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xff3d405b),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 70,
                          ),
                        ],
                      ),
                      Positioned(
                        top: 140.0, // (background container size) - (circle height / 2)
                        left: 140,
                        child: Container(
                          height: 120.0,
                          width: 120.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                              image: DecorationImage(
                                  image: NetworkImage("https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg.jpg"),
                                  fit: BoxFit.cover
                              )
                          ),

                        ),
                      )
                    ]
                  ),
                ],
              );
        },
      );
    }

    void RequestSeat(var data){
        var totalSeats = data['seats'];
        var occupied = data['seats_occupied'];
        if(totalSeats - occupied > 0){
          occupied += 1;
        }

        meals.doc(widget.uid).update({'seats_occupied' : occupied});
        setState(() {
          
        });
    }

    return FutureBuilder<DocumentSnapshot>(
      future: meals.doc(widget.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          if(snapshot.data.exists){
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Color(0xff3d405b),
                title: Text('Book/Contact'),
                //data['mealName']
                centerTitle: true,
                actions: <Widget>[
                  /*IconButton(icon: Icon(Icons.arrow_back_sharp),
                      onPressed: (){

                      })*/
                ],
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
              floatingActionButton: FloatingActionButton.extended(
                heroTag: "btn3",
                backgroundColor: const Color(0xff81b29a),

                onPressed: () {
                  // Respond to button press
                  RequestSeat(data);
                },
                icon: Icon(Icons.add_to_home_screen_rounded),
                label: Text("Request a Seat",
                  style: TextStyle(color: Colors.white, fontSize: 26.0, fontWeight:FontWeight.w300),
                ),
              ),
              body: getScreen(data),
            );
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Profile'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Profile"),
              ],
            ),
          ),
        );
      },
    );


  }
}

