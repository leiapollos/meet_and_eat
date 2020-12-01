import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meet_and_eat/authentication_service.dart';
import 'package:provider/provider.dart';

class MealScreen extends StatefulWidget {
  final String uid;

  const MealScreen ({ Key key, this.uid }): super(key: key);
  @override
  _MealScreen createState() => _MealScreen();
}

class _MealScreen extends State<MealScreen>{

  @override
  Widget build(BuildContext context) {
    print(widget.uid);
    CollectionReference users = FirebaseFirestore.instance.collection('meals');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.uid).get(),
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
                },
                icon: Icon(Icons.add_to_home_screen_rounded),
                label: Text("Request a Seat",
                  style: TextStyle(color: Colors.white, fontSize: 26.0, fontWeight:FontWeight.w300),
                ),
              ),
              body: ListView(
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
                                      Text("Time",
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
                                      Text("Location",
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
                                      Text("1 guest, 2 seats left",
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
                                    //data['biography'],
                                    'My name is Alice and I am  a freelance mobile app developper.\n'
                                        'if you need any mobile app for your company then contact me for more informations',
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
                                    //data['biography'],
                                    'My name is Alice and I am  a freelance mobile app developper.\n'
                                        'if you need any mobile app for your company then contact me for more informations',
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
              ),
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

