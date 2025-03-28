import 'package:easeops_web_hrms/utils/flavor_config.dart';

class AppStrings {
  static String appName = FlavorConfig.instance.values.appName;
  Flavor environment =
      FlavorConfig.isProduction() ? Flavor.production : Flavor.staging;
  static const String appSlogan = 'AI-Powered Automation';
  static String copyrightFooter =
      '${FlavorConfig.isProduction() ? '' : 'Staging_'}EaseOps HRMS 2025. All Rights Reserved';
  static const String textInfo = 'Info';
  static const String btnClose = 'Close';
  static const String textSuccess = 'Success';
  static const String textError = 'Error';
  static const String textErrorMessage =
      'Something went wrong. Please try again later..!!';
  static const String textErrorDeleteMessage =
      'Sorry it cannot be deleted. Try Again!';
}

enum AlertType { success, error, alertMessage, alertError }

enum ConfigurationTypes {
  users,
  roles,
  locations,
}

final List<String> privilegesListLocal = [
  'Superuser',
  'Write',
  'Assess',
  'Read',
];
