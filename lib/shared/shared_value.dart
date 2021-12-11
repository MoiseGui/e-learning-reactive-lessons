part of "shared.dart";

var apiHost = "https://elearning-fstg.herokuapp.com";
var loginPath = "/api/auth/login";
var registerPath = "/api/auth/register";
var coursesPath = "/api/courses";
var categoriesPath = "/api/categories";

var apiRegister = Uri.parse(apiHost + registerPath);
var apiLogin = Uri.parse(apiHost + loginPath);
var apiCourses = Uri.parse(apiHost + coursesPath);
var apiCategories = Uri.parse(apiHost + categoriesPath);

class DialogController {
  Future<Timer> startTimer(void Function() goTo) async {
    return Timer(const Duration(seconds: 3), goTo);
  }

  successDialog(var msg, void Function() goTo) {
    Get.defaultDialog(
      title: '',
      content: CustomDialog(msg: msg),
    );
    startTimer(goTo);
  }
}


