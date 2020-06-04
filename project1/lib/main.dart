
import 'package:date_format/date_format.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:project1/Reminder.dart';
import 'package:project1/Splash2.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'DB.dart';
import 'ReminderHistory.dart';

void main() => runApp(MyApp());
List<Map> list;
List<Map> listHistory = new List<Map>();
List<Map> listReminder = new List<Map>();
bool cekDB=false;
Color fix;
Color hijau = Colors.lightGreenAccent[400];
Color amber = Colors.amber;
Color merah = Colors.red;
int id=0;

//Future selectNotification(String payload) async {
//  if (payload != null) {
//    debugPrint('notification payload: ' + payload);
//  }
//  await Navigator.push(
//    context,
//    MaterialPageRoute(builder: (context) => SecondScreen(payload)),
//  );
//}

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
        }
    );
  }
}

class MyNavigator {
  static void goToFirstPage(BuildContext context) {
    Navigator.pushReplacementNamed(context, "/firstPage");
  }
}

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
//    if(cekDB==false){
//      BuatDb();
//      cekDB=true;
//      print(cekDB);
//    }

    notif();
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("QUINGET"),
        backgroundColor: Colors.deepOrange,
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
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.all(Radius.circular(50))
                    ),
                    child: new RaisedButton(
                      color: Colors.yellow,
                      onPressed: () async =>{
//                    await OpenDb(),
//
                        Navigator.pushNamed(context, '/home'),
                      },
                      child: new Text(
                        "Cek dan tambahkan reminder di sini!",
                        style: TextStyle(
                            color: Colors.black,
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
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.all(Radius.circular(50))
                    ),
                    child: new RaisedButton(
                      color: Colors.yellow,
                      onPressed: () async =>{
                        await historyFirestore(),
                        Navigator.pushNamed(context, '/history')
                      },
                      child: new Text(
                        "Lihat kegiatan apa saja yang pernah kamu lakukan",
                        style: TextStyle(
                            color: Colors.black,
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


class Home extends StatefulWidget{
  @override
  MyCard createState()=> new MyCard();
}

class MyCard extends State<Home>{
  int jmlh = listReminder.length;
  List cards = new List.generate(listReminder.length, (int index)=>new StateCard(index)).toList();


  @override
  void initState() {
    getFirestore();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Reminder'),
          backgroundColor: Colors.deepOrange,
        ),
        body: new Container(
            child: new ListView(
              children: cards,
            )

        ),
        floatingActionButton: new FloatingActionButton(
            elevation: 0.0,
            child: new Icon(Icons.add_circle),
            backgroundColor: new Color(0xFFE57373),
            onPressed: (){
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

//Future BuatDb() async{
//  if(database==null){
//    var databasesPath = await getDatabasesPath();
//    String path = databasesPath +'project1.db';
//    await deleteDatabase(path);
//    database = await openDatabase(
//        path,
//        version: 1,
//        onCreate: (db, version) async{
//          await db.execute(
//            "CREATE TABLE reminder(id INTEGER PRIMARY KEY AUTOINCREMENT, judul TEXT, isi TEXT, tanggal TEXT)",);
//        }
//    );
////    ObjectReminder o1 = ObjectReminder(judul:"harusnya ketiga", tanggal:"2020-12-20 23:30",isi:"pengujian");
////    ObjectReminder o2 = ObjectReminder(judul:"harusnya pertama", tanggal:"2020-03-20 07:30",isi:"pengujian yang kedua");
////    ObjectReminder o3 = ObjectReminder(judul:"harusnya kedua", tanggal:"2020-04-15 22:00",isi:"pengujian yang kedua");
////    database.insert('reminder', o1.toMap());
////    database.insert('reminder', o2.toMap());
////    database.insert('reminder', o3.toMap());
//  }
//  OpenDb();
//  print(list);
//}
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
//Future<List<ObjectReminder>> getTaskList() async {
//  List map = List();
//  QuerySnapshot tot = await Firestore.instance.collection('reminder').where('status',isEqualTo: statusKosoong.toString()).getDocuments();
//  tot.documents.forEach((maps){
//    DateTime target = DateTime.parse(maps['dateTime']);
//    DateTime skrng = DateTime.now();
//    Duration d = target.difference(skrng);
//    if(d.inDays >=0 && d.inDays <= 3){
//      temp.add(d);
//    }
//
//  });
//  return List.generate(temp.length, (i) {
//    return Task(
//        id: temp[i]['id'], task: temp[i]['task'], done: temp[i]['done'], date: temp[i]['date']);
//  }
//  );
//}
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
//            new Image.network('https://i.ytimg.com/vi/fq4N0hgOWzU/maxresdefault.jpg'),
            new Padding(
                padding: new EdgeInsets.all(7.0),
//                child: new Row(
//                  children: <Widget>[
//                    new Padding(
//                      padding: new EdgeInsets.all(7.0),
//                      child: new Icon(Icons.thumb_up),
//                    ),
//                    new Padding(
//                      padding: new EdgeInsets.all(7.0),
//                      child: new Text('Like',style: new TextStyle(fontSize: 18.0),),
//                    ),
//                    new Padding(
//                      padding: new EdgeInsets.all(7.0),
//                      child: new Icon(Icons.comment),
//                    ),
//                    new Padding(
//                      padding: new EdgeInsets.all(7.0),
//                      child: new Text('Comments',style: new TextStyle(fontSize: 18.0)),
//                    )
//
//                  ],
//                )
            ),
            Text(listReminder[i]['tanggal']),
            Text(listReminder[i]['isi']),
          ],
        ),
      ),
    );
  }
}

class StateTambah extends StatefulWidget{
  @override
  State createState() => Tambah();
}

class Tambah extends State<StateTambah>{

  @override
  void initState() {
    super.initState();
  }

  String tanggalJam=" ";
  ObjectReminder objectInsert;
  final _JudulEditingController = TextEditingController();
  final _IsiEditingController = TextEditingController();
  final format = DateFormat("yyyy-MM-dd HH:mm");
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.deepOrange,
      ),
      body: new Padding(padding: EdgeInsets.all(15.0),
        child: new Column(
          children: <Widget>[
            Text("Judul:"),
            new TextField(
              controller: _JudulEditingController,
              decoration: InputDecoration(
                hintText:"Judul",
              ),
            ),
            Text("Tanggal & Waktu:"),
            new DateTimeField(
              format: format,
              onShowPicker: (context, currentValue) async {
                final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100));
                if (date != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime:
                    TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                  );
                  tanggalJam = (DateTimeField.combine(date, time)).toString();
                  return DateTimeField.combine(date, time);
                } else {
                  return currentValue;
                }
              },
            ),
            Text("Deskripsi:"),
            new TextField(
              controller: _IsiEditingController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Description",
              ),
            ),
            RaisedButton(
              child: Text("Save"),
              onPressed: () async {
                await InsertDb(_JudulEditingController.text, tanggalJam, _IsiEditingController.text);
                await OpenDb();
                await getFirestore();
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pushNamed(context, '/home');
              },
            )
          ],
        ),
      ),
    );
  }
}

