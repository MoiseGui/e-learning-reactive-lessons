part of 'services.dart';

class AuthService extends GetConnect {
  Future<Response> login({required var email, required var password}) {
    final data = {
      'email': email,
      'password': password,
    };

    // print("REQUEST: "+apiHost + loginPath);

    return post(
      apiHost + loginPath,
      data,
    );
  }

  Future<Response> register({required var email, required var password, required var firstname, required var lastname}) {
    final data = {
      'email': email,
      'password': password,
      'firstname': firstname,
      'lastname': lastname,
    };

    // print("REQUEST: "+apiHost + registerPath);

    return post(
      apiHost + registerPath,
      data,
    );
  }

  Future<User?> checkAuth({miniMumRole = "", redirect = true}) async {
    final _sharePref = await SharedPreferences.getInstance();

    var user;

    String? userString = _sharePref.getString('user');
    if(userString != null) user = User.fromJson(jsonDecode(userString));

    if (user == null || user.token == null || user.token == "" || Jwt.isExpired(user.token)) {
      // print("User not connected or token expired");
      _sharePref.clear();
      if(redirect) Get.offNamed(RouteName.loginPage);
    }

    if(miniMumRole != "" && !user.roles.contains(miniMumRole)){
      Get.offNamed(RouteName.home);
    }

    return user;
  }
}
