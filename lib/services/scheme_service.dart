import 'package:flutter/material.dart';
import 'package:lunch_counselor/modal/scheme_modal.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SchemeService {

  static Future<List<SchemeModal>> listScheme() async {
    final db = await schemeDatabase();
    List<Map<String, dynamic>> results = await db.query('scheme');
    return List.generate(results.length, (i) {
      return SchemeModal(
        id: results[i]['id'],
        name: results[i]['name'],
      );
    });
  }

  static Future<void> insertScheme(SchemeModal modal) async {
    final db = await schemeDatabase();
    await db.insert('scheme',
        modal.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteScheme(int id) async {
    final db = await schemeDatabase();
    return db.delete('scheme',
      where: 'id = ?',
      whereArgs: [id],);
  }

  static Future<void> dropTableIfExists() async {
    Database db = await schemeDatabase();
    return db.execute("""
      drop table if exists scheme
    """);
  }

  static Future<Database> schemeDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'scheme.db'),
      onCreate: (db, version) {
        debugPrint('scheme.db created');
        return db.execute(
          """
            create table scheme(id integer primary key autoincrement, 
            name text not null)
          """
        );
      },
      version: 1,
    );
  }
}