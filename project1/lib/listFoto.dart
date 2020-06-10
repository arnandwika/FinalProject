import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'DB.dart';

void main() => runApp(listFoto(0));
class listFoto extends StatefulWidget{
  int id;
  listFoto(this.id);
  @override
  State createState() {
    return listFotoState(id);
  }
}
List<Map> list;
String fullpath='';
Future OpenDbFoto(int id) async{
  DB helper = DB.instance;
  list = await helper.mapListFoto(id);

}
Future InsertDbFoto(String judul, int id) async{
  DB helper = DB.instance;
  await helper.insertFoto(judul, id);
}



class listFotoState extends State<listFoto>{
  int id;
  listFotoState(this.id);
  File file;
  String path="";
  String namaSementara;
  void doDownload() async{
    for(int i=0; i<list.length;i++){
      print("no: "+list[i]['id'].toString()+"\nnama: "+list[i]['nama'].toString()+"\nidReminder: "+list[i]['idReminder'].toString());
      await download(list[i]['nama'].toString());
//        await tampilFoto(list[i]['nama'].toString());
    }
  }
  void download(String fileName) async{
    StorageReference sr = await FirebaseStorage.instance.ref().child('images/reminder-${id}/${fileName}');
    Directory dir = await getExternalStorageDirectory();
    File fileDownloadan = File('${dir.path}/${fileName}');
    await sr.writeToFile(fileDownloadan);
    fullpath=dir.path;
    setState(() {
      path = '${dir.path}';
    });
    await OpenDbFoto(id);
  }
  void pilihFile() async{
    file = await FilePicker.getFile(
//      allowedExtensions: ['jpg', 'png', 'bmp']
    );
    String fileName = file.path.split('/').last;
    StorageReference sr = await FirebaseStorage.instance.ref().child('images/reminder-${id}/${fileName}');
    await sr.putFile(file);
    await InsertDbFoto(fileName, id);
    await doDownload();
  }
  void tampilFoto(String fileName) async{
    StorageReference sr = await FirebaseStorage.instance.ref().child('images/reminder-${id}/${fileName}');
    String url = await sr.getDownloadURL();
    setState(() {
      path = url; // kalau gak download
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Foto"),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text("Pilih File"),
            onPressed: () async =>{
              await pilihFile(),
              await OpenDbFoto(id)
            },
          ),
          RaisedButton(
            child: Text("Refresh"),
            onPressed: () async =>{
              await doDownload(),
              await OpenDbFoto(id),
            },
          ),
          Container(
            child: Expanded(
              child: ambilFoto(path),
            ),
          )
        ],
      ),
    );
  }
}

class ambilFoto extends StatefulWidget{
  String path='';
  ambilFoto(this.path);
  @override
  State createState() {
    return stateAmbilFoto(path);
  }
}

class stateAmbilFoto extends State<ambilFoto>{

  int id;
  String path ='';
  stateAmbilFoto(this.path);
  Directory dir;
  String filePath="";
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print(fullpath);
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      children: List.generate(list.length, (index){
        return Container(
          child: Column(
            children: <Widget>[
              Text("${index+1}"),
              Image(image: FileImage(File(fullpath+"/"+list[index]['nama'].toString())), width: 150, height: 150, ),
//                Image.network(path,height: 150,width: 150,)
            ],
          ),
        );
      }),
    );
  }
}