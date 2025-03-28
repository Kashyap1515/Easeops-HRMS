import 'package:easeops_web_hrms/app_export.dart';
import 'package:easeops_web_hrms/screens/auth_ui/models/login_model.dart';
import 'package:easeops_web_hrms/screens/auth_ui/models/my_profile_model.dart';
import 'package:get_storage/get_storage.dart';

class AppPreferences {
  static Future<bool> init() async => GetStorage.init();

  // Preference Constants
  static const String keySelectedItem = 'keySelectedItem';
  static const String keySelectedLocation = 'keySelectedLocation';
  static const String keyUserData = 'keyUserData';
  static const String keyUserProfileData = 'keyUserProfileData';

  static String getSelectedItem() {
    return GetStorage().read(keySelectedItem) ??
        CurrentRoutesName.usersPageDisplayName;
  }

  static Future<void> setSelectedItem(String value) {
    return GetStorage().write(keySelectedItem, value);
  }

  static Future<void> setUserData(String value) {
    return GetStorage().write(keyUserData, value);
  }

  static LoginModel? getUserData() {
    final userData = GetStorage().read(keyUserData);
    if (userData != null) {
      return LoginModel.fromJson(json.decode(userData));
    } else {
      return null;
    }
  }

  static Future<void> setUserProfileData(String value) {
    return GetStorage().write(keyUserProfileData, value);
  }

  static MyProfileDataModel? getUserProfileData() {
    final userProfileData = GetStorage().read(keyUserProfileData);
    if (userProfileData != null) {
      return MyProfileDataModel.fromJson(json.decode(userProfileData));
    } else {
      return null;
    }
  }

  static Future<void> removeAllData() {
    return GetStorage().erase();
  }

  static String? getSelectedLocationId() {
    return GetStorage().read(keySelectedLocation);
  }

  static Future<void> setSelectedLocationId(String value) {
    return GetStorage().write(keySelectedLocation, value);
  }
}
