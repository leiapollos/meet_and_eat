import 'package:flutter/material.dart';
import 'package:meet_and_eat/ImagePicker.dart';
import 'package:meet_and_eat/menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meet_and_eat/authentication_service.dart';
import 'package:meet_and_eat/GetUsers.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'Profile.dart';

class AddMeal extends StatefulWidget {
  AddMeal({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AddMeal createState() => _AddMeal();
}

class _AddMeal extends State<AddMeal> {
  final TextEditingController mealNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController seatsController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController menuController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateFormat _dateFormat;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('meals');
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
    Future<void> addMeal() {
      String mealName = mealNameController.text.trim();
      String date = dateController.text.trim();
      String seats = seatsController.text.trim();
      String address = addressController.text.trim();
      String note = noteController.text.trim();
      String menu = menuController.text.trim();
      if(mealName == "" || seats == "" || address == "" || note == "" || menu == ""){
        _showMaterialDialog("Please fill in all the fields.");
      }
      // Call the user's CollectionReference to add a new user
      return users
          .doc(uid)
          .set({
        'cook': uid,
        'mealName' : mealName,
        'date': date,
        'seats': seats,
        'address': address,
        'note': note,
        'menu': menu,
      })
          .then((value) => {
        print("Meal Added"),
        Navigator.pop(context), //Pop out of register profile
        //Reload Profile
        //Navigator.pop(context),
        /*Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Profile(uid)),)*/
      })
          .catchError((error) => print("Failed to add meal: $error"));
    }

    Future<void> _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2015, 8),
          lastDate: DateTime(2101));
      if (picked != null && picked != selectedDate)
        setState(() {
          selectedDate = picked;
          dateController.text = picked.toLocal().toString();
        });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Publishing Meal'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImagePickerWidget(uid: uid, showUploadButton: false,),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                controller: mealNameController,
                decoration: InputDecoration(
                  hintText: 'Add dinner name',
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
                controller: dateController,
                onTap: () => _selectDate(context),
                decoration: InputDecoration(
                  hintText: 'Add date',
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
                controller: seatsController,
                decoration: InputDecoration(
                  hintText: 'Add number of seats',
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
                controller: addressController,
                decoration: InputDecoration(
                  hintText: 'Add address',
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
                controller: noteController,
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Give your guests some hints about the dinner! You can also let them know if they need to bring something.',
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
                height: 8.0,
              ),
              TextField(
                controller: menuController,
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
                      addMeal();
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'PUBLISH',
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