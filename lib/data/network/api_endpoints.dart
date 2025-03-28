import 'package:easeops_web_hrms/utils/flavor_config.dart';

class ApiEndPoints {
  static String baseApi = FlavorConfig.instance.values.baseUrl;

  static const String middleUrl = 'api/v1';
  static const String apiLogin = '$middleUrl/creds/login';
  static const String apiSettings = '$middleUrl/settings';
  static const String apiMyProfile = '$middleUrl/users/my-profile';
  static const String apiUser = '$middleUrl/users';
  static const String apiRole = '$middleUrl/roles';
  static const String apiPwd = '$middleUrl/passwords';
  static const String apiPwdChange = '$middleUrl/passwords/change';
  static const String apiPwdReset = '$middleUrl/passwords/reset';
  static const String apiPwdResetLink =
      '$middleUrl/passwords/generate-reset-link';
  static const String apiResetByAdmin = '$middleUrl/passwords/reset-by-admin';
  static const String apiLocation = '$middleUrl/locations';
  static const String apiLocSearch = '$middleUrl/locations/search';
  static const String apiShiftData = '$middleUrl/attendance-management/shifts';
  static const String apiDepartment = '$middleUrl/departments';
  static const String apiAttendanceUserData =
      '$middleUrl/attendance-management/reports/users';
  static const String apiActiveDaysReport =
      '$middleUrl/attendance-management/reports/active-days';
  static const String apiAttendanceReportSummary =
      '$middleUrl/attendance-management/reports/summary';
  static const String apiAttendanceData =
      '$middleUrl/attendance-management/attendances';
  static const String apiAttendanceSessions =
      '$middleUrl/attendance-management/sessions';
  static const String apiGetImageUploadUrl = '$middleUrl/images';
}
