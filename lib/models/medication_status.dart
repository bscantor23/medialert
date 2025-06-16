class MedicationStatus {
  int? id;
  String name;
  String code;
  int textColor;
  int circleIconColor;
  int backgroundColor;
  int iconColor;
  int icon;

  MedicationStatus({
    this.id,
    required this.name,
    required this.code,
    required this.textColor,
    required this.circleIconColor,
    required this.backgroundColor,
    required this.iconColor,
    required this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'text_color': textColor,
      'circle_icon_color': circleIconColor,
      'background_color': backgroundColor,
      'icon_color': iconColor,
      'icon': icon,
    };
  }

  factory MedicationStatus.fromMap(Map<String, dynamic> map) {
    return MedicationStatus(
      id: map['id'],
      name: map['name'],
      code: map['code'],
      textColor: int.parse(map['text_color']),
      circleIconColor: int.parse(map['circle_icon_color']),
      backgroundColor: int.parse(map['background_color']),
      iconColor: int.parse(map['icon_color']),
      icon: int.parse(map['icon']),
    );
  }
}
