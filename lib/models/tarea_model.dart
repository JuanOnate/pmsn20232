class TareaModel {
  int? idTarea;
  String? nombreTarea;
  String? descTarea;
  bool? estadoTarea;

  TareaModel({this.idTarea,this.nombreTarea,this.descTarea,this.estadoTarea});

  factory TareaModel.fromMap(Map<String, dynamic> map){
    return TareaModel(
      idTarea: map['idTarea'],
      nombreTarea: map['nombreTarea'],
      descTarea: map['descTarea'],
      estadoTarea: map['estadoTarea']
    );
  }
}