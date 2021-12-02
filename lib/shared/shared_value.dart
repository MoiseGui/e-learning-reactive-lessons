part of "shared.dart";

var apiHost = "https://elearning-fstg.herokuapp.com";
var loginPath = "/api/auth/login";
var registerPath = "/api/auth/register";
var classPath = "/classes/";

var apiRegister = Uri.parse(apiHost + registerPath);
var apiLogin = Uri.parse(apiHost + loginPath);
var apiClass = Uri.parse(apiHost + classPath);

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


