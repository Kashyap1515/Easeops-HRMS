import 'package:easeops_web_hrms/screens/root/controller/root_controller.dart';
import 'package:get/get.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    return Get.lazyPut<RootController>(RootController.new);
  }
}
