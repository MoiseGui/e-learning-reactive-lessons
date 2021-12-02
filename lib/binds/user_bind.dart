part of 'binds.dart';

class UserBind extends Bindings {
  @override
  void dependencies() {
    Get.put(UserController());
  }

}