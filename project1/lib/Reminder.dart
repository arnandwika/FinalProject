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
        backgroundColor: blue,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Text(
              judul,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30
              ),
            ),
            Text(
              tanggal,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            SingleChildScrollView(
              child: Container(
                height: 200,
                child: Text(
                   isi
                ),
              ),
            ),
            RaisedButton(
                child: Text("Foto Foto"),
                onPressed: () async{
                  await OpenDbFoto(id);
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>listFoto(id)
                  ));
                }
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      onPressed: () async => {
                        await hapusData(id),
                        await hapusFirestore(id),
                        Navigator.pop(context),
                        Navigator.pop(context),
                        await OpenDb(),
                        Navigator.pushNamed(context, '/home'),

                      },
                      color: blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                      ),
                      child: Text(
                        "Hapus",
                        style: TextStyle(
                            fontSize: 20
                        ),),
                    ),
                  ),
                  Expanded(
                    child: RaisedButton(
                      onPressed: () => {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) =>Edit(id,judul, tanggal, isi),
                        )),
                      },
                      color: blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                      ),
                      child: Text("Edit",
                        style: TextStyle(
                            fontSize: 20
                        ),),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}