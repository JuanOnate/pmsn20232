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

  //SELECT * FROM tblCarrera

  Future<List<CarreraModel>> GETALLCARRERAS() async{
    var conexion = await database;
    var result = await conexion!.query('tblCarrera');
    return result.map((carrera)=>CarreraModel.fromMap(carrera)).toList();
  }

  //SELECT * FROM tblProfesor

  Future<List<ProfeModel>> GETALLPROFESORES() async{
    var conexion = await database;
    var result = await conexion!.query('tblProfesor');
    return result.map((profe)=>ProfeModel.fromMap(profe)).toList();
  }

  //SELECT * FROM tblTask

  Future<List<TaskModel>> GETALLTASKS() async{
    var conexion = await database;
    var result = await conexion!.query('tblTask');
    return result.map((tasks)=>TaskModel.fromMap(tasks)).toList();
  }

  //UPDATE & DELETE GENERAL
  Future<int> UPDATE4(String tblName, Map<String,dynamic> data, String whereCampo, int id) async{
    var conexion = await database;
    return conexion!.update(tblName, data, where: '$whereCampo = ?', whereArgs: [id]);
  }

  Future<int> DELETE4(String tblName, String whereCampo, int id) async{
    var conexion = await database;
    return conexion!.delete(tblName, where: '$whereCampo = ?', whereArgs: [id]);
  }
}