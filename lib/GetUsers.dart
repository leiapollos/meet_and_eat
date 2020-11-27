import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meet_and_eat/ProfileScreen.dart';


class GetUsers extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection(
        'profiles');

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
              itemBuilder: (context, index) =>
                  FlatButton(
                    onPressed: () {
                      //print(profiles[index].id);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileScreen(uid: profiles[index].id)),
                      );
                    },
                    child: Container(
                      
                      //onPressed:() => {},
                      width: MediaQuery.of(context).size.width * 0.94,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Colors.white,
                        elevation: 3,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width * 0.28,
                                  maxHeight: MediaQuery.of(context).size.width * 0.28,
                                ),
                                child: CircleAvatar(
                                  radius: 45,
                                  backgroundImage: (profiles[index]['url'] != null && profiles[index]['url'].toString().isNotEmpty)
                                      ? NetworkImage(profiles[index]['url']) : AssetImage('assets/images/chimo.png'),
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}