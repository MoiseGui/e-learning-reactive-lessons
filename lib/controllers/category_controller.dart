part of 'controllers.dart';

class CategoryController extends GetxController{
  List<Category> categories = [];

  late dio.Dio _dio;
  final dio.BaseOptions options = dio.BaseOptions(
    baseUrl: apiHost + categoriesPath,
  );

  CategoryController() {
    _dio = dio.Dio(options);
  }

  Future loadAllCategories() async {
    // final response = await _dio.get('/');
    final response = await get(apiCategories);
    // print(jsonDecode(response.body));
    final list = jsonDecode(response.body);

    if(list != null){
      categories = [];
      for(var category in list){
        categories.add(Category.parse(category));
      }
    }
  }
}