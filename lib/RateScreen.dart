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
  CollectionReference usersdb = FirebaseFirestore.instance.collection('profiles');
  CollectionReference mealsdb = FirebaseFirestore.instance.collection('meals');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: mealsdb.doc(widget.uid).get(),
       builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshotRate)
       {
         var mealData = snapshotRate.data?.data();
         if(mealData == null)
           return Center();
         return FutureBuilder(
             future: usersdb.doc(widget.uid).get(),
             builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshotRate2)
             {
               var userData = snapshotRate2.data?.data();
               if(userData == null)
                 return Center();
               return Scaffold(
                 appBar: AppBar(
                   backgroundColor: Color(0xff3d405b),
                   title: Text("Rate " + userData['name'] + " as a Cook"),
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
                     showDialog(
                       context: context,
                       builder: (_) => new AlertDialog(
                         backgroundColor: const Color(0xff81b29a),
                         title: Text("Thanks for rating your cook!", style: TextStyle(color: Colors.white),),
                         actions: [
                           FlatButton(
                             child: Text('Tap outside to close me!', style: TextStyle(color: Colors.white),),
                             onPressed: () {
                             },
                           ),
                         ],
                       ),
                     );

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
                                       userData['url'] == "" ? 'https://cdn.pixabay.com/photo/2013/07/13/12/07/avatar-159236_640.png' : userData['url'],
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
                                   Text(mealData['mealName'],
                                     textAlign: TextAlign.center,
                                     style: TextStyle(
                                       fontWeight: FontWeight.normal,
                                       height: 1.5,
                                       fontSize: 25.0,
                                       color: Colors.blueGrey,
                                       letterSpacing: 0.5,
                                     ),
                                   ),
                                   Text("by " + userData['name'] + " " + userData['lastName'],
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
                                           Text(new DateFormat.yMd().add_jm().format(DateTime.parse(mealData['date'])),
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
                                           Text(mealData['seats_occupied'].toString() + " guest(s)",
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
                           Text('What was your overall experience?',
                             textAlign: TextAlign.center,
                             style: TextStyle(
                               fontWeight: FontWeight.bold,
                               height: 1.5,
                               fontSize: 25.0,
                               color: Color(0xff3d405b),
                               letterSpacing: 0.5,
                             ),
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
                                 hintText: 'Comment about your experience.',
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
                             height: 260,
                           ),




                         ],
                       ),
                     ),
                   ],
                 ),
               );
             }
         );
       },
    );
  }
}

