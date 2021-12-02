part of 'services.dart';

class AuthService extends GetConnect {
  Future<Response> login({required var email, required var password}) {
    final data = {
      'email': email,
      'password': password,
    };

    print("REQUEST: "+apiHost + loginPath);

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

    print("REQUEST: "+apiHost + registerPath);

    return post(
      apiHost + registerPath,
      data,
    );
  }
}
