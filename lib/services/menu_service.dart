import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../modal/menu_modal.dart';

class MenuService {

  static Future<List<MenuModal>> listMenu() async {
    final db = await menuDatabase();
    List<Map<String, dynamic>> results = await db.query('menu');
    return List.generate(results.length, (i) {
      return MenuModal(
        id: results[i]['id'],
        name: results[i]['name'],
        weight: results[i]['weight'],
      );
    });
  }

  static Future<void> insertMenu(MenuModal menuModal) async {
    final db = await menuDatabase();
    await db.insert('menu',
        menuModal.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateMenu(MenuModal menuModal) async {
    final db = await menuDatabase();
    return db.update('menu',
        menuModal.toMap(),
        where: 'id = ?',
        whereArgs: [menuModal.id],);
  }

  static Future<int> deleteMenu(int id) async {
    final db = await menuDatabase();
    return db.delete('menu',
        where: 'id = ?',
        whereArgs: [id],);
  }

  static Future<double?> sumTheWeight() async {
    final db = await menuDatabase();
    List<Map<String, Object?>> result = await db.rawQuery("""
      select sum(weight) as result from menu
    """);
    return result[0]['result'] as double;
  }

  static Future<void> dropTableIfExists() async {
    Database db = await menuDatabase();
    await db.execute("""
      drop table if exists menu
    """);
    return createTable();
  }

  static Future<void> createTable() async {
    Database db = await menuDatabase();
    return db.execute(
        """create table menu(id integer primary key autoincrement, 
            name text not null, 
            weight real)"""
    );
  }

  static Future<Database> menuDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'menu.db'),
      onCreate: (db, version) {
        debugPrint('db created');
        return createTable();
      },
      version: 1,
    );
  }

}