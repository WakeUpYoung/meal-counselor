import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../modal/menu_model.dart';

class MenuService {

  static Future<List<MenuModel>> listMenu(int? schemeId) async {
    if (schemeId != null) {
      return listMenuBySchemeId(schemeId);
    } else {
      return listAllMenu();
    }
  }

  static Future<List<MenuModel>> listAllMenu() async {
    final db = await menuDatabase();
    List<Map<String, dynamic>> results = await db.query('menu');
    return List.generate(results.length, (i) {
      return MenuModel(
        id: results[i]['id'],
        name: results[i]['name'],
        weight: results[i]['weight'],
        schemeId: results[i]['schemeId'],
      );
    });
  }

  static Future<List<MenuModel>> listMenuBySchemeId(int schemeId) async {
    final db = await menuDatabase();
    List<Map<String, dynamic>> results = await db
        .query('menu',
            where: 'schemeId = ?',
            whereArgs: [schemeId]);
    return List.generate(results.length, (i) {
      return MenuModel(
        id: results[i]['id'],
        name: results[i]['name'],
        weight: results[i]['weight'],
        schemeId: results[i]['schemeId'],
      );
    });
  }

  static Future<void> insertMenu(MenuModel menuModal) async {
    final db = await menuDatabase();
    await db.insert('menu',
        menuModal.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateMenu(MenuModel menuModal) async {
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

  static Future<double?> sumTheWeight(int? schemeId) async {
    if (schemeId != null) {
      return sumTheWeightBySchemeId(schemeId);
    } else {
      return sumTheWeightWithoutSchemeId();
    }
  }

  static Future<double?> sumTheWeightWithoutSchemeId() async {
    final db = await menuDatabase();
    List<Map<String, Object?>> result = await db.rawQuery("""
      select sum(weight) as result from menu
    """);
    return result[0]['result'] as double;
  }

  static Future<double?> sumTheWeightBySchemeId(int schemeId) async {
    final db = await menuDatabase();
    List<Map<String, Object?>> result = await db
        .rawQuery("""
      select sum(weight) as result from menu where schemeId = ?
    """, [schemeId]);
    return result[0]['result'] as double;
  }


  static Future<void> dropTableIfExists() async {
    Database db = await menuDatabase();
    return db.execute("""
      drop table if exists menu
    """);
  }

  static Future<Database> menuDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'menu.db'),
      onCreate: (db, version) {
        debugPrint('menu.db created');
        return db.execute(
            """create table menu(id integer primary key autoincrement, 
            name text not null, 
            weight real,
            schemeId integer)"""
        );
      },
      version: 2,
    );
  }

}