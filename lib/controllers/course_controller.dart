part of 'controllers.dart';

class CourseController extends GetxController {
  final _userController = Get.put(UserController());

  var user;

  late List<Course> courses = [];
  late List<Course> myCourses = [];
  final dio.BaseOptions options = dio.BaseOptions(
    baseUrl: apiHost + coursesPath,
  );

  CourseController() {
    _init();
  }

  Future _init() async {
    user = await AuthService().checkAuth();
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
        Course c = Course.parse(course);
        if(user != null && user.email.compareTo(c.email) == 0){
          myCourses.add(c);
        }
        courses.add(c);
      }
    }
    // print('fetched');
  }

  Future updateCoursesViews(id) async {

    if(user != null){
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
        courses = courses.map((c) => c.id.compareTo(updatedCourse.id) == 0 ? updatedCourse : c).toList();
      }

    }
    // print('fetched');
  }

}
