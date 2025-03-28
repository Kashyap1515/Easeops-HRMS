import 'package:easeops_web_hrms/app_export.dart';

class SetPasswordController extends GetxController {
  final form = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final passwordController = TextEditingController();
  RxBool isVisibleForPassword = false.obs;
  RxBool isVisibleForNewPassword = false.obs;
  RxString tokenAuth = ''.obs;
  final NetworkApiService _apiService = NetworkApiService();
  RxBool allOKToNavigateLogin = false.obs;
  RxBool isSetPasswordLoading = false.obs;

  Future<void> saveForm(BuildContext context) async {
    final isValid = form.currentState!.validate();
    if (!isValid) {
      return;
    }
    form.currentState!.save();
    if (tokenAuth.value == '') {
      customSnackBar(
        title: AppStrings.textError,
        message: 'Not Authenticated User',
        alertType: AlertType.alertError,
      );
      return;
    }
    final setPasswordMapBody = <String, dynamic>{
      'password': newPasswordController.text,
      'token': tokenAuth.value,
    };
    isSetPasswordLoading.value = true;
    try {
      final result = await _apiService.postResponse(
        endpoint: ApiEndPoints.apiPwdReset,
        postBody: setPasswordMapBody,
        token: '',
        isReturnBool: true,
      );
      if (result) {
        customSnackBar(
          title: AppStrings.textSuccess,
          message: 'Password set successfully',
          alertType: AlertType.alertMessage,
        );
        await AppPreferences.removeAllData();
        await Get.offAllNamed<void>(AppRoutes.routeLogin);
      }
      isSetPasswordLoading.value = false;
    } catch (e) {
      customSnackBar(
        title: AppStrings.textError,
        message: e.toString(),
        alertType: AlertType.alertError,
      );
    }
    isSetPasswordLoading.value = false;
  }
}
