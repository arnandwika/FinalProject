import 'package:flutter/material.dart';
import 'package:project1/Tambah.dart';
import 'package:project1/main.dart';

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