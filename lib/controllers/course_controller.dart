part of 'controllers.dart';

class CourseController extends GetxController {
  late List<Course> courses = [];
  late dio.Dio _dio;
  final dio.BaseOptions options = dio.BaseOptions(
    baseUrl: apiHost + coursesPath,
  );

  CourseController() {
    _init();
  }

  Future _init() async {
    _dio = dio.Dio(options);
    final _sharePref = await SharedPreferences.getInstance();
    var token = _sharePref.getString('token');
    if (token != null) _updateDio(token);
  }

  _updateDio(String token) {
    _dio.interceptors
        .add(dio.InterceptorsWrapper(onRequest: (options, _) async {
      _dio.interceptors.requestLock.lock();

      if (token != null) options.headers['authorization'] = 'Bearer ${token}';

      _dio.interceptors.requestLock.unlock();
    }));
  }

  Future loadAllCourses() async {
    // print("here to fetch");
    // final response = await _dio.get('/');
    final courseList = await get(apiCourses);
    final list = jsonDecode(courseList.body);

    if (list != null) {
      // print('hey result');
      courses = [];
      for (var course in list) {
        courses.add(Course.parse(course));
      }
    }
    // print('fetched');
  }
}
