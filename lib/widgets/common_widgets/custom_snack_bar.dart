import 'package:easeops_web_hrms/app_export.dart';

void customSnackBar({
  required String title,
  required String message,
  required AlertType alertType,
}) {
  Get.snackbar(
    '',
    '',
    titleText: Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.kcWhiteColor,
      ),
    ),
    messageText: Text(
      message,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.kcWhiteColor,
      ),
    ),
    maxWidth: Get.size.width / 2.5,
    snackPosition: SnackPosition.TOP,
    duration: const Duration(seconds: 2),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    margin: const EdgeInsets.only(top: 20),
    borderRadius: 8,
    backgroundColor: alertType == AlertType.success
        ? AppColors.kcSuccessColor.withOpacity(0.9)
        : alertType == AlertType.error
            ? AppColors.kcFailedColor.withOpacity(0.9)
            : alertType == AlertType.alertError
                ? AppColors.kcAlertErrorColor.withOpacity(0.9)
                : AppColors.kcSuccessColor,
  );
}
