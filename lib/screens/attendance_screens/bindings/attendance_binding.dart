import 'package:easeops_web_hrms/app_export.dart';
import 'package:easeops_web_hrms/screens/attendance_screens/controller/attendance_controller.dart';
import 'package:easeops_web_hrms/screens/attendance_screens/controller/monthly_attendance_controller.dart';

class AttendanceBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(AttendanceScreenController.new);
    Get.lazyPut(MonthlyAttendanceController.new);
  }
}
