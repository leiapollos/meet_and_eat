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
  final TextEditingController locationController = TextEditingController();
  final TextEditingController biographyController = TextEditingController();
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
          // Call the user's CollectionReference to add a new user
          String name = nameController.text.trim();
          String lastName = lastNameController.text.trim();
          String age = ageController.text.trim();
          String location = locationController.text.trim();
          String biography = biographyController.text.trim();
          if(name == "" || lastName == "" || age == "" || location == "" || biography == ""){
            _showMaterialDialog("Please fill in all the fields.");
          }
          return users
             .doc(uid)
             .set({
              'name': name,
              'lastName': lastName,
              'age': int.parse(age),
              'location': location,
              'biography': biography,
              'url': "",
              'meals': ['']
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

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          if(snapshot.data.exists){
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Color(0xff3d405b),
                title: Text(data['name'] + "'s Profile"),
                centerTitle: true,
                actions: <Widget>[
                  /*IconButton(icon: Icon(Icons.arrow_back_sharp),
                      onPressed: (){

                      })*/
                ],
              ),
              body: Center(
                child: ListView(
                  shrinkWrap: true,
                  //padding: EdgeInsets.all(15.0),
                  children: <Widget>[
                    Container(
                      color: Color(0xfffafafa),
                      child: Column(
                        children: <Widget>[
                          Container(

                              child: Container(
                                width: double.infinity,
                                height: 210.0,
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          data['url'] == "" ? "https://cdn.pixabay.com/photo/2013/07/13/12/07/avatar-159236_640.png" : data['url'],
                                        ),
                                        radius: 70.0,
                                      ),
                                      Text(
                                        data['name'] + ' ' + data['lastName'],
                                        style: TextStyle(
                                          fontSize: 22.0,
                                          color: Color(0xff3d405b),
                                          fontWeight: FontWeight.bold,
                                          height: 1.5,
                                        ),
                                      ),
                                      Text(
                                        data['location'],///ADD LOCATION DATA
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                          ),
                          Divider(
                            height: 0,
                            color: Colors.grey,
                          ),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                SizedBox(
                                  width: 50,
                                ),
                                Container(
                                  child: Text('Biography',
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
                                          data['biography'],
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
                              ],
                            ),
                          ),
                          Divider(
                            height: 15,
                            color: Colors.grey,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Material(
                              color:Color(0xff81b29a),
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
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 58,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
            /*return Scaffold(
              appBar: AppBar(
                title: Text('Profile'),
                backgroundColor: Color(0xff3d405b),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ImagePickerWidget(uid: uid),
                    Text(data['name'] + " " + data['lastName'],
                       style: TextStyle( color: Color(0xff3d405b), fontSize: 26.0, fontWeight: FontWeight.bold,)),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Material(
                        color:Color(0xff81b29a),
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
                             style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );*/
          }
          else{
            return Scaffold(
              appBar: AppBar(
                title: Text('Profile'),
                backgroundColor: Color(0xff3d405b),
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView(
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
                            BorderSide(color: Color(0xff3d405b), width: 1.0),
                            borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Color(0xff3d405b), width: 2.0),
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
                            BorderSide(color:Color(0xff3d405b), width: 1.0),
                            borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Color(0xff3d405b), width: 2.0),
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
                            BorderSide(color: Color(0xff3d405b), width: 1.0),
                            borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Color(0xff3d405b), width: 2.0),
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
                            BorderSide(color: Color(0xff3d405b), width: 1.0),
                            borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Color(0xff3d405b), width: 2.0),
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
                      SizedBox(
                        height: 24.0,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Material(
                          color: Color(0xff81b29a),
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
                                addUser();
                              }
                            },
                            minWidth: 200.0,
                            height: 42.0,
                            child: Text(
                              'Add Info',
                              style: TextStyle(color: Colors.white, fontSize: 26.0, fontWeight:FontWeight.w300),
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