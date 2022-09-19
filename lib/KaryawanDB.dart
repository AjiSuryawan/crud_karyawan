import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'KaryawanModel.dart';


class KaryawanDatabase{
  static final KaryawanDatabase instance = KaryawanDatabase.init();

  static Database? _database;

  KaryawanDatabase.init();

  Future<Database> get database async{
    if (_database != null) return _database!;

    _database = await _initDB('karyawan.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async{
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';

    await db.execute('''CREATE TABLE $tableKaryawan (
    ${KaryawanFields.id} $idType,
    ${KaryawanFields.name} $textType,
    ${KaryawanFields.imagePath} $textType,
    ${KaryawanFields.date} $textType
    
    
    )''');
  }

  Future<KaryawanModel> create(KaryawanModel news) async{
    final db = await instance.database;

    final id = await db.insert(tableKaryawan, news.toJson());
    return news.copy(id: id);
  }

  Future<KaryawanModel> read(int? id) async{
    final db = await instance.database;

    final maps = await db.query(
      tableKaryawan,
      columns: KaryawanFields.values,
      where: '${KaryawanFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty){
      return KaryawanModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<KaryawanModel>> readAll() async{
    final db = await instance.database;

    final result = await db.query(tableKaryawan);

    return result.map((json) => KaryawanModel.fromJson(json)).toList();
  }

  delete(int? id) async {
    final db = await instance.database;
    try {
      await db.delete(
        tableKaryawan,
        where: '${KaryawanFields.id} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print(e);
    }
  }

  update(KaryawanModel karyawanModel) async {
    final db = await instance.database;
    try {
      db.rawUpdate('''
    UPDATE ${tableKaryawan} 
    SET ${KaryawanFields.name} = ?, ${KaryawanFields.date} = ?, ${KaryawanFields.imagePath} = ?
    WHERE ${KaryawanFields.id} = ?
    ''', [
        karyawanModel.name,
        karyawanModel.date,
        karyawanModel.imagePath,
        karyawanModel.id
      ]);
    } catch (e) {
      print('error: ' + e.toString());
    }
  }


  Future close() async{
    final db = await instance.database;
    db.close();
  }
}