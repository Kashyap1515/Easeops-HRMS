import 'package:easeops_web_hrms/app_export.dart';
import 'package:easeops_web_hrms/screens/attendance_screens/attendance_screen.dart';
import 'package:easeops_web_hrms/screens/attendance_screens/bindings/attendance_binding.dart';
import 'package:easeops_web_hrms/screens/attendance_screens/screens/user_attendance_view.dart';
import 'package:easeops_web_hrms/screens/shift_pages/bindings/shift_binding.dart';
import 'package:easeops_web_hrms/screens/shift_pages/shift_setting_screen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = '/';

  static final routes = [
    GetPage(
      name: '/',
      page: () => const RootView(),
      binding: RootBinding(),
      participatesInRootNavigator: true,
      children: [
        GetPage(
          name: Paths.loginPath,
          page: () => const LoginPage(),
          transition: Transition.noTransition,
          middlewares: [CheckSavedLogin()],
        ),
        GetPage(
          name: Paths.forgotPwdPath,
          page: () => const ForgotPasswordPage(),
          transition: Transition.noTransition,
        ),
        GetPage(
          name: Paths.setPwdPath,
          page: () => const SetPasswordPage(),
          bindings: [SetPasswordBinding()],
          transition: Transition.noTransition,
        ),
        GetPage(
          name: Paths.usersPath,
          page: () => const ConfigUserScreen(),
          bindings: [ConfigUserBinding()],
          transition: Transition.noTransition,
          middlewares: [AuthGuard()],
        ),
        GetPage(
          name: Paths.rolesPath,
          page: () => const ConfigRoleScreen(),
          bindings: [ConfigRoleBinding()],
          transition: Transition.noTransition,
          middlewares: [AuthGuard()],
        ),
        GetPage(
          name: Paths.locationsPath,
          page: () => const ConfigLocationScreen(),
          bindings: [ConfigLocationBinding()],
          transition: Transition.noTransition,
          middlewares: [AuthGuard()],
        ),
        GetPage(
          name: Paths.shiftPath,
          page: () => const ShiftScreen(),
          bindings: [ShiftBinding()],
          transition: Transition.noTransition,
          middlewares: [AuthGuard()],
        ),
        GetPage(
          name: Paths.attendancePath,
          page: () => const AttendanceScreen(),
          bindings: [AttendanceBindings()],
          transition: Transition.noTransition,
          middlewares: [AuthGuard()],
        ),
        GetPage(
          name: Paths.attendanceDetailPath,
          page: () => const UserAttendanceViewScreen(),
          bindings: [AttendanceBindings()],
          transition: Transition.noTransition,
          middlewares: [AuthGuard()],
        ),
      ],
    ),
  ];
}
