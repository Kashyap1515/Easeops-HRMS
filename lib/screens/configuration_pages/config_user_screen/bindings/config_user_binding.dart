import 'package:easeops_web_hrms/app_export.dart';

class ConfigUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(ConfigUserController.new);
  }
}
