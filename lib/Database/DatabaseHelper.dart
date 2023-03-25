import 'dart:async';
import 'dart:io';
import 'package:movieapi/Models/WatchlistModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


/*information*\
  * This class is used to create the database and the table
  * This class is used to insert, delete and get data from the database
  * This class is used to check if a movie is in the watchlist
\*information */

class DatabaseHelper {
  static final _databaseName = "watchlist_database.db";
  static final _databaseVersion = 1;//database version

  static final watchlistTable = 'watchlist_table';//table name
  static final columnId = '_id';//unique id
  static final columnName = 'name';//movie/tvshow name
  static final columnDescription = 'description';//movie/tvshow description
  static final columnBannerUrl = 'bannerurl';//movie/tvshow banner url
  static final columnPosterUrl = 'posterurl';//movie/tvshow poster url

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();//singleton (uses single database connection)

  static Database? _database;

  Future<Database> get database async {  //get database
    if (_database != null) return _database!;//if database is not null, return database
    _database = await _initDatabase();//if database is null, create a new database
    return _database!;
  }

  Future<Database> _initDatabase() async {//create database
    String path = join(await getDatabasesPath(), _databaseName);//get path to database
    return await openDatabase(
      path,//path to database
      version: _databaseVersion,//database version
      onCreate: _onCreate,//create table
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

  Future<int> insertWatchlist(WatchlistModel watchlistModel) async {//insert data into database
    Database db = await instance.database;
    return await db.insert(watchlistTable, watchlistModel.toMap());
  }

  Future<int> deleteWatchlistByName(//delete data from database
    String name,
  ) async {
    Database db = await instance.database;
    return await db.delete(
      watchlistTable,
      where: '$columnName = ?',
      whereArgs: [name],
    );
  }

  Future<List<WatchlistModel>> getWatchlist() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(watchlistTable);//get all data from database
    return List.generate(maps.length, (i) {//return list of watchlistmodel
      return WatchlistModel(
        id: maps[i][columnId],
        name: maps[i][columnName],
        description: maps[i][columnDescription],
        bannerurl: maps[i][columnBannerUrl],
        posterurl: maps[i][columnPosterUrl],
      );
    });
  }

  Future<int> deleteWatchlist(int id) async {//delete data from database
    Database db = await instance.database;
    return await db.delete(
      watchlistTable,
      where: '$columnId = ?',//delete by id
      whereArgs: [id],
    );
  }

  Future<bool> isMovieInWatchlist(String name) async {//bool to check if movie is in watchlist
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      watchlistTable,
      where: '$columnName = ?',//check by name
      whereArgs: [name],
    );
    return maps.isNotEmpty;//return true if movie is in watchlist
  }
}
