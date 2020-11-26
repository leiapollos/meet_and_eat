import 'package:flutter/material.dart';
import 'package:meet_and_eat/ImagePicker.dart';
import 'package:meet_and_eat/menu.dart';
import 'package:meet_and_eat/RegisterProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meet_and_eat/authentication_service.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Profile extends StatelessWidget {
  final String documentId;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  Profile(this.documentId);
  bool edit = false;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('profiles');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        CollectionReference users = FirebaseFirestore.instance.collection('profiles');
        final uid = context.watch<AuthenticationService>().getUserId();
        Future<void> addUser(String name, String lastName, int age) {
          // Call the user's CollectionReference to add a new user
          return users
             .doc(uid)
             .set({
              'name': name,
              'lastName': lastName,
              'age': age,
              'location': "",
              'biography': "",
              'url': ""
              })
              .then((value) => {
                print("User Added"),
            //Reload Profile
                Navigator.pop(context),
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile(uid)),)
              })
              .catchError((error) => print("Failed to add user: $error"));
        }
        _showMaterialDialog(String text) {
          showDialog(
              context: context,
              builder: (_) => new AlertDialog(
                title: new Text("Error"),
                content: new Text(text),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Close me!'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ));
        }
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          if(snapshot.data.exists){
            return Scaffold(
              appBar: AppBar(
                title: Text('Profile'),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ImagePickerWidget(uid: uid),
                    Text(data['name'] + " " + data['lastName']),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Material(
                        color: Colors.lightBlueAccent,
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        elevation: 5.0,
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RegisterProfile()),
                            );
                          },
                          minWidth: 200.0,
                          height: 42.0,
                          child: Text(
                            'Edit Profile',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          else{
            return Scaffold(
              appBar: AppBar(
                title: Text('Profile'),
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 48.0,
                      ),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: 'Your Name',
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                            borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                            borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      TextField(
                        controller: lastNameController,
                        decoration: InputDecoration(
                          hintText: 'Your Last Name',
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                            borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                            borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          ),
                        ),

                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      TextField(
                        controller: ageController,
                        decoration: InputDecoration(
                          hintText: 'Your Age',
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                            borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                            borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          ),
                        ),

                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Material(
                          color: Colors.lightBlueAccent,
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          elevation: 5.0,
                          child: MaterialButton(
                            onPressed: () {
                              String name = nameController.text.trim();
                              String lastName = lastNameController.text.trim();
                              String age = ageController.text.trim();
                              if(name == "" || lastName == "" || age == ""){
                                _showMaterialDialog("Please fill in all the fields.");
                              }
                              else {
                                addUser(
                                    name,
                                    lastName,
                                    int.parse(age)
                                );
                              }
                            },
                            minWidth: 200.0,
                            height: 42.0,
                            child: Text(
                              'Add Info',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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