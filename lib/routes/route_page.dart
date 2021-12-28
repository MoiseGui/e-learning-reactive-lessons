part of 'routes.dart';

abstract class RouteName {
  static const login = "/";
  static const loginPage = "/login";
  static const register = "/register";
  static const home = "/home";
  static const dashboard = "/dashboard";
  static const courses = "/my-courses";
}

class RoutePage {
  static final pages = [
    GetPage(
      name: RouteName.login,
      page: () => LoginPage(load: true),
    ),
    GetPage(
      name: RouteName.loginPage,
      page: () => LoginPage(load: false),
    ),
    GetPage(
      name: RouteName.register,
      page: () => RegisterPage(),
    ),
    GetPage(
      name: RouteName.home,
      page: () => const HomePage(),
    ),
    GetPage(
        name: RouteName.dashboard,
        page: () => const Dashboard()
    ),
    GetPage(
        name: RouteName.courses,
        page: () => const CoursesPage()
    ),
  ];
}
