
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
import 'package:project1/Reminder.dart';
import 'package:project1/Splash2.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'DB.dart';
import 'ReminderHistory.dart';
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
int id=0;

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (context) => SplashScreen(),
          '/firstPage': (context) => FirstPageState(),
          '/home': (context) => Home(),
          '/openreminder': (context) => Reminder(0,"","",""),
          '/history': (context) => History(),
          '/listFoto': (context) => listFoto(0),
        }
    );
  }
}

class MyNavigator {
  static void goToFirstPage(BuildContext context) {
    Navigator.pushReplacementNamed(context, "/firstPage");
  }
}

class ObjectReminder{
  String judul;
  String tanggal;
  String isi;
  ObjectReminder({this.judul,this.tanggal,this.isi});
  Map<String, dynamic> toMap(){
    return{
      'judul': judul,
      'isi': isi,
      'tanggal': tanggal,
    };
  }
}

Future getFirestore() async{
  DateTime waktu = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(waktu);
  await Firestore.instance.collection("reminder").where('tanggal', isGreaterThanOrEqualTo: formattedDate).orderBy('tanggal', descending: false).snapshots().listen((temp){
    listReminder.clear();
    if (temp.documents.length != 0){
      temp.documents.forEach((d){
        Map temp = new Map();
        temp['id'] = d['id'];
        temp['judul'] = d['judul'];
        temp['tanggal'] = d['tanggal'];
        temp['isi'] = d['isi'];
        print("ini datanya "+temp['judul']);
        listReminder.add(temp);
      });
    }
  });
  print(listReminder.toString());
}

Future addFirestore(String tjudul, String ttanggal, String tisi) async{
  await Firestore.instance.collection("reminder").document(id.toString()).setData({
    'id': id,
    'judul': tjudul,
    'tanggal': ttanggal,
    'isi': tisi
  });
  id++;
}
Future InsertDb(String judul, String tanggal, String isi) async{
  DB helper = DB.instance;
  await helper.insertReminder(judul, tanggal, isi);
  await addFirestore(judul, tanggal, isi);
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
      color: selectColor(listReminder[i]['tanggal']),
      child: InkWell(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute<String>(
            builder: (BuildContext context) {
              return Reminder(
                  listReminder[i]['id'],listReminder[i]['judul'],listReminder[i]['isi'],listReminder[i]['tanggal']
              );
            }
          )).then((String str){
//            setState(){};
          });
        },
        child: new Column(
          children: <Widget>[
            Text(listReminder[i]['judul']+" "+listReminder[i]['id'].toString()),
            new Padding(
                padding: new EdgeInsets.all(7.0),
            ),
            Text(listReminder[i]['tanggal']),
            Text(listReminder[i]['isi']),
          ],
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
        title: new Text('Reminder'),
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
  await Firestore.instance.collection("reminder").where('tanggal', isLessThan: formattedDate).orderBy('tanggal', descending: false).snapshots().listen((temp){
    listHistory.clear();
    if (temp.documents.length != 0){
      temp.documents.forEach((d){
        Map temp = new Map();
        temp['id'] = d['id'];
        temp['judul'] = d['judul'];
        temp['tanggal'] = d['tanggal'];
        temp['isi'] = d['isi'];
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
      child: InkWell(
        onTap: ()=>{
          Navigator.push(context, MaterialPageRoute(
            builder: (context) =>ReminderHistory(
                listHistory[i]['id'],listHistory[i]['judul'],listHistory[i]['isi'],listHistory[i]['tanggal']
            ),
          ),
          ),
        },
        child: new Column(
          children: <Widget>[
            Text(listHistory[i]['judul']+" "+listHistory[i]['id'].toString()),
            new Padding(
              padding: new EdgeInsets.all(7.0),
            ),
            Text(listHistory[i]['tanggal']),
            Text(listHistory[i]['isi']),
          ],
        ),
      ),
    );
  }
}