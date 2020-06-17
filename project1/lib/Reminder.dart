

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Edit.dart';
import 'LoginPage.dart';
import 'listFoto.dart';
import 'main.dart';
import 'DB.dart';


void main() => runApp(Reminder(0,"","","",""));
class Reminder extends StatefulWidget {
  int id;
  String judul;
  String isi;
  String tanggal;
  String lokasi;
  Reminder(this.id, this.judul, this.isi, this.tanggal, this.lokasi);
  @override
  _ReminderState createState() => _ReminderState(this.id, this.judul, this.isi, this.tanggal, this.lokasi);
}


class _ReminderState extends State<Reminder> {
  int id;
  String judul;
  String isi;
  String tanggal;
  String lokasi;
  File image;
  String path = '';
  _ReminderState(this.id, this.judul, this.isi, this.tanggal, this.lokasi);
  void hapusData(int id) async{
    DB helper = DB.instance;
    helper.deleteReminder(id);
  }
  void hapusFirestore(int id) async{
    await Firestore.instance.collection(loggedInUser.uid).document(id.toString()).delete();
  }
  void download() async{
    print(UID+"/"+(id).toString());
    StorageReference sr = await FirebaseStorage.instance.ref().child(UID+"/"+(id+1).toString()); //sementara
    String url = await sr.getDownloadURL();
    setState(() {
      path = url;
      print(url);
    });
  }
  @override
  void initState(){
    download();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    OpenDb();
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail "),
        backgroundColor: blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView(
          children: <Widget>[
            Text(
                "Detail Acara: ",
                style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold)
            ),
            SizedBox(
              height: 15,
            ),
            Column(
              children: <Widget>[
                path!=''?
                Image.network(path,
                  width: 200,
                  height: 200,
                ):
                Text("Tidak ada Gambar"),
                SizedBox(
                  height: 15,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    Text(": "),
                    Expanded(
                      child: Text(
                        judul,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    )
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
                    Text(": "),
                    Text(
                      formatDate(DateTime.parse(tanggal),[d," ",MM," ",yyyy]).toString(),
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
                    Text(": "),
                    Text(
                      formatDate(DateTime.parse(tanggal),[HH,":",nn]).toString(),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 150,
                      child: Text(
                        "Deskripsi ",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Text(": "),
                    Expanded(
                      child: Text(
                        isi,
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
                  height: 8,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 150,
                      child: Text(
                        "Lokasi ",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Text(": "),
                    Expanded(
                      child: Text(
                        lokasi,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: RaisedButton(
                    color: blue,
                    child: Text("Edit", style: TextStyle(color: white, fontSize: 20),),
                    onPressed: () => {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) =>Edit(id,judul, tanggal, isi,lokasi),
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
            )
          ],
        ),
      ),
    );
  }
}