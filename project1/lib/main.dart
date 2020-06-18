
import 'package:date_format/date_format.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:project1/FirstPage.dart';
import 'package:project1/Home.dart';
import 'package:project1/MapsReminder.dart';
import 'package:project1/Reminder.dart';
import 'package:project1/Splash2.dart';
import 'About.dart';
import 'Maps.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'DB.dart';
import 'LoginPage.dart';
import 'ReminderHistory.dart';
import 'Tambah.dart';
import 'listFoto.dart';

void main() => runApp(MyApp());
List<Map> list;
List<Map> listHistory = new List<Map>();
List<Map> listReminder = new List<Map>();
bool cekDB=false;
Color fix;
Color hijau = Colors.lightGreenAccent[400];
Color amber = Colors.amber;
Color merah = Colors.red;
Color blue = Colors.blue;
Color black = Colors.black;
Color white = Colors.white;
Color gray = Colors.black12;
int id;
int idTambah;
String UID = "";

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (context) => SplashScreen(),
          '/login': (context) => LoginPage(),
          '/firstPage': (context) => FirstPageState(),
          '/home': (context) => Home(),
          '/openreminder': (context) => Reminder(0,"","","",""),
          '/history': (context) => History(),
          '/listFoto': (context) => listFoto(0),
          '/map': (context) => Maps(),
          '/mapR': (context) => MapsReminder(),
          '/tambah': (context) => StateTambah(),
          '/about': (context) => About(),
        }
    );
  }
}

class MyNavigator {
//  static void goToFirstPage(BuildContext context) {
//    Navigator.pushReplacementNamed(context, "/firstPage");
//  }
  static void goLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, "/login");
  }
  static void goHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, "/home");
  }
  static void openMap(BuildContext context){
    Navigator.pushNamed(context, "/map");
  }
  static void backTambah(BuildContext context){
    Navigator.pop(context, "/tambah");
  }
  static void openMapR(BuildContext context){
    Navigator.pushNamed(context, "/mapR");
  }
}

class ObjectReminder{
  String judul;
  String tanggal;
  String isi;
  String lokasi;
  ObjectReminder({this.judul,this.tanggal,this.isi,this.lokasi});
  Map<String, dynamic> toMap(){
    return{
      'judul': judul,
      'isi': isi,
      'tanggal': tanggal,
      'lokasi': lokasi,
    };
  }
}

Future getFirestore() async{
  DateTime waktu = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(waktu);
  await Firestore.instance.collection(loggedInUser.uid).where('tanggal', isGreaterThanOrEqualTo: formattedDate).orderBy('tanggal', descending: false).snapshots().listen((temp){
    listReminder.clear();
    if (temp.documents.length != 0){
      temp.documents.forEach((d){
        Map temp = new Map();
        temp['id'] = d['id'];
        temp['judul'] = d['judul'];
        temp['tanggal'] = d['tanggal'];
        temp['isi'] = d['isi'];
        temp['lokasi'] = d['lokasi'];
        print("ini datanya "+temp['judul']);
        listReminder.add(temp);
      });
    }
  });
  print(listReminder.toString());
}

Future addFirestore(String tjudul, String ttanggal, String tisi, String tlokasi) async{
  await Firestore.instance.collection(loggedInUser.uid).document((id).toString()).setData({
    'id': id,
    'judul': tjudul,
    'tanggal': ttanggal,
    'isi': tisi,
    'lokasi': tlokasi
  });
//  id++;
}
Future InsertDb(String judul, String tanggal, String isi, String lokasi) async{
  DB helper = DB.instance;
  await helper.insertReminder(judul, tanggal, isi, lokasi);
  await addFirestore(judul, tanggal, isi, lokasi);
}
Future OpenDb() async{
  DB helper = DB.instance;
  DateTime waktu = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(waktu);
  list = await helper.listReminder(formattedDate);
}
DateTime convertDateFromString(String strDate){
  DateTime todayDate = DateTime.parse(strDate);
  return todayDate;
}
Color selectColor(String tgl){
  DateTime waktu = DateTime.now();
  DateTime pembanding = convertDateFromString(tgl);
  Duration diff= waktu.difference(pembanding);
  if(diff.inSeconds>=-259200 && diff.inSeconds<=0){
    return merah;
  }else if(diff.inSeconds>=-604800){
    return amber;
  }else{
    return hijau;
  }
}

class StateCard extends StatefulWidget{
  int i;
  StateCard(this.i);
  @override
  CustomCard createState()=> new CustomCard(i);
}

class CustomCard extends State<StateCard> {
  int i;
  CustomCard(this.i);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: ListTile(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute<String>(
              builder: (BuildContext context) {
                print("id reminder: "+listReminder[i]['id'].toString());
                return Reminder(
                    listReminder[i]['id'],listReminder[i]['judul'],listReminder[i]['isi'],listReminder[i]['tanggal'],listReminder[i]['lokasi']
                );
              }
          )).then((String str){
//            setState(){};
          });
        },
        title: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(listReminder[i]['judul'],
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(listReminder[i]['tanggal'],
                style: TextStyle(fontSize: 17, color: blue),
              ),
            ],
          ),
        ),
        trailing: CircleAvatar(
          backgroundColor: selectColor(listReminder[i]['tanggal']),
        ),
      ),
    );
  }
}

class History extends StatefulWidget{
  @override
  MyHistory createState()=> new MyHistory();
}

class MyHistory extends State<History>{
  @override
  void initState() {
    super.initState();
  }

  int jmlh = listHistory.length;
  List cards = new List.generate(listHistory.length, (int index)=>new CardHistory(index)).toList();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Riwayat Acara'),
        backgroundColor: blue,
      ),
      body: new Container(
          child: new ListView(
            children: cards,
          )
      ),
    );
  }
}

Future searchHistory() async{
  DB helper = DB.instance;
  DateTime waktu = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(waktu);
  listHistory = await helper.listHistory(formattedDate);
}

Future historyFirestore() async{
  DateTime waktu = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(waktu);
  await Firestore.instance.collection(loggedInUser.uid).where('tanggal', isLessThan: formattedDate).orderBy('tanggal', descending: false).snapshots().listen((temp){
    listHistory.clear();
    if (temp.documents.length != 0){
      temp.documents.forEach((d){
        Map temp = new Map();
        temp['id'] = d['id'];
        temp['judul'] = d['judul'];
        temp['tanggal'] = d['tanggal'];
        temp['isi'] = d['isi'];
        temp['lokasi']= d['lokasi'];
        print("ini datanya "+temp['judul']);
        listHistory.add(temp);
      });
    }
  });
}

class CardHistory extends StatelessWidget {
  int i;
  CardHistory(this.i);
  @override
  Widget build(BuildContext context) {
    return new Card(
      child: ListTile(
          onTap: ()=>{
            Navigator.push(context, MaterialPageRoute(
              builder: (context) =>ReminderHistory(
                  listHistory[i]['id'],listHistory[i]['judul'],listHistory[i]['isi'],listHistory[i]['tanggal'],listHistory[i]['lokasi']
              ),
            ),
            ),
          },
          title: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(listHistory[i]['judul'],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(listHistory[i]['tanggal'],
                  style: TextStyle(fontSize: 17, color: blue),
                ),
              ],
            ),
          )
      ),
    );
  }
}