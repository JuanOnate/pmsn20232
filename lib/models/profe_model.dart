class ProfeModel {
  int? idProfe;
  String? nomProfe;
  String? email;
  int? idCarrera;

  ProfeModel({this.idProfe,this.nomProfe,this.email,this.idCarrera});

  factory ProfeModel.fromMap(Map<String, dynamic> map){
    return ProfeModel(
      idProfe: map['idProfe'],
      nomProfe: map['nomProfe'],
      email: map['email'],
      idCarrera: map['idCarrera']
    );
  }
}