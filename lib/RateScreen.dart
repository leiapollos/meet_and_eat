import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meet_and_eat/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:meet_and_eat/MealScreen.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingScreen extends StatefulWidget {
  final String uid;

  const RatingScreen ({ Key key, this.uid }): super(key: key);
  @override
  _RatingScreen createState() => _RatingScreen();
}

Widget _image(String asset) {
  return Image.asset(
    asset,
    height: 30.0,
    width: 30.0,
    color: Colors.amber,
  );
}

class _RatingScreen extends State<RatingScreen>{
  DateFormat _dateFormat;
  final TextEditingController noteController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff3d405b),
        title: Text("Rate Joana as a Cook"),
        centerTitle: true,
        actions: <Widget>[
          /*IconButton(icon: Icon(Icons.arrow_back_sharp),
                      onPressed: (){

                      })*/
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "btn5",
        backgroundColor: const Color(0xff81b29a),

        onPressed: () {
          // Respond to button press

        },
        icon: Icon(Icons.add_to_home_screen_rounded),
        label: Text("Rate",
          style: TextStyle(color: Colors.white, fontSize: 26.0, fontWeight:FontWeight.w300),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        //padding: EdgeInsets.all(15.0),
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://cdn.pixabay.com/photo/2013/07/13/12/07/avatar-159236_640.png',
                          ),
                          radius: 60.0,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Basketball Party",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            height: 1.5,
                            fontSize: 20.0,
                            color: Colors.blueGrey,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text("by Joana Silva",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            height: 0.9,
                            fontSize: 25.0,
                            color: Color(0xff3d405b),
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.access_time_rounded, color:Colors.blueGrey,
                                    size: 25.0),
                                SizedBox(
                                  height: 10,
                                ),
                                Icon(Icons.airline_seat_legroom_normal, color:Colors.blueGrey,
                                    size: 25.0),
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Date",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: Color(0xff3d405b),
                                    letterSpacing: 0.5,

                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text("2 guest",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: Color(0xff3d405b),
                                    letterSpacing: 0.5,

                                  ),
                                ),

                              ],
                            ),
                          ],
                        ),
                        Divider(
                          height: 15,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(
                  height: 0,
                  color: Colors.grey,
                ),
                Text('Rate Joana as a Cook',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                    fontSize: 25.0,
                    color: Color(0xff3d405b),
                    letterSpacing: 0.5,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Food quality",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            height: 1.5,
                            fontSize: 18.0,
                            color: Colors.blueGrey,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Ambience",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            height: 1.5,
                            fontSize: 18.0,
                            color: Colors.blueGrey,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Cleanliness",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            height: 1.5,
                            fontSize: 18.0,
                            color: Colors.blueGrey,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RatingBar.builder(
                          itemSize: 30,
                          initialRating: 3,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 0.5),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Color(0xff3d405b),
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        RatingBar.builder(
                          itemSize: 30,
                          initialRating: 3,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 0.5),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Color(0xff3d405b),
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        RatingBar.builder(
                          itemSize: 30,
                          initialRating: 3,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 0.5),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Color(0xff3d405b),
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  height: 0,
                  color: Colors.grey,
                ),
                Text('Add Comment',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                    fontSize: 25.0,
                    color: Color(0xff3d405b),
                    letterSpacing: 0.5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child:  TextField(
                    //controller: noteController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Obrigado Jesus',
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Color(0xff3d405b), width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Color(0xff3d405b), width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                    ),

                  ),
                ),
                SizedBox(
                  height: 140,
                ),




              ],
            ),
          ),
        ],
      ),
    );
  }
}

