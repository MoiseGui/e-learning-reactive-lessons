part of 'controllers.dart';

class ClassController extends GetxController {
  var classID = ''.obs;

  final userC = Get.find<UserController>();

  createClass(
    var className,
    var token,
  ) {
    ClassService()
        .createNewClass(
      className: className,
      token: token,
    )
        .then((value) {
      var resBody = value.body;
      var resp = value.statusCode;
      // var res = jsonDecode(resBody);
      // print(res);
      print(resp);

      print(value.headers);

      if (value.statusCode == 200) {
        var statusCode = resBody['Status'];
        if (statusCode == 200) {
          DialogController().successDialog("Successfully Logged", () {
            Get.close(0);
            Get.offAndToNamed("/home");
          });
        } else {
          var message = resBody['Message'];
          Get.snackbar(
            "Login is failed",
            "$message",
            margin: EdgeInsets.only(top: 10, left: 10, right: 10),
            backgroundColor: errorColor,
            colorText: bgColor,
          );
        }
      } else if (value.unauthorized) {
        Get.snackbar(
          "Login is failed",
          "${value.statusText!.capitalizeFirst}",
          margin: EdgeInsets.only(top: 10, left: 10, right: 10),
          backgroundColor: errorColor,
          colorText: bgColor,
        );
      }
    });
  }
}
