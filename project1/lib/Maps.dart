
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project1/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:project1/Tambah.dart';
import 'package:location/location.dart';

String alamatMaps;
TextEditingController mapsLoc = new TextEditingController();

class Maps extends StatefulWidget{
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps>{
  GoogleMapController gmController;
  String alamat;
  Position locAwal;
  Set<Marker> marker = {};

  Future getCurrentLocation() async{
    Position res = await Geolocator().getCurrentPosition();
    setState((){
      locAwal = res;
    });
  }


  void updateAlamat(String alamatBaru){
    setState(() {
      alamat = alamatBaru;
    });
  }
  void setAlamat(){
    alamatMaps=alamat;
    locEditingController.text = alamatMaps;
    Navigator.pop(context, "/tambah");
  }

  @override
  void initState() {
    getCurrentLocation();
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
                onPressed: navigate,
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
    });
  }
}