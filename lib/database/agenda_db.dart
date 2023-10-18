import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pmsn20232/models/popular_model.dart';
import 'package:pmsn20232/models/tarea_model.dart';
import 'package:sqflite/sqflite.dart';

class AgendaDB {
  static final nameDB = 'AGENDADB';
  static final versionDB = 1;

  static Database? _database;
  Future <Database?> get database async {
    if(_database != null) return _database!;
    return _database = await _initDatabase();
  }
  
  Future<Database?> _initDatabase() async {
    Directory folder = await getApplicationDocumentsDirectory();
    String pathDB = join(folder.path, nameDB);
    return openDatabase(
      pathDB,
      version: versionDB,
      onCreate: _createTables
    );
  }

  FutureOr<void> _createTables(Database db, int version) async{
    await db.execute('''CREATE TABLE tblTareas(idTarea INTEGER PRIMARY KEY, 
                                              nombreTarea VARCHAR(50), 
                                              descTarea VARCHAR(50), 
                                              estadoTarea BYTE);''');
    await db.execute('''CREATE TABLE tblFavoritas(
        id INTEGER PRIMARY KEY,
        backdropPath TEXT,
        originalLanguage TEXT,
        originalTitle TEXT,
        overview TEXT,
        popularity REAL,
        posterPath TEXT,
        releaseDate TEXT,
        title TEXT,
        voteAverage REAL,
        voteCount INTEGER,
        isFavorite INTEGER
      );''');
    
  }

    // Insertar película favorita
  Future<int> insertFavoriteMovie(PopularModel movie) async {
    var conexion = await database;
    return conexion!.insert('tblFavoritas', movie.toMap());
  }

  // Actualizar película favorita
  Future<int> updateFavoriteMovie(PopularModel movie) async {
    var conexion = await database;
    return conexion!.update('tblFavoritas', movie.toMap(),
        where: 'id = ?', whereArgs: [movie.id]);
  }

  // Eliminar película favorita
  Future<int> deleteFavoriteMovie(int id) async {
    var conexion = await database;
    return conexion!
        .delete('tblFavoritas', where: 'id = ?', whereArgs: [id]);
  }

  // Obtener todas las películas favoritas
  Future<List<PopularModel>> getFavoriteMovies() async {
    var conexion = await database;
    var result = await conexion!
        .query('tblFavoritas', where: 'isFavorite = 1');
    return result.map((movie) => PopularModel.fromMap(movie)).toList();
  }

  Future<int> INSERT(String tblName, Map<String,dynamic> data) async{
    var conexion = await database;
    return conexion!.insert(tblName, data);
  }

  Future<int> UPDATE(String tblName, Map<String,dynamic> data) async{
    var conexion = await database;
    return conexion!.update(tblName, data, where: 'idTarea = ?', whereArgs: [data['idTarea']]);
  }

  Future<int> DELETE(String tblName, int idTarea) async{
    var conexion = await database;
    return conexion!.delete(tblName, where: 'idTarea = ?', whereArgs: [idTarea]);
  }

  Future<List<TareaModel>> GETALLTAREAS() async{
    var conexion = await database;
    var result = await conexion!.query('tblTareas');
    return result.map((task)=>TareaModel.fromMap(task)).toList();
  }
}