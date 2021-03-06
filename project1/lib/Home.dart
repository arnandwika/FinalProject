import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project1/LoginPage.dart';
import 'package:project1/Maps.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:project1/Tambah.dart';
import 'package:project1/main.dart';

import 'MapsReminder.dart';

class Home extends StatefulWidget{
  @override
  MyCard createState()=> new MyCard();
}

class MyCard extends State<Home>{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int jmlh = listReminder.length;
  List cards = new List.generate(listReminder.length, (int index)=>new StateCard(index)).toList();

  Future getCurrentLocation()async{
    Position res = await Geolocator().getCurrentPosition();
    locAwal=res;
    locAwalR=res;
  }

  @override
  void initState() {
    if(listReminder.length==0){
      id=0;
      idTambah=0;
    }else{
      idTambah= listReminder[listReminder.length-1]['id']+1;
    }
    getFirestore();
    getCurrentLocation();
    super.initState();
    initializing();

  }
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;

  void initializing() async {
    print("masuk initializing");
    androidInitializationSettings = AndroidInitializationSettings('mipmap/icon');
    iosInitializationSettings = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(
        androidInitializationSettings, iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payLoad) {
    print("payload: "+payLoad );
    if (payLoad != null) {
      print(payLoad);
    }
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    print("masuk onDidReceiveLocalNotification");
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              print("");
            },
            child: Text("Okay")
        ),
      ],
    );
  }
  void showNotifications(String s1, String s2, int i) async {
    print("masuk showNotif");
    await notification(s1,s2,i);
  }

  Future<void> notification(String s1, String s2, int i) async {
    print("masuk notification");
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        'Channel ID', 'Channel title', 'channel body',
        priority: Priority.High,
        importance: Importance.Max,
        ticker: 'test');

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails =
    NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        i, s1, s2, notificationDetails);
  }

  void showScheduledNotifications(String s1, String s2, int i, alarm) async {
    print("masuk showScheduledNotifications");
    await scheduledNotification(s1,s2,i, alarm);
  }

  Future<void> scheduledNotification(String s1, String s2, int i, alarm) async {
    print("masuk scheduledNotifications");
    var scheduledTime = DateTime.now().add(Duration(seconds: alarm));
    print("scheduled time: "+scheduledTime.toString());
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        'Channel ID', 'Channel title', 'channel body',
        priority: Priority.High,
        importance: Importance.Max,
        ticker: 'test');
    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
    NotificationDetails notificationDetails =
    NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.schedule(
        i, s1, s2,scheduledTime, notificationDetails);
  }

  Future<void> cekSisa(String tgl,int i) async{
    print("masuk cekSisa");
    DateTime waktu = DateTime.now();
    DateTime pembanding = convertDateFromString(tgl);
    print("tanggal sekarang: "+waktu.toString());
    Duration diff= waktu.difference(pembanding);
    if(diff.inSeconds>=-259200 && diff.inSeconds<=0){
      print("beda detik reminder "+i.toString()+" "+diff.inSeconds.toString());
      int alarm = (diff.inSeconds - diff.inSeconds - diff.inSeconds) - 86400;
      String gabungan = "Akan berlangsung pada ${tgl}";
      print("alarm: "+alarm.toString());
      if(alarm>=0){
        await showScheduledNotifications(listReminder[i]['judul'].toString(),gabungan,i,alarm);
      }else{
        await showNotifications(listReminder[i]['judul'].toString(),gabungan,i);
      }
    }
  }
  void notif() async{
    print("masuk notif");
    await OpenDb();
    await getFirestore();
    await historyFirestore();
    if(listReminder.length!=null){
      for(int i=0; i<listReminder.length;i++){
        print("tanggal: "+listReminder[i]['tanggal'].toString());
        cekSisa(listReminder[i]['tanggal'].toString(), i);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    notif();
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Quinget Reminder'),
          backgroundColor: blue,
        ),
        drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
//                      Image.asset('img/Qu+.png', width: 150, height: 150,),
                      CircleAvatar(
                        backgroundImage: NetworkImage(loggedInUser.photoUrl),
                        radius: 50,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(loggedInUser.displayName,
                          style: TextStyle(fontSize: 30, color: Colors.white),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.history, size: 50, color: blue,),
                  title: Text(
                    "History", style: TextStyle(fontSize: 20, color: blue), textAlign: TextAlign.start,
                  ),
                  onTap: () async =>{
                    await historyFirestore(),
                    Navigator.pushNamed(context, '/history')
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.info, size: 50, color: blue,),
                  title: Text(
                    "About", style: TextStyle(fontSize: 20, color: blue), textAlign: TextAlign.start,
                  ),
                  onTap: (){
                    Navigator.pushNamed(context, '/about');
                  },
                ),
              ],
            )
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            Navigator.popAndPushNamed(context, '/home');
            return await Future.delayed(Duration(seconds: 3));
          },
          child: new Container(
            child: new ListView(
              children: cards,
            ),
          ),
        ),
        floatingActionButton: new FloatingActionButton(
            elevation: 0.0,
            child: new Icon(Icons.add),
            backgroundColor: blue,
            onPressed: (){
              locEditingController.text="";
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context)=> StateTambah()
                  )
              );
            }
        )
    );
  }
}