import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
    }else{
      id= listReminder[listReminder.length-1]['id']+1;
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
    androidInitializationSettings = AndroidInitializationSettings('Qu+.png');
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
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.history),
              iconSize: 30,
              onPressed: () async =>{
                await historyFirestore(),
                Navigator.pushNamed(context, '/history')
              },
            ),
//          IconButton(
//            icon: Icon(Icons.refresh),
//            onPressed: (){
//              Navigator.popAndPushNamed(context, '/home');
//            },
//          ),
            SizedBox(
              width: 15,
            )
          ],
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