//class _InputDropdown extends StatelessWidget {
//  const _InputDropdown(
//      {Key key,
//        this.child,
//        this.labelText,
//        this.valueText,
//        this.valueStyle,
//        this.onPressed})
//      : super(key: key);
//
//  final String labelText;
//  final String valueText;
//  final TextStyle valueStyle;
//  final VoidCallback onPressed;
//  final Widget child;
//
//  @override
//  Widget build(BuildContext context) {
//    return new InkWell(
//      onTap: onPressed,
//      child: new InputDecorator(
//        decoration: new InputDecoration(
//          labelText: labelText,
//        ),
//        baseStyle: valueStyle,
//        child: new Row(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          mainAxisSize: MainAxisSize.min,
//          children: <Widget>[
//            new Text(valueText, style: valueStyle),
//            new Icon(Icons.arrow_drop_down,
//                color: Theme.of(context).brightness == Brightness.light
//                    ? Colors.grey.shade700
//                    : Colors.white70),
//          ],
//        ),
//      ),
//    );
//  }
//}
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
          backgroundColor: Colors.deepOrange,
        ),
        body: new Container(
            child: new ListView(
              children: cards,
            )

        ),
//        floatingActionButton: new FloatingActionButton(
//            elevation: 0.0,
//            child: new Icon(Icons.add_circle),
//            backgroundColor: new Color(0xFFE57373),
//            onPressed: (){
//              Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context)=> StateTambah()
//                  )
//              );
//            }
//        )
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
//            new Image.network('https://i.ytimg.com/vi/fq4N0hgOWzU/maxresdefault.jpg'),
            new Padding(
              padding: new EdgeInsets.all(7.0),
//                child: new Row(
//                  children: <Widget>[
//                    new Padding(
//                      padding: new EdgeInsets.all(7.0),
//                      child: new Icon(Icons.thumb_up),
//                    ),
//                    new Padding(
//                      padding: new EdgeInsets.all(7.0),
//                      child: new Text('Like',style: new TextStyle(fontSize: 18.0),),
//                    ),
//                    new Padding(
//                      padding: new EdgeInsets.all(7.0),
//                      child: new Icon(Icons.comment),
//                    ),
//                    new Padding(
//                      padding: new EdgeInsets.all(7.0),
//                      child: new Text('Comments',style: new TextStyle(fontSize: 18.0)),
//                    )
//
//                  ],
//                )
            ),
            Text(listHistory[i]['tanggal']),
            Text(listHistory[i]['isi']),
          ],
        ),
      ),
    );
  }
}