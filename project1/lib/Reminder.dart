import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Edit.dart';
import 'listFoto.dart';
import 'main.dart';
import 'DB.dart';


void main() => runApp(Reminder(0,"","",""));

class Reminder extends StatelessWidget{
  int id;
  String judul;
  String isi;
  String tanggal;
  Reminder(this.id, this.judul, this.isi, this.tanggal);
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
        title: Text("Detail Acara"),
        backgroundColor: blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
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
                    "Tanggal & Jam ",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Text(
                  " : "+tanggal,
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
//            RaisedButton(
//                child: Text("Foto Foto"),
//                onPressed: () async{
//                  await OpenDbFoto(id);
//                  Navigator.push(context, MaterialPageRoute(
//                      builder: (context) =>listFoto(id)
//                  ));
//                }
//            ),
            SizedBox(
              width: 200,
              height: 50,
              child: RaisedButton(
                color: blue,
                child: Text("Edit", style: TextStyle(color: white, fontSize: 20),),
                onPressed: () => {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>Edit(id,judul, tanggal, isi),
                  )),
                },
              ),
            ),
            SizedBox(
              height: 8,
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
                  Navigator.pushNamed(context, '/home'),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}