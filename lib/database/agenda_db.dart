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
  static final versionDB = 3;

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

  FutureOr<void> _createTables(Database db, int version) async {
  // Crear la tabla tblTareas
  await db.execute('''
    CREATE TABLE tblTareas(
      idTarea INTEGER PRIMARY KEY, 
      nombreTarea VARCHAR(50), 
      descTarea VARCHAR(50), 
      estadoTarea BYTE
    )
  ''');

  // Crear la tabla tblCarrera
  await db.execute('''
    CREATE TABLE tblCarrera(
      idCarrera INTEGER PRIMARY KEY,
      nomCarrera VARCHAR(50)
    )
  ''');

  // Crear la tabla tblProfesor
  await db.execute('''
    CREATE TABLE tblProfesor(
      idProfe INTEGER PRIMARY KEY,
      nomProfe VARCHAR(80),
      email VARCHAR(50),
      idCarrera INTEGER,
      foreign key(idCarrera) REFERENCES tblCarrera(idCarrera)
    )
  ''');

  // Crear la tabla tblTask
  await db.execute('''
    CREATE TABLE tblTask(
      idTask INTEGER PRIMARY KEY,
      nomTask VARCHAR(100),
      fecExpiracion DATETIME,
      fecRecordatorio DATETIME,
      desTask TEXT,
      realizada INTEGER,
      idProfe INTEGER,
      foreign key(idProfe) REFERENCES tblProfe(idProfe)
    )
  ''');
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
    switch (tblName){
      case 'tblCarrera':
        bool hasProfessors = await _hasProfeForCarrera(id);
        if(hasProfessors){
          return 0;
        }else{
          return conexion!.delete(tblName, where: '$whereCampo = ?', whereArgs: [id]);
        }
      case 'tblProfesor':
        bool hasProfessors = await _hasTaskForProfe(id);
        if(hasProfessors){
          return 0;
        }else{
          return conexion!.delete(tblName, where: '$whereCampo = ?', whereArgs: [id]);
        }
      case 'tblTask':
        return conexion!.delete(tblName, where: '$whereCampo = ?', whereArgs: [id]);
    }
    return conexion!.delete(tblName, where: '$whereCampo = ?', whereArgs: [id]);
  }

  Future<bool> _hasProfeForCarrera(int idCarrera) async {
    var conexion = await database;
    var result = await conexion!.query('tblProfesor',
        where: 'idCarrera = ?',
        whereArgs: [idCarrera]);
    return result.isNotEmpty;
  }

  Future<bool> _hasTaskForProfe(int idProfe) async {
    var conexion = await database;
    var result = await conexion!.query('tblTask',
        where: 'idProfe = ?',
        whereArgs: [idProfe]);
    return result.isNotEmpty;
  }

  Future<List<CarreraModel>> searchCarreras(String searchTerm) async {
    var conexion = await database;
    var result = await conexion!.query('tblCarrera',
        where: 'nomCarrera LIKE ?',
        whereArgs: ['%$searchTerm%']);
    return result.map((carrera) => CarreraModel.fromMap(carrera)).toList();
  }

  Future<List<ProfeModel>> searchProfesores(String searchTerm) async {
    var conexion = await database;
    var result = await conexion!.query('tblProfesor',
        where: 'nomProfe LIKE ?',
        whereArgs: ['%$searchTerm%']);
    return result.map((profe) => ProfeModel.fromMap(profe)).toList();
  }

  Future<List<TaskModel>> searchTasks(String searchTerm, int? selectedTaskStatus) async {
    var conexion = await database;
    String whereClause = 'nomTask LIKE ?';
    List<dynamic> whereArgs = ['%$searchTerm%'];

    if (selectedTaskStatus != null){
      whereClause += ' AND realizada = ?';
      whereArgs.add(selectedTaskStatus);
    }
    var result = await conexion!.query('tblTask', where: whereClause, whereArgs: whereArgs);
    return result.map((task) => TaskModel.fromMap(task)).toList();
  }

  Future<List<TaskModel>> getTareasRecordatorio(String formattedDate) async {
    var conexion = await database;
    var result = await conexion!.query('tblTask', where: 'DATE(fecRecordatorio) = ?', whereArgs: [formattedDate]);
    return result.map((task) => TaskModel.fromMap(task)).toList();
  }

  Future<List<TaskModel>> getTareasExpiracion(String formattedDate) async {
    var conexion = await database;
    var result = await conexion!.query('tblTask', where: 'DATE(fecExpiracion) = ?', whereArgs: [formattedDate]);
    return result.map((task) => TaskModel.fromMap(task)).toList();
  }
}