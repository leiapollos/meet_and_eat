import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meet_and_eat/ChatSystem.dart';
import 'package:meet_and_eat/ProfileScreen.dart';

import 'package:meet_and_eat/authentication_service.dart';
import 'package:provider/provider.dart';

class ChatList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection(
        'profiles');
    final uid = context.watch<AuthenticationService>().getUserId();
    return StreamBuilder<QuerySnapshot>(
      stream: users.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        final profiles = snapshot.data.docs;
        return Expanded(
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              //shrinkWrap: true,
              itemCount: profiles.length,
              itemBuilder: (context, index) {
                if(profiles[index].id == uid)
                  return Center();
                return FlatButton(
                  onPressed: () {
                    //print(profiles[index].id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatSystem(otherName: profiles[index]['name'], otheruid: profiles[index].id, myuid: uid,),),
                    );
                  },
                  child: Container(

                    //onPressed:() => {},
                    width: MediaQuery.of(context).size.width * 0.94,
                    child: Container(
                      color: Colors.white,
                      //elevation: 3,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 45,
                                    backgroundImage: (profiles[index]['url'] != null && profiles[index]['url'].toString().isNotEmpty)
                                        ? NetworkImage(profiles[index]['url']) : NetworkImage("https://cdn.pixabay.com/photo/2013/07/13/12/07/avatar-159236_640.png"),
                                    backgroundColor: Colors.blue,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(profiles[index]['name'] + " " + profiles[index]['lastName'],
                                    style: const TextStyle(fontSize: 19.0, fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),

                            ],
                          ),
                          Divider(
                            height: 0,
                            color: Colors.black,
                          ),


                          /*Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.28,
                                maxHeight: MediaQuery.of(context).size.width * 0.28,
                              ),
                              child: CircleAvatar(
                                radius: 45,
                                backgroundImage: (profiles[index]['url'] != null && profiles[index]['url'].toString().isNotEmpty)
                                    ? NetworkImage(profiles[index]['url']) : NetworkImage("https://cdn.pixabay.com/photo/2013/07/13/12/07/avatar-159236_640.png"),
                                backgroundColor: Colors.blue,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(title: Text(profiles[index]['name'] + " " + profiles[index]['lastName'], style: const TextStyle(fontSize: 19.0, fontWeight: FontWeight.w700),),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(left: 0, top: 5, right: 0, bottom: 0),
                                child: Text(profiles[index]['age'].toString(), style: const TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500),),
                              ),),
                          ),*/
                        ],
                      ),
                    ),
                  ),
                );
              }

          ),
        );
      },
    );
  }
}