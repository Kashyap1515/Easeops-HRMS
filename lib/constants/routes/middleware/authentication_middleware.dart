import 'package:easeops_web_hrms/app_export.dart';

class AuthGuard extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    if (AppPreferences.getUserData() == null) {
      return const RouteSettings(name: AppRoutes.routeLogin);
    } else {}
    return null;
  }
}

class CheckSavedLogin extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    if (AppPreferences.getUserData() != null) {
      AppPreferences.setSelectedItem(CurrentRoutesName.usersPageDisplayName);
      return const RouteSettings(name: AppRoutes.routeUsers);
    } else {}
    return null;
  }
}
