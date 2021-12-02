part of 'services.dart';

class APIService extends GetxController {
  late dio.Dio _dio;

  var id = ''.obs;
  var username = ''.obs;
  User? user;

  final dio.BaseOptions options = dio.BaseOptions(
    baseUrl: "https://elearning-fstg.herokuapp.com/api/auth",
  );

  static final APIService _instance = APIService._internal();

  factory APIService() => _instance;

  APIService._internal() {
    _dio = dio.Dio(options);
    _dio.interceptors
        .add(dio.InterceptorsWrapper(onRequest: (options, _) async {
      _dio.interceptors.requestLock.lock();

      if(user != null && user!.token != null) options.headers['cookie'] = user!.token;

      _dio.interceptors.requestLock.unlock();
    }));
  }

  Future login({var email, var password}) async {
    final formRequest = {
      'email': email,
      'password': password,
    };

    try {
      final response = await _dio.post("/login", data: formRequest);

      print(response);

      var resBody = response.data;

      if (response.statusCode == 200) {
        user = resBody["user"];

        _saveData(user!.id, user!.email, user!.username, user!.token);

        DialogController().successDialog("Vous vous êtes connecté avec succès",
            () {
          // Get.close(0);
          // Get.offAndToNamed("/");
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
    } catch (e) {
      Get.snackbar(
        "Une erreur s'est produite.",
        "Vérifiez votre connexion internet",
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
        backgroundColor: errorColor,
        colorText: whiteColor,
        duration: const Duration(seconds: 4),
      );
      print(e);
    }
  }

  _saveData(var id, var email, var username, var token) async {
    try {
      final _sharePref = await SharedPreferences.getInstance();

      // final _storage = FlutterSecureStorage();

      // await _storage.write(key: 'username', value: username);

      // var user = await _storage.read(key: 'username');
      // print(user);

      _sharePref.setInt('id', id);
      _sharePref.setString('email', email);
      _sharePref.setString('token', token);
      _sharePref.setString('username', username);
    } catch (e) {
      print(e);
    }
  }
}
