import 'package:easeops_web_hrms/app_export.dart';
import 'package:easeops_web_hrms/screens/shift_pages/controller/shift_controller.dart';

class ShiftBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(ShiftController.new);
  }
}
