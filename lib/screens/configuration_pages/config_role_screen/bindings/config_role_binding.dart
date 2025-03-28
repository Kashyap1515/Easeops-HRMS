import 'package:easeops_web_hrms/app_export.dart';
import 'package:easeops_web_hrms/screens/configuration_pages/config_role_screen/controller/config_role_controller.dart';

class ConfigRoleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(ConfigRoleController.new);
  }
}
