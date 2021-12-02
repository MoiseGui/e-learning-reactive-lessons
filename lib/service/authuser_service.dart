part of 'services.dart';

class AuthUserService extends GetxController {
  // RegisterPage r = Get.put(RegisterPage());
  final DialogController _dialogController = Get.put(DialogController());
  User user = Get.put(User());

  // var dio = Dio();
  var cookieJar = CookieJar();

  List<Cookie> cookies = [];

  register(
      {var firstname,
      var lastname,
      var email,
      var password,
      var confirmPassword}) async {
    var data = {
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'password': password,
      'confirm_password': confirmPassword,
    };

    var req = await http.post(apiRegister, body: data);
    var res = jsonDecode(req.body);

    // user.userID = res['User_id'].obs;

    var statusCode = res['Status'];
    var message = res['Message'];

    if (statusCode == 200) {
      _dialogController.successDialog(
        "Successfully Registered",
        () => Get.toNamed("/login"),
      );
    } else {
      Get.snackbar(
        "Login is failed",
        "$message",
        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
        backgroundColor: errorColor,
        colorText: bgColor,
      );
    }
  }

  login({var email, password}) async {
    var data = {
      'email': email,
      'password': password,
    };

    // dio.interceptors.add(CookieManager(cookieJar));

    var req = await http.post(apiLogin, body: data);

    // var rawCookie = req.headers['set-cookie'];
    // print(rawCookie);
    // int index = rawCookie!.indexOf(';');
    //
    // Map<String, String> headers = {};
    // headers['cookie'] =
    //     (index == -1) ? rawCookie : rawCookie.substring(0, index);
    //
    // // cookies = [new Cookie('set-cookie', )];
    // var valueCookie = headers['cookie'];
    // print(valueCookie);
    // cookies.add(Cookie('cookie', valueCookie!));
    //
    // for (var item in cookies) {
    //   print("Cetak cookie list");
    //
    //   print(item.value);
    // }
    //
    // cookieJar.saveFromResponse(apiLogin, cookies);

    // print(cookieJar.loadForRequest(
    //     Uri.parse('https://elearning-uin-arraniry.herokuapp.com')));

    var res = jsonDecode(req.body);

    user.username = res['Username'];
    user.id = res['User_id'].toString();
    // print(req.headers);

    var statusCode = 200;
    var message = res['Message'];


    if (statusCode == 200) {
      _dialogController.successDialog(
        "Successfully Logged",
        () => Get.toNamed("/home"),
      );
    } else {
      Get.snackbar(
        "Login is failed",
        "$message",
        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
        backgroundColor: errorColor,
        colorText: bgColor,
      );
    }
  }
}


