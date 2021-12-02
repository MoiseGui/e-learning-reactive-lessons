part of 'controllers.dart';

class UserController extends GetxController {
  var id = ''.obs;
  var username = ''.obs;
  String? token = '';

  userLogin(var email, var password) {
    try {
      AuthService().login(email: email, password: password).then((response) {
        var resBody = response.body;

        if (response.statusCode == 200) {
          var responseUser = resBody["user"];
          print(responseUser);

          var username = (responseUser["username"] != null &&
                  responseUser["username"] != '')
              ? responseUser["username"]
              : responseUser["firstname"] + " " + responseUser["lastname"];

          _saveData(responseUser["_id"], responseUser["email"], username,
              responseUser["token"]);

          DialogController()
              .successDialog("Vous vous êtes connecté avec succès", () {
            Get.close(0);
            Get.offAndToNamed("/");
          });
        } else {
          var message = resBody['message'];
          Get.snackbar(
            "Connexion échouée.",
            "$message",
            margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
            backgroundColor: errorColor,
            colorText: whiteColor,
            duration: const Duration(seconds: 4),
          );
        }
      });
    } catch (e) {
      print("Error login: " + e.toString());
      Get.snackbar(
        "Une erreur est survenue.",
        "Veuillez vérifier votre connexion internet.",
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
        backgroundColor: errorColor,
        colorText: whiteColor,
        duration: const Duration(seconds: 4),
      );
    }
  }

  registerUser(var firstname, var lastname, var email, var password) {
    try {
      AuthService()
          .register(
              email: email,
              password: password,
              firstname: firstname,
              lastname: lastname)
          .then((response) {
        print(response.body);
        var message = response.body != null
            ? response.body['message'] ?? 'Veuillez réesayer plus tard.'
            : 'Veuillez réesayer plus tard.';
        if (response.statusCode == 201) {
          DialogController().successDialog(message, () {
            Get.toNamed("/login");
          });
        } else {
          Get.snackbar(
            "Une erreur est survenue.",
            message,
            margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
            backgroundColor: errorColor,
            colorText: whiteColor,
            duration: const Duration(seconds: 4),
          );
        }
      });
    } catch (e) {
      print("Error register: " + e.toString());
      Get.snackbar(
        "Une erreur est survenue.",
        "Veuillez vérifier votre connexion internet.",
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
        backgroundColor: errorColor,
        colorText: whiteColor,
        duration: const Duration(seconds: 4),
      );
    }
  }

  _saveData(var id, var email, var username, var token) async {
    // try {
    final _sharePref = await SharedPreferences.getInstance();

    // final _storage = FlutterSecureStorage();

    // await _storage.write(key: 'username', value: username);

    // var user = await _storage.read(key: 'username');
    // print(user);

    _sharePref.setString('id', id);
    _sharePref.setString('email', email);
    _sharePref.setString('token', token);
    _sharePref.setString('username', username);

    // } catch (e) {
    //   print("ERREUR SAVE DATA "+e.toString());
    // }
  }
}
