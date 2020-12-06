import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meet_and_eat/ChatSystem.dart';
import 'package:meet_and_eat/ProfileScreen.dart';
import 'package:meet_and_eat/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:geolocation/geolocation.dart';
import 'package:flutter_map/flutter_map.dart';
import "package:latlong/latlong.dart" as latLng;


class LocationScreen extends StatefulWidget {
  final String uid;

  const LocationScreen ({ Key key, this.uid }): super(key: key);
  @override
  _LocationScreen createState() => _LocationScreen();
}

class _LocationScreen extends State<LocationScreen>{

  MapController controller = new MapController();

  getPermission() async {
    final GeolocationResult result =
        await Geolocation.requestLocationPermission(
                permission: LocationPermission(
                  android: LocationPermissionAndroid.fine,
                  ios:  LocationPermissionIOS.always,
                )
             );

    return result;
  }

  getLocation()
  {
    return getPermission().then((result) async{
      if(result.isSuccessful){
        final coords =
              await Geolocation.currentLocation(accuracy: LocationAccuracy.best);
      }
    });
  }

  buildMap()
  {
    getLocation().then((response) {
      if(response.isSuccessful){
        response.listen((value) {
          controller.move(new latLng.LatLng(value.location.latitude, value.location.longitude),
              15.0);
        });

      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff3d405b),
        title: Text('Location'),
        centerTitle: true,
      ),
      body: new FlutterMap(
        mapController: controller,
        options: new MapOptions(center: buildMap(), minZoom: 5.0),
        layers: [
          new TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']
          )
        ],
      ),
    );
  }
}