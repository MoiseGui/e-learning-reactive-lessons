part of 'models.dart';

class User {
  String? id;
  String? firstName;
  String? lastName;
  String? username;
  String? email;
  String? password;
  String? token;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.username,
    this.password,
    this.token,
  });
}
