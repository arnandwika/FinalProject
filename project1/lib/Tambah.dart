import 'dart:io';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:project1/LoginPage.dart';
import 'package:project1/main.dart';

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
  final _LocEditingController = TextEditingController();
  final format = DateFormat("d MMMM y HH:mm");
  File image;
  String path='';

  OpenCamera() async{
    image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      Navigator.pop(context);
    });
  }
  OpenGallery() async{

    image = await ImagePicker.pickImage(source: ImageSource.gallery);
    String fileName = image.path.split('/').last;
    StorageReference sr = await FirebaseStorage.instance.ref().child('images/reminder-${id}/${fileName}');
//    await sr.putFile(image);
    setState(() {
      Navigator.pop(context);
    });
  }
  void upload() async{
    StorageReference sr = await FirebaseStorage.instance.ref().child(UID+"/"+id.toString());
    await sr.putFile(image);
  }
  void download() async{
    StorageReference sr = await FirebaseStorage.instance.ref().child(UID+"/"+id.toString());
    String url = await sr.getDownloadURL();
    setState(() {
      path = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text('Tambah Acara'),
        backgroundColor: blue,
      ),
      body: new Padding(padding: EdgeInsets.all(15.0),
        child: ListView(
          children: <Widget>[
            Text(
              "Detail Acara Baru: ",
                style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold)
            ),
            SizedBox(
              height: 15,
            ),
            new Column(
              children: <Widget>[
                new TextFormField(
                  controller: _JudulEditingController,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                    labelText: "Nama Acara",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: gray,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: blue,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                new DateTimeField(
                  format: format,
                  style: (
                    TextStyle(
                      fontSize: 20,
                    )
                  ),
                  decoration: InputDecoration(
                    labelText: 'Tanggal & Jam Acara',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: gray,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: blue,
                        width: 2.0,
                      ),
                    ),
                  ),
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
                SizedBox(
                  height: 8,
                ),
                new TextFormField(
                  controller: _IsiEditingController,
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Deskripsi Acara',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: gray,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: blue,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                new TextFormField(
                  controller: _LocEditingController,
                  maxLines: null,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Lokasi Acara',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: gray,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: blue,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "Tambah Foto : ",
                      style: TextStyle(
                        fontSize: 20
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    FlatButton(
                      color: gray,
                      child: Text("Pilih...", style: TextStyle(color: black),),
                      onPressed: (){
                        _showMyDialog();
                      },
                    ),
                  ],
                ),
                image!=null?
                Image.file(image,
                  width: 200,
                  height: 200,):
                Text(""),
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: RaisedButton(
                    color: blue,
                    child: Text("Tambah Acara", style: TextStyle(color: white, fontSize: 20),),
                    onPressed: () async {
                      await InsertDb(_JudulEditingController.text, tanggalJam, _IsiEditingController.text, _LocEditingController.text);
                      await OpenDb();
                      await getFirestore();
                      upload();
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/home');
                    },
                  ),
                )
              ],
            ),
          ],
        )
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.camera_alt,
                      size: 50,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text('Kamera',
                      style: (
                        TextStyle(
                            fontSize: 18
                        )
                      ),
                    )
                  ],
                ),
                onPressed: () {
                  OpenCamera();
                },
              ),
              FlatButton(
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.folder_open,
                      size: 50,
                    ),
                    Text('Galeri',
                      style: (
                        TextStyle(
                          fontSize: 18
                        )
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  OpenGallery();
                },
              ),
            ],
          )
        );
      },
    );
  }
}



