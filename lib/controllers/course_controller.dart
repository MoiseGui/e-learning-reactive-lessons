part of 'controllers.dart';

class CourseController extends GetxController {
  var user;

  late List<Course> courses = [];
  late List<Course> myCourses = [];
  final dio.BaseOptions options = dio.BaseOptions(
    baseUrl: apiHost + coursesPath,
  );

  CourseController() {
    // _init();
  }

  Future _init() async {
    try {
      user = await AuthService().checkAuth();
    } catch (e) {
      print(e);
    }
  }

  Future loadAllCourses() async {
    // print("here to fetch");
    // final response = await _dio.get('/');
    await _init();
    final courseList = await get(apiCourses);
    final list = jsonDecode(courseList.body);

    if (list != null) {
      // print('hey result');
      courses = [];
      for (var course in list) {
        Course c = Course.parse(course);
        if (user != null && user.email.compareTo(c.email) == 0) {
          myCourses.add(c);
        }
        courses.add(c);
      }
    }
    // print('fetched');
  }

  Future updateCoursesViews(id) async {
    await _init();
    if (user != null) {
      // print("here to fetch");
      // final response = await _dio.get('/');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${user.token}',
      };

      var uri = Uri.parse(apiHost + courseViewsPath + '/?id=$id');

      final result = await put(uri, headers: headers);
      final resultJson = jsonDecode(result.body);

      if (resultJson != null && resultJson["course"] != null) {
        // print('hey result');
        Course updatedCourse = Course.parse(resultJson["course"]);
        print("updated: " + updatedCourse.numViews.toString());
        courses = courses
            .map((c) =>
                c.id.compareTo(updatedCourse.id) == 0 ? updatedCourse : c)
            .toList();
      }
    }
    // print('fetched');
  }

  Future courseRespond(String id, Duration beginTime, bool correct) async {
    await _init();
    if (user != null) {
      // print("here to fetch");
      // final response = await _dio.get('/');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': '*/*',
        'Authorization': 'Bearer ${user.token}',
      };

      var uri = Uri.parse(apiHost + courseRespondPath + '/?id=$id');

      var body = {
        "name": user.firstname + " " + user.lastname,
        "correct": correct.toString(),
        "beginTime": beginTime.inSeconds.toString()
      };

      final result = await put(uri, headers: headers, body: jsonEncode(body));
      final resultJson = jsonDecode(result.body);
      print("result: "+ resultJson["course"]["quiz"][0]["responses"].toString());
      if (resultJson != null && resultJson["course"] != null) {
        // print('hey result');
        Course updatedCourse = Course.parse(resultJson["course"]);
        courses = courses
            .map((c) =>
                c.id.compareTo(updatedCourse.id) == 0 ? updatedCourse : c)
            .toList();
      }
    }
  }
}
