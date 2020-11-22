import 'package:flutter/material.dart';
import 'package:meet_and_eat/menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meet_and_eat/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:meet_and_eat/GetUsers.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final uid = context.watch<AuthenticationService>().getUserId();
    return Scaffold(
      drawer: Menu(title: 'Meet&Eat'),
      appBar: AppBar(
        title: Text('Meet&Eat'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search),
              onPressed: (){
                showSearch(context: context, delegate: DataSearch());
          })
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GetUsers(),
            Text(uid)
          ],
        ),
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String>{
  /// TODO: USE BACKEND DATA AND UPDATE RECENTPEOPLE
  final people = ['Toni Kukoc', 'SIUU', 'Daddy Andre'];
  final recentPeople = ['Toni Kukoc']; // History

  @override
  List<Widget> buildActions(BuildContext context) {
    // Action for app bar
   return [IconButton(icon: Icon(Icons.clear), onPressed: (){
     query = '';
   })];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Leading icon on the of the app bar
    return IconButton(icon: AnimatedIcon(
      icon: AnimatedIcons.menu_arrow,
      progress: transitionAnimation,
    ),
     onPressed: (){
      close(context, null);
     });
  }

  @override
  Widget buildResults(BuildContext context) {
    // Show result base on the selection
    return Card(
      color: Colors.blue,
      child: Center(
        child: Text(query),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Suggestion search
    final suggestionList = query.isEmpty
        ? recentPeople
        : people.where((element) => element.toLowerCase().startsWith(query)).toList();
    
    return ListView.builder(
        itemBuilder: (contex, index) => ListTile(
        onTap: (){//ON CLICK
          showResults(context);
        },
          leading: Icon(Icons.food_bank),
          title: RichText(
           text: TextSpan(
               text: suggestionList[index].substring(0, query.length),
               style: TextStyle(
                 color: Colors.black, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: suggestionList[index].substring(query.length),
                    style: TextStyle(color: Colors.grey)
                  )
                ]
           ),
          ),
        ),
      itemCount: suggestionList.length,
    );
  }
  
}