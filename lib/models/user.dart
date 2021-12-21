part of 'models.dart';

var ROLE_ETUDIANT = 'ETUDIANT';
var ROLE_PROFESSEUR = 'USER';
var ROLE_ADMIN = 'ADMIN';

@JsonSerializable()
class User {
  String id;
  String firstname;
  String lastname;
  String username;
  String email;
  String token;
  List<String> roles;

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.username,
    required this.token,
    required this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  static User parse(data){
    var roleList = data['roles'];
    List<String> roles = [];
    for(var r in roleList){
      roles.add(r);
    }
    var username = (data["username"] != null &&
        data["username"] != '')
        ? data["username"]
        : data["firstname"] + " " + data["lastname"];
    return User(id: data["_id"], firstname: data["firstname"], lastname: data["lastname"], email: data["email"], username: username, token: data["token"], roles: roles);
  }

  static bool isEtudiant(List<String> roles){
    return roles.contains(ROLE_ETUDIANT);
  }

  static bool isProfesseur(List<String> roles){
    return roles.contains(ROLE_PROFESSEUR);
  }

}
