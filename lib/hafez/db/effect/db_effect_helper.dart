import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as p;
import 'package:ultimate_flutter_db_sqflite/hafez/model/effect_model.dart';
import 'package:ultimate_flutter_db_sqflite/hafez/model/effects_items_model.dart';


abstract class DBEffectHelper {
  static Database? _db;

  static int get _version => 1;

  static Future<void> init() async {
    if (_db != null) {
      return;
    }
    try {
      var databasePath = await getDatabasesPath();
      String _path = p.join(databasePath, 'hafez.db');
      _db = await openDatabase(_path,
          version: _version, onCreate: onCreate, onUpgrade: onUpgrade);
    } catch (ex) {
      print(ex);
    }
  }

  static void onCreate(Database db, int version) async {
    String sqlQuery =
        'CREATE TABLE effects (id INTEGER PRIMARY KEY AUTOINCREMENT, title STRING, effectId INTEGER, slugUrl STRING)';
    await db.execute(sqlQuery);
    String sqlEffectsItems =
        'CREATE TABLE effectsItems (id INTEGER PRIMARY KEY AUTOINCREMENT, title STRING, effectItemsId INTEGER, urlSlug STRING, excerpt STRING)';
    await db.execute(sqlEffectsItems);
  }

  static void onUpgrade(Database db, int oldVersion, int version) async {
    if (oldVersion > version) {}
  }

  static Future<List<Map<String, dynamic>>> query(String table) async {
    return _db!.query(table);
  }

  static Future<int> insertEffects(String table, EffectModel model) async {
    Map<String, dynamic> map = {
      'effectId': model.id,
      'title': model.title,
      'slugUrl': model.slugUrl
    };
    return await _db!.insert(table, map);
  }

  static Future<int> insertEffectsItem(String table, EffectsItemsModel model) async {
    Map<String, dynamic> map = {
      'effectItemsId': model.id,
      'title': model.title,
      'urlSlug': model.urlSlug,
      'excerpt': model.excerpt
    };
    return await _db!.insert(table, map);
  }

  //
  // static Future<int> update(String table, Model model) async {
  //   return await _db!
  //       .update(table, model.toJson(), where: 'id = ?', whereArgs: [model.id]);
  // }
  //
  // static Future<int> delete(String table, Model model) async {
  //   return await _db!.delete(table, where: 'id = ?', whereArgs: [model.id]);
  // }
}
