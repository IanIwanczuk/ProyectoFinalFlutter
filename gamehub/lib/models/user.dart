class User {
  String email;
  String user;
  String pwd;
  String sex;

  User({
    required this.email,
    required this.user,
    required this.pwd,
    required this.sex,
  });

  User.fromJson(Map<String, Object?> json)
      : this(
        email: json['email']! as String,
        user: json['user']! as String,
        pwd: json['pwd']! as String,
        sex: json['sex']! as String,
      );

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

  Map<String, Object?> toJson() {
    return {
      'email': email,
      'user': user,
      'pwd': pwd,
      'sex': sex,
    };
  }
}