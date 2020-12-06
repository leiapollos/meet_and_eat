import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meet_and_eat/ChatSystem.dart';
import 'package:meet_and_eat/ProfileScreen.dart';
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
            if(snapshotUser.data.exists && dataUser['url'] != null){
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
                                      image: NetworkImage(data['url'] == "" ? "https://media.istockphoto.com/photos/picking-slice-of-pepperoni-pizza-picture-id1133727757?k=6&m=1133727757&s=612x612&w=0&h=6wLUhTKLTudlkgLXQxdOZIVr6D9zuIcMJhpgTVmOWMo%3D" : data['url']),
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
                            Text("by ${dataUser['name']} ${dataUser['lastName']}",
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
                              child: Text('Note from ${dataUser['name']}',
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
                          left: MediaQuery.of(context).size.width/2 - 70,
                          child: FlatButton(
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ProfileScreen(uid: widget.uid,)),
                              );
                            },
                            child: Container(
                              height: 120.0,
                              width: 120.0,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                  image: DecorationImage(
                                      image: NetworkImage(dataUser['url'] == "" ? 'https://cdn.pixabay.com/photo/2013/07/13/12/07/avatar-159236_640.png' : dataUser['url']),
                                      fit: BoxFit.cover
                                  )
                              ),

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
                                    image: NetworkImage("https://media.istockphoto.com/photos/picking-slice-of-pepperoni-pizza-picture-id1133727757?k=6&m=1133727757&s=612x612&w=0&h=6wLUhTKLTudlkgLXQxdOZIVr6D9zuIcMJhpgTVmOWMo%3D"),
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
                                  image: NetworkImage(
                                    'https://cdn.pixabay.com/photo/2013/07/13/12/07/avatar-159236_640.png',
                                  ),
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
        var participants = data['users'];
        var myId  = context.read<AuthenticationService>().getUserId().toString();
        bool registered = false;
        for(int i = 0; i < participants.length; i ++){
          print(participants[i]);
          if(participants[i].toString() == myId.toString())
            registered = true;
        }
        if(!registered){
          participants.add(myId);
          if(totalSeats - occupied > 0){
            occupied += 1;
          }
          users.doc(myId).get().then((value)  {
              var myMeals = value['meals'];
              bool haveMeal = false;
              for(int i = 0; i < myMeals.length; i++){
                if(myMeals[i].toString() == widget.uid)
                  haveMeal = true;
              }
              if(!haveMeal){
                myMeals.add(widget.uid);
                users.doc(myId).update({'meals': myMeals});
              }
          });
          meals.doc(widget.uid).update({'seats_occupied' : occupied, 'users': participants});
          setState(() {

          });
        }
    }

    return FutureBuilder<DocumentSnapshot>(
      future: meals.doc(widget.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

          _showMaterialDialog(var data) {
            showDialog(
              context: context,
              builder: (_) => new AlertDialog(
                backgroundColor: const Color(0xff81b29a),
                title: Center(
                  child: new Text(
                    'COVID-19 ALERT', style: TextStyle(color: Colors.white),
                    ),
                ),
                content: Container(
                    child: Center(
                        child: Text(
                          "Have you been in contact with anyone who has tested positive in the last 14 days?",
                          style: TextStyle(color: Colors.white,),
                          textAlign: TextAlign.justify,
                        )
                    ),
                  height: 60,

                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('NO', style: TextStyle(color: Colors.white),),
                    onPressed: () {
                      RequestSeat(data);
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (_) => new AlertDialog(
                          backgroundColor: const Color(0xff81b29a),
                          title: Text("Congratulations in registering!", style: TextStyle(color: Colors.white),),
                          actions: [
                            FlatButton(
                              child: Text('Send Message!', style: TextStyle(color: Colors.white),),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ChatSystem(otheruid: widget.uid,)),);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    width: 150,
                  ),
                  FlatButton(
                    child: Text('YES', style: TextStyle(color: Colors.white),),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          }

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
                  _showMaterialDialog(data);
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

