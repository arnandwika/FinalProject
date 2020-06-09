import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Edit.dart';
import 'main.dart';
import 'DB.dart';


void main() => runApp(ReminderHistory(0,"","",""));



class ReminderHistory extends StatelessWidget{
  int id;
  String judul;
  String isi;
  String tanggal;
  ReminderHistory(this.id, this.judul, this.isi, this.tanggal);
  void hapusData(int id) async{
    DB helper = DB.instance;
    helper.deleteReminder(id);
  }

  void hapusFirestore(int id) async{
    await Firestore.instance.collection('reminder').document(id.toString()).delete();
  }

  @override
  Widget build(BuildContext context) {
      OpenDb();
    return Scaffold(
      appBar: AppBar(
        title: Text("Riwayat"),
        backgroundColor: blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView(
          children: <Widget>[
            Text(
                "Detail Acara: ",
                style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15,
            ),
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 150,
                      child: Text(
                        "Nama Acara",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Text(
                      " : "+judul,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 150,
                      child: Text(
                        "Tanggal Acara ",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Text(
                      " : "+formatDate(DateTime.parse(tanggal),[d," ",MM," ",yyyy]).toString(),
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 150,
                      child: Text(
                        "Jam Acara ",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Text(
                      " : "+formatDate(DateTime.parse(tanggal),[HH,":",nn]).toString(),
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: Text(
                        "Deskripsi ",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 150,
                      child: Text(
                        " : "+isi,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: RaisedButton(
                    color: Colors.red,
                    child: Text("Hapus", style: TextStyle(color: white, fontSize: 20),),
                    onPressed: () async => {
                      await hapusData(id),
                      await hapusFirestore(id),
                      Navigator.pop(context),
                      Navigator.pop(context),
                      await OpenDb(),
                      Navigator.pushNamed(context, '/history'),
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}