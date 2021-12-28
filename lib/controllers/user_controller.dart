part of 'controllers.dart';

class UserController extends GetxController {
  final CourseController _courseController = Get.find();
  final CategoryController _categoryController = Get.find();
  var id = ''.obs;
  var username = ''.obs;
  String? token = '';
  var user;

  userLogin(var email, var password) {
    try {
      AuthService().login(email: email, password: password).then((response) {
        var resBody = response.body;

        if (response.statusCode == 200) {
          var responseUser = resBody["user"];
          // print(responseUser);

          user = User.parse(responseUser);

          if (user != null) _saveData(user);

          DialogController()
              .successDialog("Vous vous êtes connecté avec succès", () {
            Get.close(0);
            if(user.id != null && user.roles != null) {
              // await _categoryController.loadAllCategories();
              // await _courseController.loadAllCourses();
              // print("User is Logged In");
              if(User.isEtudiant( user.roles)) {
                // print("As a Student");
                Get.offNamed(RouteName.home);
                // Get.toNamed(RouteName.home);
              } else if(User.isProfesseur( user.roles)) {
                // print("As a Prof");
                // Get.toNamed(RouteName.dashboard);
                Get.offNamed(RouteName.dashboard);
              }
            }
          });
        } else {
          var message = resBody != null
              ? resBody['message']
              : "une erreur inantandue s'est produite. Vérifiez votre connexion.";
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
      // print("Error login: " + e.toString());
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
        var message = response.body != null
            ? response.body['message'] ?? 'Veuillez réesayer plus tard.'
            : 'Veuillez réesayer plus tard.';
        if (response.statusCode == 201) {
          DialogController().successDialog(message, () {
            Get.close(0);
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
      // print("Error register: " + e.toString());
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

  _saveData(User user) async {
    // print("SAVE_USER");
    try {
      final _sharePref = await SharedPreferences.getInstance();

      // _sharePref.setString('id', user.id);
      // _sharePref.setString('email', user.email);
      // _sharePref.setString('token', user.token);
      // _sharePref.setString('username', user.username);
      // _sharePref.setStringList('roles', user.roles);
      _sharePref.setString('user', jsonEncode(user.toJson()));
    } catch (e) {
      // print("ERREUR IN SAVE_DATA " + e.toString());
    }
  }

  logout() async {
    final _sharePref = await SharedPreferences.getInstance();
    await _sharePref.clear();

    id = ''.obs;
    username = ''.obs;
    token = '';
    user = null;
  }
}
