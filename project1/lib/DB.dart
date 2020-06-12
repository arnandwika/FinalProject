import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DB{
  static final databaseName = "project1.db";
  static final databaseVersion = 1;

  DB.internal();
  static final DB instance = new DB.internal();

  static Database db;

  Future<Database> get database async {
    if (db != null) return db;
    db = await _initDatabase();
    return db;
  }

  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path.toString()+databaseName;
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: databaseVersion,
        onCreate: BuatDB);
  }

  Future BuatDB(Database db, int version) async{
    await db.execute(
      "CREATE TABLE reminder(id INTEGER PRIMARY KEY AUTOINCREMENT, judul TEXT, isi TEXT, tanggal TEXT, lokasi TEXT)",);
    await db.execute(
      "CREATE TABLE foto(id INTEGER PRIMARY KEY AUTOINCREMENT, nama TEXT, idReminder INTEGER)",);
  }

  Future<List<Map>> listReminder(formattedDate) async {
    Database dbTemp = await database;
    return await dbTemp.rawQuery('SELECT * FROM reminder WHERE tanggal > "'+formattedDate+'" ORDER BY tanggal ASC');
  }

  Future<List<Map>> mapListFoto(int id) async{
    Database dbTemp = await database;
    return await dbTemp.rawQuery('SELECT * FROM foto WHERE idReminder ="'+id.toString()+'"');
  }
  Future<List<Map>> listHistory(formattedDate) async {
    Database dbTemp = await database;
    print(formattedDate);
    return await dbTemp.rawQuery('SELECT * FROM reminder WHERE tanggal < "'+formattedDate+'" ORDER BY tanggal ASC');
  }

  Future<List<Map>> lastId() async {
    Database dbTemp = await database;
    return await dbTemp.rawQuery('SELECT MAX(id) FROM reminder');
  }

  Future<int> insertReminder(String judul, String tanggal, String isi, String lokasi) async {
    Database dbTemp = await database;
    ObjectReminder objectInsert = new ObjectReminder(judul: judul, tanggal: tanggal, isi: isi, lokasi: lokasi);
    return await dbTemp.insert('reminder',objectInsert.toMap());
  }

  Future<void> deleteReminder(int id) async {
    Database dbTemp = await database;
    await dbTemp.delete('reminder',where: "id=?", whereArgs: [id]);
  }

  Future<int> insertFoto(String nmFoto, int id) async{
    Database dbTemp = await database;
    ObjectFoto objectFoto = new ObjectFoto(namaFoto: nmFoto, idReminder: id);
    return await dbTemp.insert('foto',objectFoto.toMap());
  }

  Future <int> editReminder(String judulB, String tanggalB, String isiB, String lokasiB, int id) async{
    Database dbTemp = await database;
    return await dbTemp.rawUpdate(
        'UPDATE reminder SET judul = ?, tanggal = ?, isi = ?, lokasi = ? WHERE id = ?',
        [judulB, tanggalB, isiB, id]);
  }
}
class ObjectFoto{
  String namaFoto;
  int idReminder;
  ObjectFoto({this.namaFoto,this.idReminder});
  Map<String, dynamic> toMap(){
    return{
      'nama': namaFoto,
      'idReminder': idReminder,
    };
  }
}
class ObjectReminder{
  String judul;
  String tanggal;
  String isi;
  String lokasi;
  ObjectReminder({this.judul,this.tanggal,this.isi, this.lokasi});
  Map<String, dynamic> toMap(){
    return{
      'judul': judul,
      'isi': isi,
      'tanggal': tanggal,
      'lokasi': lokasi,
    };
  }
}