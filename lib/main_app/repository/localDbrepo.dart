import 'package:sqflite/sqflite.dart';
import 'package:untitled/main_app/model/locationDataModel.dart';
import 'package:path/path.dart';
import 'package:untitled/main_app/view/home.dart';

class DBRepo{

  static Database? _database;

  static Future<void> init() async{
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async => await db.execute(DBQueries.DB_CREATION));
  }

  Future<bool> saveData(LocationDataModel data) async{
    try{

      await _database!.rawInsert(
        DBQueries.INSERT_DATA,
        [
          data.title,
          data.location.latitude,
          data.location.longitude,
          DateTime.now().millisecondsSinceEpoch
        ]
      );
      Home.setData(await getAllData());
      return false;
    }catch(e){
      print(e.toString());
      return true;
    }
  }

  Future<List<LocationDataModel>> getAllData() async{
    try{

      final List<Map<String, dynamic>> data = await _database!.rawQuery(DBQueries.GET_ALL_DATA);

      return List.from(data.map((Map<String, dynamic>item) => LocationDataModel.fromJson(item)));
    }catch(e){
      print(e.toString());
      return [];
    }
  }
}

class DBTables{
  static const String TABLE_TEST = 'locationDataTest';
  static const String TABLE_MAIN = 'locationDataMain';
  static const String TABLE_TEMP = 'locationDataTemp';
}

class DBQueries{
  static const _TABLE = DBTables.TABLE_TEST;

  static const String DB_CREATION = 'CREATE TABLE IF NOT EXISTS $_TABLE (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, lat REAL, lng REAL, createdAt INTEGER)';
  static const String GET_ALL_DATA = 'SELECT * FROM $_TABLE';
  static const String INSERT_DATA = 'INSERT INTO $_TABLE(title, lat, lng, createdAt) VALUES(?, ?, ?, ?)';
}