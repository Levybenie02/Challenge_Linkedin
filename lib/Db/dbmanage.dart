import 'dart:io';

import 'package:flutter/material.dart';
import 'package:parking_app_version_1/Models/vehicule.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Dbmanager {
  static const dbname = 'parking_pro.db';
  static const tablename = 'CAR';

  static Database? db;
  static List<Modelcar> carItems = [];

  Future<Database> get database async => db ??= await initDb();

  Future initDb() async {
    debugPrint('DB INITIALISATION');
    final dbfolder = await getDatabasesPath();
    if (!await Directory(dbfolder).exists()) {
      await Directory(dbfolder).create(recursive: true);
    }
    final dbpath = join(dbfolder, dbname);

    db = await openDatabase(dbpath, version: 1, onCreate: ((db, version) async {
      await db.execute('''CREATE TABLE $tablename(
        id INTEGER PRIMARY KEY,
        matricule TEXT,
        marque TEXT,
        color TEXT,
        nom TEXT,
        numero TEXT,
        ispark BIT NOT NULL,
        time TEXT
      ) ''').whenComplete(() {
        debugPrint('Table $tablename is create');
      });
    }));
  }

  Future<void> getCar() async {
    final List<Map<String, dynamic>> jsons = await db!.query(
      tablename,
    );
    carItems = jsons.map((e) => Modelcar.fromJsonMap(e)).toList();
  }

  Future<void> addCar({required Modelcar car}) async {
    print("Add procees");
    await db!.insert(tablename, car.toJsonMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteCar({required Modelcar car}) async {
    await db!.delete(tablename, where: 'id = ?', whereArgs: [car.id]);
  }

  Future<void> updateCar({required Modelcar car}) async {
    await db!.update(tablename, car.toJsonMap(),
        where: 'id = ?', whereArgs: [car.id]);
  }

  Future<void> togglecar({required Modelcar car}) async {
    await db!.rawUpdate('''

    UPDATE $tablename SET ispark = ? WHERE id = ?
    ''', [if (car.ispark) 1 else 0, car.id]);
  }
}
