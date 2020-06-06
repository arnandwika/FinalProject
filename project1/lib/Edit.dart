import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import 'Reminder.dart';
import 'main.dart';
import 'DB.dart';

void main() => runApp(Edit(0,"","",""));

Future<bool> databaseExists(String path) =>
    databaseFactory.databaseExists(path);

class EditRunner extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Edit(0,"","",""),
    );
  }
}

class Edit extends StatefulWidget{
  int id;
  String judul;
  String tanggal;
  String deskripsi;
  Edit(this.id,this.judul, this.tanggal, this.deskripsi);
  @override
  State createState(){
    return EditState(this.id,this.judul,this.tanggal, this.deskripsi);
  }
}

class HasilEdit{
  String judul;
  String tanggal;
  String isi;
  HasilEdit({this.judul,this.tanggal,this.isi});
  Map<String, dynamic> toMap(){
    return{
      'judul': judul,
      'isi': isi,
      'tanggal': tanggal,
    };
  }
}
class EditState extends State<Edit>{
  int id=0;
  String judul;
  String tanggal;
  String deskripsi;
  EditState(this.id,this.judul, this.tanggal, this.deskripsi);
  final TextJudulController = TextEditingController();
  final TextTanggalController = TextEditingController();
  final TextIsiController = TextEditingController();
  void updateDb(int id, String judulBaru, String tanggalBaru, String isiBaru) async{
    DB helper = DB.instance;
    int count = await helper.editReminder(judulBaru, tanggalBaru, isiBaru, id);
    print('updated: $count');
    DateTime waktu = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(waktu);
    list = await helper.listReminder(formattedDate);
}
  void editFirestore(int id, String judulBaru, String tanggalBaru, String isiBaru) async{
    Map<String, dynamic> temp = new Map<String, dynamic>();
    temp['id'] = id;
    temp['judul'] = judulBaru;
    temp['tanggal'] = tanggalBaru;
    temp['isi'] = isiBaru;
    await Firestore.instance.collection("reminder").document(id.toString()).updateData(temp);
  }
  final format = DateFormat("yyyy-MM-dd HH:mm");
  String tanggalJam="";
  @override
  Widget build(BuildContext context) {
    HasilEdit h1;
    TextJudulController.text = this.judul;
    TextIsiController.text = this.deskripsi;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blue,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Nama Acara',
                  hintText: '${this.judul}'
              ),
              controller: TextJudulController,
            ),
            DateTimeField(
              format: format,
              decoration: InputDecoration(
                hintText: '${this.tanggal}'
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
            Text(
                'Deskripsi'
            ),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "${this.deskripsi}",
              ),
              controller: TextIsiController,
            ),
            RaisedButton(
              onPressed: () async =>{
                await updateDb(id, TextJudulController.text, tanggalJam, TextIsiController.text),
                await editFirestore(id, TextJudulController.text, tanggalJam, TextIsiController.text),
                await OpenDb(),
                print(list),
                Navigator.pop(context),
                Navigator.pop(context),
                Navigator.push(context, MaterialPageRoute(builder: (context) => Reminder(id,TextJudulController.text,TextIsiController.text,tanggalJam)))
              },
              child: Text("Save"),
            ),
            RaisedButton(
              onPressed: () =>{
                Navigator.pop(context),
              },
              child: Text("Cancel"),
            ),
          ],
        ),
      ),
    );
  }
}