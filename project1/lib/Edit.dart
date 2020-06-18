import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:project1/LoginPage.dart';
import 'package:sqflite/sqflite.dart';

import 'Maps.dart';
import 'Reminder.dart';
import 'main.dart';
import 'DB.dart';
import 'package:project1/Tambah.dart';

void main() => runApp(Edit(0,"","","",""));

Future<bool> databaseExists(String path) =>
    databaseFactory.databaseExists(path);

TextEditingController locEditingController2 = TextEditingController();

class EditRunner extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Edit(0,"","","",""),
    );
  }
}

class Edit extends StatefulWidget{
  int id;
  String judul;
  String tanggal;
  String deskripsi;
  String lokasi;
  Edit(this.id,this.judul, this.tanggal, this.deskripsi, this.lokasi);
  @override
  State createState(){
    return EditState(this.id,this.judul,this.tanggal, this.deskripsi, this.lokasi);
  }
}

class HasilEdit{
  String judul;
  String tanggal;
  String isi;
  String lokasi;
  HasilEdit({this.judul,this.tanggal,this.isi,this.lokasi});
  Map<String, dynamic> toMap(){
    return{
      'judul': judul,
      'isi': isi,
      'tanggal': tanggal,
      'lokasi': lokasi,
    };
  }
}
class EditState extends State<Edit>{
  int id=0;
  String judul;
  String tanggal;
  String deskripsi;
  String lokasi;
  EditState(this.id,this.judul, this.tanggal, this.deskripsi, this.lokasi);
  final TextJudulController = TextEditingController();
  final TextTanggalController = TextEditingController();
  final TextIsiController = TextEditingController();
  void updateDb(int id, String judulBaru, String tanggalBaru, String isiBaru, String lokasiBaru) async{
    DB helper = DB.instance;
    int count = await helper.editReminder(judulBaru, tanggalBaru, isiBaru,  lokasiBaru, id);
    print('updated: $count');
    DateTime waktu = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(waktu);
    list = await helper.listReminder(formattedDate);
  }
  void editFirestore(int id, String judulBaru, String tanggalBaru, String isiBaru, String lokasiBaru) async{
    Map<String, dynamic> temp = new Map<String, dynamic>();
    temp['id'] = id;
    temp['judul'] = judulBaru;
    temp['tanggal'] = tanggalBaru;
    temp['isi'] = isiBaru;
    temp['lokasi'] = lokasiBaru;
    await Firestore.instance.collection(loggedInUser.uid).document(id.toString()).updateData(temp);
  }
  final format = DateFormat("d MMMM y HH:mm");
  String tanggalJam="";
  File image;
  String path = '';
  OpenCamera() async{
    image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      Navigator.pop(context);
    });
  }
  OpenGallery() async{
    image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      Navigator.pop(context);
    });
  }
  void upload() async{
    StorageReference sr = await FirebaseStorage.instance.ref().child(UID+"/"+id.toString());
    await sr.putFile(image);
  }
  void download() async{
    print(UID+"/"+(id).toString());
    StorageReference sr = await FirebaseStorage.instance.ref().child(UID+"/"+(id).toString());
    String url = await sr.getDownloadURL();
    setState(() {
      path = url;
      print(url);
    });
  }
  

  @override
  void initState(){
    download();
    alamatMaps="";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    HasilEdit h1;
    tanggalJam= tanggal;
    TextJudulController.text = this.judul;
    TextIsiController.text = this.deskripsi;
    locEditingController2.text = this.lokasi;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blue,
        title: Text("Edit Acara"),
      ),
      body: Padding(padding: EdgeInsets.all(15.0),
        child: ListView(
          children: <Widget>[
            Text(
                "Ubah Detail Acara: ",
                style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold)
            ),
            SizedBox(
              height: 15,
            ),
            Column(
              children: <Widget>[
                TextFormField(
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Nama Acara',
                    hintText: '${this.judul}',
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
                  controller: TextJudulController,
                ),
                SizedBox(
                  height: 8,
                ),
                DateTimeField(
                  format: format,
                  style: (
                      TextStyle(
                        fontSize: 20,
                      )
                  ),
                  initialValue: DateTime.parse('${this.tanggal}'),
                  decoration: InputDecoration(
                    labelText: 'Tanggal & Jam Acara',
                    hintText: '${this.tanggal}',
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
                TextFormField(
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Deskripsi Acara',
                    hintText: "${this.deskripsi}",
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
                  controller: TextIsiController,
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  onTap: (){
                    mapsLoc.text = alamatMaps;
                    MyNavigator.openMap(context);
                  },
                  controller: locEditingController2,
                  maxLines: null,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Lokasi Acara',
                    hintText: "${this.lokasi}",
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
                      "Ubah Foto : ",
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
                    )
                  ],
                ),
                image!=null?
                Image.file(image,
                  width: 200,
                  height: 200,):
                Image.network(path,
                  width: 200,
                  height: 200,
                ),
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: RaisedButton(
                    color: blue,
                    onPressed: () async =>{
                      if( TextJudulController.text.isNotEmpty&&tanggalJam!=null&& TextIsiController.text.isNotEmpty&&locEditingController2.text.isNotEmpty){
                        await updateDb(id, TextJudulController.text, tanggalJam, TextIsiController.text, locEditingController2.text),
                        await editFirestore(id, TextJudulController.text, tanggalJam, TextIsiController.text, locEditingController2.text),
                        await OpenDb(),
                        upload(),
                        print(list),
                        Navigator.pop(context),
                        Navigator.pop(context),
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Reminder(id,TextJudulController.text,TextIsiController.text,tanggalJam,locEditingController2.text)))
                      }else{
                            showDialog(
                            context: context,
                            builder: (BuildContext context){
                              return AlertDialog(
                                title: Text("Data Tidak Terisi Semua"),
                                content: Text("Lengkapi data dahulu"),
                              );
                            }
                        )
                      }

                    },
                    child: Text("Save",style: TextStyle(color: white, fontSize: 20),),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: RaisedButton(
                    color: merah,
                    onPressed: () =>{
                      Navigator.pop(context),
                    },
                    child: Text("Cancel",style: TextStyle(color: white, fontSize: 20),),
                  ),
                )
              ],
            )
          ],
        ),
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