import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meet_and_eat/authentication_service.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen ({ Key key, this.uid }): super(key: key);
  @override
  _ProfileScreen createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen>{

  @override
  Widget build(BuildContext context) {
    print(widget.uid);
    CollectionReference users = FirebaseFirestore.instance.collection('profiles');
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
                title: Text(data['name'] + "'s Profile"),
                actions: <Widget>[
                  /*IconButton(icon: Icon(Icons.arrow_back_sharp),
                      onPressed: (){

                      })*/
                ],
              ),
              body: Column(
                children: <Widget>[
                  Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.redAccent, Colors.pinkAccent]
                          )
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 350.0,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg.jpg",
                                ),
                                radius: 50.0,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                data['name'] + ' ' + data['lastName'],
                                style: TextStyle(
                                  fontSize: 22.0,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                            ],
                          ),
                        ),
                      )
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30.0,horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Bio:",
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontStyle: FontStyle.normal,
                                fontSize: 28.0
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(data['biography'],
                            style: TextStyle(
                              fontSize: 22.0,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              letterSpacing: 2.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    width: 300.00,

                    child: RaisedButton(
                        onPressed: (){},
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0)
                        ),
                        elevation: 0.0,
                        padding: EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                                colors: [Colors.redAccent,Colors.pinkAccent]
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                            alignment: Alignment.center,
                            child: Text("Contact me",
                              style: TextStyle(color: Colors.white, fontSize: 26.0, fontWeight:FontWeight.w300),
                            ),
                          ),
                        )
                    ),
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