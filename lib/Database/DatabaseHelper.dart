import 'dart:async';
import 'dart:io';
import 'package:movieapi/Models/WatchlistModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseHelper {
  static final _databaseName = "watchlist_database.db";
  static final _databaseVersion = 1;

  static final watchlistTable = 'watchlist_table';
  static final columnId = '_id';
  static final columnName = 'name';
  static final columnDescription = 'description';
  static final columnBannerUrl = 'bannerurl';
  static final columnPosterUrl = 'posterurl';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $watchlistTable (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnDescription TEXT NOT NULL,
            $columnBannerUrl TEXT NOT NULL,
            $columnPosterUrl TEXT NOT NULL
          )
          ''');
  }

  Future<int> insertWatchlist(WatchlistModel watchlistModel) async {
    Database db = await instance.database;
    return await db.insert(watchlistTable, watchlistModel.toMap());
  }

  Future<int> deleteWatchlistByName(String name,) async {
    Database db = await instance.database;
    return await db.delete(
      watchlistTable,
      where: '$columnName = ?',
      whereArgs: [name],
    );
  }

  Future<List<WatchlistModel>> getWatchlist() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(watchlistTable);
    return List.generate(maps.length, (i) {
      return WatchlistModel(
        id: maps[i][columnId],
        name: maps[i][columnName],
        description: maps[i][columnDescription],
        bannerurl: maps[i][columnBannerUrl],
        posterurl: maps[i][columnPosterUrl],
      );
    });
  }
Future<int> deleteWatchlist(int id) async {
    Database db = await instance.database;
    return await db.delete(
      watchlistTable,
      where: '$columnId = ?',
      whereArgs: [id],
    );
}
  Future<bool> isMovieInWatchlist(String name) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      watchlistTable,
      where: '$columnName = ?',
      whereArgs: [name],
    );
    return maps.isNotEmpty;
  }
}

