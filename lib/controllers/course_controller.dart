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
      myCourses = [];
      for (var course in list) {
        Course c = Course.parse(course);
        if (user != null && user.email == c.email) {
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
        // print("updated: " + updatedCourse.numViews.toString());
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
      // print("result: "+ resultJson["course"]["quiz"][0]["responses"].toString());
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

  Future addCourse(Course course, File imageFile, File videoFile, callback) async{
    await _init();

    if(user != null){
      // local test
      // var uri = Uri.parse(localhost+"/api/images/upload");

      // local save
      // var uri = Uri.parse(localhost+coursesPath);

      // production
      var uri = apiCourses;

      // create multipart request
      var request = http.MultipartRequest("POST", uri);

      Map<String, String> headers = {
        'enctype' : 'multipart/form-data',
        'Content-type': 'application/json',
        'Accept': '*/*',
        'Authorization': 'Bearer ${user.token}',
      };

      Map<String, String> fields = {
        "email": user.email,
        "title": course.title,
        "description": course.description,
        "paragraphs": jsonEncode(course.paragraphs),
        "categoryId": course.categoryId,
        "quiz": jsonEncode(course.quiz)
      };

      request.headers.addAll(headers);
      // print(headers);
      request.fields.addAll(fields);

      // image Multipart
      var imageM = await getFileMultipart(imageFile, "images");

      // video Multipart
      var videoM = await getFileMultipart(videoFile, "videos");

      // add file to multipart
      request.files.add(imageM);
      request.files.add(videoM);

      // send
      try{
        var response = await request.send();
        // print("HAHO "+response.statusCode.toString());

        // listen for response
        response.stream.transform(utf8.decoder).listen((value) {
          var result = jsonDecode(value);
          if(response.statusCode == 201){
            Get.close(0);
            DialogController()
                .successDialog("Cours ajouté avec succès", () {
              Get.close(2);
            });
          }
          else{
            var message = result != null
                ? result['message']
                : "une erreur inantandue s'est produite. Vérifiez votre connexion.";
            handleCourseAddError(message, callback);
          }
          // print("RESULT "+result);
        }, onError: (error){
          var message = "une erreur inantandue s'est produite. Vérifiez votre connexion.";
          handleCourseAddError(message, callback);
        });
      }
      catch(e){
        var message = "une erreur inantandue s'est produite. Vérifiez votre connexion.";
        handleCourseAddError(message, callback);
      }
    }

  }

  Future<http.MultipartFile> getFileMultipart(File file, String propName) async {
    // open a bytestream
    var stream = http.ByteStream(file.openRead());
    stream.cast();
    // get file length
    var length = await file.length();

    // multipart that takes file
    var multipartFile = http.MultipartFile(propName, stream, length,
        filename: basename(file.path));

    return multipartFile;
  }

  handleCourseAddError(String message, callback){
    callback();
    Get.snackbar(
      "Connexion échouée.",
      message,
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      backgroundColor: errorColor,
      colorText: whiteColor,
      duration: const Duration(seconds: 4),
    );
  }
}
