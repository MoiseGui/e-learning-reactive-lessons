part of 'routes.dart';

abstract class RouteName {
  static const home = "/";
  static const login = "/login";
  static const register = "/register";
  static const dashboard = "/dashboard";
}

class RoutePage {
  static final pages = [
    GetPage(
      name: RouteName.home,
      page: () => const HomePage(title: 'E-learning'),
    ),
    GetPage(
      name: RouteName.login,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: RouteName.register,
      page: () => RegisterPage(),
    ),
    GetPage(
        name: RouteName.dashboard,
        page: () => const Dashboard()
    ),
  ];
}
