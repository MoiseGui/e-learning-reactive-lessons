part of 'services.dart';

// class ClassService extends GetxController {
//   var classID;
//   var className;

//   DialogController _dialogController = Get.put(DialogController());
//   var cookieJar = CookieJar();

//   ClassService({this.classID, this.className});

//   factory ClassService.createClassService(Map<String, dynamic> object) {
//     return ClassService(
//       classID: object['Class_id'],
//       className: object['Classname'],
//     );
//   }

//   createNewClass({var className}) async {
//     var dio = Dio();

//     var formData = {
//       'new_classname': className,
//     };

//     try {
//       // var uri =
//       //     Uri.parse("https://elearning-uin-arraniry.herokuapp.com/classes");

//       cookieJar.loadForRequest(apiLogin);

//       final req = await dio.post(
//         'https://elearning-uin-arraniry.herokuapp.com/classes',
//         data: formData,
//         options: Options(
//           contentType: Headers.formUrlEncodedContentType,
//         ),
//       );

//       var res = jsonDecode(req.data.toString());

//       print(res);
//       print(req.statusCode);
//       // print(req.request);
//       print(req.headers);

//       var statusCode = res['Status'];
//       var message = res['Message'];

//       if (statusCode == 201) {
//         _dialogController.successDialog(
//           "$message successfully",
//           () {
//             // Get.isDialogOpen
//             Get.toNamed("/home");
//           },
//         );
//       } else if (req.statusCode != 200) {
//         Get.snackbar(
//           "Login is failed",
//           "$message",
//           margin: EdgeInsets.only(top: 10, left: 10, right: 10),
//           backgroundColor: errorColor,
//           colorText: bgColor,
//         );
//       }
//     } on DioError catch (error) {
//       if (error.response!.statusCode == 302) {
//         Get.snackbar(
//           "Login is failed",
//           "$error",
//           margin: EdgeInsets.only(top: 10, left: 10, right: 10),
//           backgroundColor: errorColor,
//           colorText: bgColor,
//         );
//       }
//     }
//   }

// static Future<List<ClassService>> classes() async {
//   final result = await http.get(apiClass);
//   List jsonObject = jsonDecode(result.body);

//   print(result);

//   List list = [];
//   for (var i = 0; i < jsonObject.length; i++)
//     list.add(ClassService.createClassService(jsonObject[i]));

//   return list;
// }

// classByID({var id}) {}
// }

class ClassService extends GetConnect {
  Future<Response> createNewClass({
    required var className,
    required var token,
  }) {
    final formBody = FormData({
      'new_classname': className,
    });

    return post(
      apiHost + classPath,
      formBody,
      // headers: {'set-cookie': token.toString()},
    );
  }
}
