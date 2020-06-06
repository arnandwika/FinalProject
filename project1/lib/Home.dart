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
          title: new Text('Reminder'),
          backgroundColor: blue,
        ),
        body: new Container(
            child: new ListView(
              children: cards,
            )

        ),
        floatingActionButton: new FloatingActionButton(
            elevation: 0.0,
            child: new Icon(Icons.add_circle),
            backgroundColor: blue,
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