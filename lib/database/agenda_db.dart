import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pmsn20232/models/carrera_model.dart';
import 'package:pmsn20232/models/profe_model.dart';
import 'package:pmsn20232/models/tarea_model.dart';
import 'package:pmsn20232/models/task_model.dart';
import 'package:sqflite/sqflite.dart';

class AgendaDB {
  static final nameDB = 'AGENDADB';
  static final versionDB = 2;

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

  FutureOr<void> _createTables(Database db, int version) {
    String query = '''CREATE TABLE tblTareas(idTarea INTEGER PRIMARY KEY, 
                                              nombreTarea VARCHAR(50), 
                                              descTarea VARCHAR(50), 
                                              estadoTarea BYTE);
                      CREATE TABLE tblCarrera(idCarrera INTEGER PRIMARY KEY,
                                              nomCarrera VARCHAR(50));
                      CREATE TABLE tblProfesor(idProfe INTEGER PRIMARY KEY,
                                               nomProfe VARCHAR(80),
                                               email VARCHAR(50),
                                               idCarrera INTEGER,
                                               foreign key(idCarrera) REFERENCES tblCarrera(idCarrera));
                      CREATE TABLE tblTask(idTask INTEGER PRIMARY KEY,
                                           nomTask VARCHAR(100),
                                           fecExpiracion DATETIME,
                                           fecRecordatorio DATETIME,
                                           desTask TEXT,
                                           realizada INTEGER,
                                           idProfe INTEGER,
                                           foreign key(idProfe) REFERENCES tblProfe(idProfe))''';
    db.execute(query);
  }

  //CRUD tblTareas
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

  //CRUD tblCarrera

  Future<int> UPDATE_CARRERA(String tblName, Map<String,dynamic> data) async{
    var conexion = await database;
    return conexion!.update(tblName, data, where: 'idCarrera = ?', whereArgs: [data['idCarrera']]);
  }

  Future<int> DELETE_CARRERA(String tblName, int idCarrera) async{
    var conexion = await database;
    return conexion!.delete(tblName, where: 'idCarrera = ?', whereArgs: [idCarrera]);
  }

  Future<List<CarreraModel>> GETALLCARRERAS() async{
    var conexion = await database;
    var result = await conexion!.query('tblCarrera');
    return result.map((carrera)=>CarreraModel.fromMap(carrera)).toList();
  }

  //CRUD tblProfesor

  Future<int> UPDATE_PROFESOR(String tblName, Map<String,dynamic> data) async{
    var conexion = await database;
    return conexion!.update(tblName, data, where: 'idProfe = ?', whereArgs: [data['idProfe']]);
  }

  Future<int> DELETE_PROFESOR(String tblName, int idProfe) async{
    var conexion = await database;
    return conexion!.delete(tblName, where: 'idProfe = ?', whereArgs: [idProfe]);
  }

  Future<List<ProfeModel>> GETALLPROFESORES() async{
    var conexion = await database;
    var result = await conexion!.query('tblProfesor');
    return result.map((profe)=>ProfeModel.fromMap(profe)).toList();
  }

  //CRUD tblTask

  Future<int> UPDATE_TASK(String tblName, Map<String,dynamic> data) async{
    var conexion = await database;
    return conexion!.update(tblName, data, where: 'idTask = ?', whereArgs: [data['idTask']]);
  }

  Future<int> DELETE_TASK(String tblName, int idTask) async{
    var conexion = await database;
    return conexion!.delete(tblName, where: 'idTask = ?', whereArgs: [idTask]);
  }

  Future<List<TaskModel>> GETALLTASKS() async{
    var conexion = await database;
    var result = await conexion!.query('tblTask');
    return result.map((tasks)=>TaskModel.fromMap(tasks)).toList();
  }
}