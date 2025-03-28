part of 'app_pages.dart';

abstract class AppRoutes {
  AppRoutes._();

  static const routeLogin = Paths.loginPath;
  static const routeForgotPwd = Paths.forgotPwdPath;
  static const routeSetPwd = Paths.setPwdPath;
  static const routeChangePwd = Paths.changePwdPath;
  static const routeUsers = Paths.usersPath;
  static const routeRoles = Paths.rolesPath;
  static const routeLocations = Paths.locationsPath;
  static const routeShift = Paths.shiftPath;
  static const routeAttendance = Paths.attendancePath;
  static const routeAttendanceDetail = Paths.attendanceDetailPath;
}

abstract class Paths {
  static const loginPath = '/login';
  static const forgotPwdPath = '/forgot-password';
  static const setPwdPath = '/set-password';
  static const changePwdPath = '/change-password';
  static const configurationPath = '/configuration';
  static const usersPath = '$configurationPath/users';
  static const rolesPath = '$configurationPath/roles';
  static const locationsPath = '$configurationPath/locations';
  static const shiftPath = '/shift';
  static const attendancePath = '/attendance';
  static const attendanceDetailPath = '/attendance/detail';
}
