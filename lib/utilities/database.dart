import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:weather/models/city.dart';

class Database {
  initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    return openDatabase(
      join(await getDatabasesPath(), 'cities.db'),
      onCreate: (db, version) => db.execute(
          'CREATE TABLE IF NOT EXISTS cities(id INTEGER NOT NULL PRIMARY KEY, name TEXT NOT NULL, is_default INTEGER NOT NULL default 0);'),
      version: 1,
    );
  }

  Future<void> insert(City city) async {
    final db = await initialize();
    await db.insert('cities', city.toMap());
  }

  Future<void> update(City city) async {
    final db = await initialize();
    await db
        .update('cities', city.toMap(), where: 'id = ?', whereArgs: [city.id]);
  }

  Future<void> delete(int id) async {
    final db = await initialize();
    await db.delete('cities', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<City>> getCities() async {
    final db = await initialize();
    final List<Map<String, dynamic>> maps = await db.query('cities');
    return List.generate(
      maps.length,
      (index) => City(
        id: maps[index]['id'],
        name: maps[index]['name'],
        isDefault: maps[index]['is_default'],
      ),
    );
  }

  Future<City> getDefaultCity() async {
    final db = await initialize();
    final map = await db.query(
      'cities',
      limit: 1,
    );

    if (map.isEmpty) {
      City city = const City(
        id: 1,
        name: 'Phonm Penh',
        isDefault: 1,
      );
      await db.insert('cities', city.toMap());
      return city;
    } else {
      return City(
        id: map[0]['id'],
        name: map[0]['name'],
        isDefault: map[0]['is_default'],
      );
    }
  }
}
