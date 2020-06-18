
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission/permission.dart';
import 'package:project1/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:project1/Tambah.dart';
import 'package:location/location.dart';


TextEditingController mapsLocR = new TextEditingController();
Position locAwalR;
double latR;
double longR;

class MapsReminder extends StatefulWidget{
  @override
  _MapsReminderState createState() => _MapsReminderState();
}

class _MapsReminderState extends State<MapsReminder>{
  GoogleMapController gmControllerR;
  String alamatR;
  Set<Marker> markerR = {};

//  final Set<Polyline> polylineR = {};
//  List<LatLng> routesR;
//  GoogleMapPolyline gMapPolylineR = new GoogleMapPolyline(apiKey: "AIzaSyAdKCiWyCujUa7091QDx9jynVDjQnUQ2C4");
//
//  getRoutes()async{
//    await setState(() async{
//      var permissions = await Permission.getPermissionsStatus([PermissionName.Location]);
//
//      if(permissions[0].permissionStatus == PermissionStatus.notAgain){
//        var askPermission = await Permission.requestPermissions([PermissionName.Location]);
//      }else{
//        routesR = await gMapPolylineR.getCoordinatesWithLocation(
//          origin: LatLng(locAwalR.latitude,locAwalR.longitude),
//          destination: LatLng(latR,longR),
//          mode: RouteMode.driving,
//        );
//      }
//    });
//  }

  @override
  void initState() {
//    getRoutes();
    markerR.add(Marker(
        markerId: MarkerId("Your destination"),
        position: LatLng(latR, longR),
        icon: BitmapDescriptor.defaultMarker
    ));
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
            markers: markerR,
//            polylines: polylineR,
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
                target: LatLng(latR, longR),
                zoom: 15
            ),
          ),
        ],
      ),
    );
  }


  void onMapCreated(controller){
    setState(() {
      gmControllerR = controller;
//      polylineR.add(Polyline(
//          polylineId: PolylineId("route"),
//          visible: true,
//          points: routesR,
//          width: 8,
//          color: Colors.blue,
//          startCap: Cap.roundCap,
//          endCap: Cap.buttCap
//      ));
    });
  }
}