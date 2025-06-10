class MassUnit {
  int? id;
  String name;
  String symbol;

  MassUnit({this.id, required this.name, required this.symbol});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'symbol': symbol};
  }

  factory MassUnit.fromMap(Map<String, dynamic> map) {
    return MassUnit(id: map['id'], name: map['name'], symbol: map['symbol']);
  }
}
