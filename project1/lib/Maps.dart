
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission/permission.dart';
import 'package:project1/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:project1/Tambah.dart';
import 'package:location/location.dart';

import 'Edit.dart';

String alamatMaps;
TextEditingController mapsLoc = new TextEditingController();
Position locAwal;

class Maps extends StatefulWidget{
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps>{
  GoogleMapController gmController;
  String alamat;
  Set<Marker> marker = {};

//  final Set<Polyline> polyline = {};
//  List<LatLng> routes;
//  GoogleMapPolyline gMapPolyline = new GoogleMapPolyline(apiKey: "AIzaSyAdKCiWyCujUa7091QDx9jynVDjQnUQ2C4");

//  getRoutes(double lat, double long)async{
//    var permissions = await Permission.getPermissionsStatus([PermissionName.Location]);
//
//    if(permissions[0].permissionStatus == PermissionStatus.notAgain){
//      var askPermission = await Permission.requestPermissions([PermissionName.Location]);
//    }else{
//      routes = await gMapPolyline.getCoordinatesWithLocation(
//        origin: LatLng(locAwal.latitude,locAwal.longitude),
//        destination: LatLng(lat,long),
//        mode: RouteMode.driving,
//      );
//    }
//  }

  void updateAlamat(String alamatBaru){
    setState(() {
      alamat = alamatBaru;
    });
  }
  void setAlamat(){
    alamatMaps=alamat;
    locEditingController.text = alamatMaps;
    locEditingController2.text = alamatMaps;
    Navigator.pop(context, "/tambah");
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Maps"),
      ),
      body: Stack(
        children: <Widget>[
          new GoogleMap(
            onMapCreated: onMapCreated,
            markers: marker,
//            polylines: polyline,
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
                target: LatLng(locAwal.latitude, locAwal.longitude),
                zoom: 15
            ),
          ),
          new Positioned(
            top: 30.0,
            right: 15.0,
            left: 15.0,
            child: Container(
              height: 50.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.white
              ),
              child: new TextField(
                controller: mapsLoc,
                decoration: InputDecoration(
                  hintText: 'Enter address...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10),
                ),
                onChanged: updateAlamat,
              ),
            ),
          ),
          new Positioned(
            top: 30,
            right: 15,
            child: new IconButton(
                icon: Icon(Icons.search),
                iconSize: 30.0,
                onPressed: ()async{
                  navigate();
                },
            )
          )
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        backgroundColor: blue,
        child: Text("ADD"),
        onPressed: setAlamat,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
  navigate(){
    setState(() {
      Geolocator().placemarkFromAddress(alamat).then((result){
//        getRoutes(result[0].position.latitude, result[0].position.longitude);
        marker.add(Marker(
            markerId: MarkerId("Your destination"),
            position: LatLng(result[0].position.latitude, result[0].position.longitude),
            icon: BitmapDescriptor.defaultMarker
        ));
        gmController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(result[0].position.latitude, result[0].position.longitude),
            zoom: 15
        )));
      });
    });
  }


  void onMapCreated(controller){
    setState(() {
      gmController = controller;
//      polyline.add(Polyline(
//        polylineId: PolylineId("route"),
//        visible: true,
//        points: routes,
//        width: 8,
//        color: Colors.blue,
//        startCap: Cap.roundCap,
//        endCap: Cap.buttCap
//      ));
    });
  }
}