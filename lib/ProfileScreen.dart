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
    final CategoriesScroller photosHorizontalScroller = CategoriesScroller();
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
                backgroundColor: Color(0xff3d405b),
                title: Text(data['name'] + "'s Profile"),
                centerTitle: true,
                actions: <Widget>[
                  /*IconButton(icon: Icon(Icons.arrow_back_sharp),
                      onPressed: (){

                      })*/
                ],
              ),
              body: ListView(
                shrinkWrap: true,
                //padding: EdgeInsets.all(15.0),
                children: <Widget>[
                  Container(
                    color: Colors.white,
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  data['biography'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.blueGrey,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          height: 0,
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
                                      Icons.ac_unit,
                                      color: Colors.blueGrey,
                                      size: 24.0,

                                    ),
                                    Icon(
                                      Icons.account_balance_wallet_rounded,
                                      color: Colors.blueGrey,
                                      size: 24.0,

                                    ),
                                    Icon(
                                      Icons.favorite,
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
                                    Text("I am in my twenties",
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
                                    Text("English, Spanish",
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
                                    Text("IT Student",
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
                          child: Text('Upcomming Meet&Eats',
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.access_time_rounded,
                                              color: Colors.blueGrey,
                                              size: 24.0,
                                            ),
                                            SizedBox(
                                              width: 2,
                                            ),
                                            Text("Time",
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
                                    Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.add_location_rounded,
                                            color: Colors.blueGrey,
                                            size: 24.0,
                                          ),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          Text("Location",
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
                                    Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.airline_seat_legroom_normal_sharp,
                                            color: Colors.blueGrey,
                                            size: 24.0,
                                          ),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          Text("1 guest, 2 seats left",
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
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 150.00,
                                child: RaisedButton(
                                    onPressed: (){},
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(80.0)
                                    ),
                                    elevation: 0.0,
                                    padding: EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        color: Color(0xff81b29a),
                                        borderRadius: BorderRadius.circular(30.0),
                                      ),
                                      child: Container(
                                        constraints: BoxConstraints(maxWidth: 150.0, minHeight: 50.0),
                                        alignment: Alignment.center,
                                        child: Text("Details",
                                          style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight:FontWeight.w300),
                                        ),
                                      ),
                                    )
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
                          child: Text('Photos from ' + data['name'] + "'s dinners",
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
                        photosHorizontalScroller,
                        Divider(
                          height: 15,
                          color: Colors.grey,
                        ),
                        Container(
                          height: 58,
                        ),
                        /*Container(
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
                                  color: Color(0xff81b29a),
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
                        ),*/
                      ],
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
class CategoriesScroller extends StatelessWidget {
  const CategoriesScroller();
  @override
  Widget build(BuildContext context) {
    final double categoryHeight = MediaQuery.of(context).size.height * 0.25 - 50;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: FittedBox(
          fit: BoxFit.fill,
          alignment: Alignment.topCenter,
          child: Row(
            children: <Widget>[
              Container(
                width: 150,
                margin: EdgeInsets.only(right: 10),
                height: categoryHeight,
                decoration: BoxDecoration(color: Colors.blue.shade400, borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    image: DecorationImage(
                        image: AssetImage("assets/images/image2.jpg"),
                        fit: BoxFit.cover
                    )),
                child: Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: Container(
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4)),
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: Center(
                      child: Text("CHIMO",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                          textAlign: TextAlign.center),
                    ),
                  ),
                ),
              ),
              Container(
                width: 150,
                margin: EdgeInsets.only(right: 10),
                height: categoryHeight,
                decoration: BoxDecoration(color: Colors.blue.shade400, borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    image: DecorationImage(
                        image: AssetImage("assets/images/image1.jpg"),

                        fit: BoxFit.cover
                    )),
                child: Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: Container(
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4)),
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: Center(
                      child: Text("CHIMO",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                          textAlign: TextAlign.center),
                    ),
                  ),
                ),
              ),
              Container(
                width: 150,
                margin: EdgeInsets.only(right: 10),
                height: categoryHeight,
                decoration: BoxDecoration(color: Colors.blue.shade400, borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    image: DecorationImage(
                        image: AssetImage("assets/images/image3.jpg"),
                        fit: BoxFit.cover
                    )),
                child: Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: Container(
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4)),
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: Center(
                      child: Text("CHIMO",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        textAlign: TextAlign.center),
                    ),
                  ),
                ),

              ),
              Container(
                width: 150,
                margin: EdgeInsets.only(right: 10),
                height: categoryHeight,
                decoration: BoxDecoration(color: Colors.blue.shade400, borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    image: DecorationImage(
                        image: AssetImage("assets/images/image4.jpg"),
                        fit: BoxFit.cover
                    )),
                child: Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: Container(
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4)),
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: Center(
                      child: Text("CHIMO",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                          textAlign: TextAlign.center),
                    ),
                  ),
                ),

              ),
              Container(
                width: 150,
                margin: EdgeInsets.only(right: 10),
                height: categoryHeight,
                decoration: BoxDecoration(color: Colors.blue.shade400, borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    image: DecorationImage(
                        image: AssetImage("assets/images/image5.jpg"),
                        fit: BoxFit.cover
                    )),
                child: Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: Container(
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4)),
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: Center(
                      child: Text("CHIMO",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                          textAlign: TextAlign.center),
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