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
                  android: LocationPermissionAndroid.fine
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
          controller.move( latLng.LatLng(value.location.latitude,value.location.longitude), zoom);
        });

      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return new FlutterMap(
      options: new MapOptions(
        center: new latlng.LatLng(51.5, -0.09),
        zoom: 13.0,
      ),
      layers: [
        new TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']
        ),
        new MarkerLayerOptions(
          markers: [
            new Marker(
              width: 80.0,
              height: 80.0,
              point: new LatLng(51.5, -0.09),
              builder: (ctx) =>
              new Container(
                child: new FlutterLogo(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}