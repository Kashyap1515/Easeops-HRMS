import 'package:easeops_web_hrms/app_export.dart';
import 'package:easeops_web_hrms/screens/configuration_pages/config_location_screen/controller/config_location_controller.dart';

class ConfigLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(ConfigLocationController.new);
  }
}
