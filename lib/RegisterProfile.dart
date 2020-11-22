import 'package:flutter/material.dart';
import 'package:meet_and_eat/ImagePicker.dart';
import 'package:meet_and_eat/menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meet_and_eat/authentication_service.dart';
import 'package:meet_and_eat/GetUsers.dart';
import 'package:provider/provider.dart';

import 'Profile.dart';

class RegisterProfile extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController biographyController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('profiles');
    final uid = context.watch<AuthenticationService>().getUserId();
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
    Future<void> addUser() {
      String name = nameController.text.trim();
      String lastName = lastNameController.text.trim();
      String age = ageController.text.trim();
      String location = locationController.text.trim();
      String biography = biographyController.text.trim();
      if(name == "" || lastName == "" || age == "" || location == "" || biography == ""){
        _showMaterialDialog("Please fill in all the fields.");
      }
      // Call the user's CollectionReference to add a new user
      return users
          .doc(uid)
          .update({
        'name': name,
        'lastName': lastName,
        'age': age,
        'location': location,
        'biography': biography,
      })
          .then((value) => {
        print("User Added"),
        Navigator.pop(context), //Pop out of register profile
        //Reload Profile
          Navigator.pop(context),
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Profile(uid)),)
        })
          .catchError((error) => print("Failed to add user: $error"));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Editing Profile'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImagePickerWidget(uid: uid),
              SizedBox(
                height: 8.0,
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
                height: 8.0,
              ),
              TextField(
                controller: locationController,
                decoration: InputDecoration(
                  hintText: 'Your Location',
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
                controller: biographyController,
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'A Desciption of Yourself',
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
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
                        addUser();
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'Edit Info',
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