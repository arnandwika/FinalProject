import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:project1/main.dart';

class FirstPageState extends StatefulWidget{
  @override
  FirstPage createState()=> new FirstPage();
}

class FirstPage extends State<FirstPageState>{
  String title;
  String content;
  void initState() {
    super.initState();
    initializing();
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;

  void initializing() async {
    androidInitializationSettings = AndroidInitializationSettings('quinget');
    iosInitializationSettings = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(
        androidInitializationSettings, iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payLoad) {
    if (payLoad != null) {
      print(payLoad);
    }

    // we can set navigator to navigate another screen
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              print("");
            },
            child: Text("Okay")),
      ],
    );
  }
  void showNotifications(String s1, String s2, int i) async {
    await notification(s1,s2,i);
  }

  Future<void> notification(String s1, String s2, int i) async {
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
    await scheduledNotification(s1,s2,i, alarm);
  }

  Future<void> scheduledNotification(String s1, String s2, int i, alarm) async {
    var scheduledTime = DateTime.now().add(Duration(seconds: alarm));
    print(scheduledTime);
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
    DateTime waktu = DateTime.now();
    DateTime pembanding = convertDateFromString(tgl);
    Duration diff= waktu.difference(pembanding);
    if(diff.inSeconds>=-259200 && diff.inSeconds<=0){
      print(diff.inSeconds);
      int alarm = (diff.inSeconds - diff.inSeconds - diff.inSeconds) - 86400;
      String gabungan = "Akan berlangsung pada ${tgl}";
      if(alarm>=0){
        await showScheduledNotifications(list[i]['judul'].toString(),gabungan,i,alarm);
      }else{
        await showNotifications(list[i]['judul'].toString(),gabungan,i);
      }
    }
  }
  void notif() async{
    await OpenDb();
    await getFirestore();
    await historyFirestore();
    if(list.length!=null){
      for(int i=0; i<list.length;i++){
        cekSisa(list[i]['tanggal'].toString(), i);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    notif();
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("QUINGET"),
        backgroundColor: blue,
      ),
      body: new Padding(
        padding: EdgeInsets.all(7.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: new Container(
                    width: 220,
                    child: new Image(
                        image: AssetImage('img/quinget.png')
                    ),
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(bottom: 100),
                  child: new Container(
                      width: 345,
                      child: new Text(
                        "Kelola acara dan kegiatanmu sehingga kamu dapat menyelesaikan pekerjaanmu",
                        textAlign: TextAlign.center,
                      )
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: new Container(
                    width: 345,
                    decoration: BoxDecoration(
                        color: blue,
                        borderRadius: BorderRadius.all(Radius.circular(50))
                    ),
                    child: new RaisedButton(
                      color: blue,
                      onPressed: () async =>{
//                    await OpenDb(),
//
                        Navigator.pushNamed(context, '/home'),
                      },
                      child: new Text(
                        "Cek dan tambahkan reminder di sini!",
                        style: TextStyle(
                            color: black,
                            fontSize: 17
                        ),
                      ),
                    ),
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(bottom: 80),
                  child: new Container(
                    width: 345,
                    decoration: BoxDecoration(
                        color: blue,
                        borderRadius: BorderRadius.all(Radius.circular(50))
                    ),
                    child: new RaisedButton(
                      color: blue,
                      onPressed: () async =>{
                        await historyFirestore(),
                        Navigator.pushNamed(context, '/history')
                      },
                      child: new Text(
                        "Lihat kegiatan apa saja yang pernah kamu lakukan",
                        style: TextStyle(
                            color: black,
                            fontSize: 17
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }


}