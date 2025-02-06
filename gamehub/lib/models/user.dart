class User {
  String email;
  String user;
  String pwd;
  String sex;

  /// Constructor por defecto
  User({
    required this.email,
    required this.user,
    required this.pwd,
    required this.sex,
  });

  /// De un JSON que recibimos, lo pasamos a un objeto User
  User.fromJson(Map<String, Object?> json)
      : this(
        email: json['email']! as String,
        user: json['user']! as String,
        pwd: json['pwd']! as String,
        sex: json['sex']! as String,
      );

  /// Al objeto User existente, le copiamos todos los parametros nombrados
  /// que le pasemos
  User copyWith({
    String? email,
    String? user,
    String? pwd,
    String? sex,
  }) {
    return User(
      email: email ?? this.email,
      user: user ?? this.user, 
      pwd: pwd ?? this.pwd, 
      sex: sex ?? this.sex);
    }

  /// Retornamos el objeto User como un JSON
  Map<String, Object?> toJson() {
    return {
      'email': email,
      'user': user,
      'pwd': pwd,
      'sex': sex,
    };
  }
}