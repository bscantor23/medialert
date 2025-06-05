class User {
  int? id;
  String name;
  int age;
  String email;

  User({
    this.id,
    required this.name,
    required this.age,
    required this.email,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'age': age,
    'email': email,
  };

  factory User.fromMap(Map<String, dynamic> map) => User(
    id: map['id'],
    name: map['name'],
    age: map['age'],
    email: map['email'],
  );
}
