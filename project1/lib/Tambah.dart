import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  final format = DateFormat("d MMMM y HH:mm");
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
//                  controller: _LocEditingController,
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
                  height: 50,
                ),
                RaisedButton(
                  color: blue,
                  child: Text("Tambah Acara", style: TextStyle(color: white),),
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
          ],
        )
      ),
    );
  }
}