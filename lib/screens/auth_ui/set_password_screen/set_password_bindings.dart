import 'package:easeops_web_hrms/app_export.dart';
import 'package:easeops_web_hrms/screens/auth_ui/set_password_screen/set_password_controller.dart';

class SetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(SetPasswordController.new);
  }
}
