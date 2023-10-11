class CarreraModel {
  int? idCarrera;
  String? nomCarrera;

  CarreraModel({this.idCarrera,this.nomCarrera});

  factory CarreraModel.fromMap(Map<String, dynamic> map){
    return CarreraModel(
      idCarrera: map['idProfe'],
      nomCarrera: map['nomProfe']
    );
  }
}