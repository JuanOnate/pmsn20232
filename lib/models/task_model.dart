class TaskModel {
  int? idTask;
  String? nomTask;
  String? fecExpiracion;
  String? fecRecordatorio;
  String? desTask;
  int? realizada;
  int? idProfe;

  TaskModel({this.idTask,this.nomTask,this.fecExpiracion,this.fecRecordatorio,this.desTask,this.realizada,this.idProfe});

  factory TaskModel.fromMap(Map<String, dynamic> map){
    return TaskModel(
      idTask: map['idTask'],
      nomTask: map['nomTask'],
      fecExpiracion: map['fecExpiracion'],
      fecRecordatorio: map['fecRecordatorio'],
      desTask: map['desTask'],
      realizada: map['realizada'],
      idProfe: map['idProfe']
    );
  }
}