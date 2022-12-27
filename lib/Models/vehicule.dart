class Modelcar {
  final int? id;
  final String matricule;
  final String marque;
  final String color;
  final String nom;
  final String numero;
  final bool ispark;
  final String time;

  Modelcar({
    this.id,
    required this.matricule,
    required this.marque,
    required this.color,
    required this.nom,
    required this.numero,
    required this.time,
    this.ispark = true,
  });

  Modelcar.fromJsonMap(Map<String, dynamic> map)
      : id = map['id'] as int,
        matricule = map['matricule'] as String,
        marque = map['marque'] as String,
        color = map['color'] as String,
        nom = map['nom'] as String,
        numero = map['nom'] as String,
        time = map['time'] as String,
        ispark = map['ispark'] == 0;

  Map<String, dynamic> toJsonMap() => {
        'id': id,
        'matricule': matricule,
        'marque': marque,
        'color': color,
        'nom': nom,
        'time': time,
        'numero': numero,
        'ispark': ispark ? 0 : 1, // if ispark=true return 0 else 1
      };
}
