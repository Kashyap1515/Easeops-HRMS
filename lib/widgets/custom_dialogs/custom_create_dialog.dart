import 'package:easeops_web_hrms/app_export.dart';

Future<void> customAddDialog({
  required String title,
  required Widget items,
  List<Widget>? buttons,
  MainAxisAlignment? actionsAlignment,
  EdgeInsets? padding,
  String? btnTitle,
  String? btnTitle1,
  String? btnTitle2,
  Color? btnTitle1Color,
  VoidCallback? onBtnCallback,
  VoidCallback? onBtnCallback1,
  VoidCallback? onBtnCallback2,
  VoidCallback? onBtnClose,
  bool isCloseIcon = false,
}) {
  return Get.dialog(
    Obx(
      () => AlertDialog(
        backgroundColor: AppColors.kcWhiteColor,
        shape: RoundedRectangleBorder(borderRadius: br8),
        contentPadding: EdgeInsets.zero,
        shadowColor: AppColors.kcWhiteColor,
        elevation: 1.0.obs.value,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != '')
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  color: AppColors.kcAccentColor100,
                ),
                padding: symetricHV8.copyWith(left: 24, right: 24),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.inter(
                          color: AppColors.kcBlackColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (isCloseIcon)
                      InkWell(
                        onTap: onBtnClose ?? Get.back,
                        child: const Icon(
                          Icons.close,
                          size: 26,
                          color: AppColors.kcTextLightColor,
                        ),
                      ),
                  ],
                ),
              ),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: padding ?? all24,
                        child: items,
                      ),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.kcBorderColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actionsPadding: all10,
        actionsAlignment: actionsAlignment,
        actions: buttons ??
            [
              if (btnTitle != null)
                CustomElevatedButton(
                  btnHeight: btnHeight,
                  btnColor: AppColors.kcDrawerColor,
                  btnText: btnTitle,
                  btnTxtColor: AppColors.kcHeaderButtonColor,
                  btnPressed: onBtnCallback!,
                  borderRadius: btnBorderRadius,
                ),
              if (btnTitle2 != null)
                CustomElevatedButton(
                  btnHeight: btnHeight,
                  btnColor: AppColors.kcDrawerColor,
                  btnText: btnTitle2,
                  btnTxtColor: AppColors.kcHeaderButtonColor,
                  btnPressed: onBtnCallback2!,
                  borderRadius: btnBorderRadius,
                ),
              if (btnTitle1 != null)
                CustomElevatedButton(
                  btnHeight: btnHeight,
                  btnColor: btnTitle1Color ?? AppColors.kcHeaderButtonColor,
                  btnText: btnTitle1,
                  btnPressed: onBtnCallback1!,
                  borderRadius: btnBorderRadius,
                ),
            ],
      ),
    ),
    barrierDismissible: false,
  );
}

Future<void> customShowDialog({
  required String title,
  required Widget items,
  VoidCallback? onBtnClose,
  bool isCloseIcon = false,
}) {
  return Get.dialog(
    Obx(
      () => AlertDialog(
        backgroundColor: AppColors.kcWhiteColor,
        shape: RoundedRectangleBorder(borderRadius: br8),
        contentPadding: EdgeInsets.zero,
        shadowColor: AppColors.kcWhiteColor,
        elevation: 1.0.obs.value,
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: Get.size.height * 0.8,
            maxWidth: Get.size.width / 1.2,
            minWidth: Get.size.width / 1.5,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != '')
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    color: AppColors.kcAccentColor100,
                  ),
                  padding: symetricHV8.copyWith(left: 24, right: 24),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.inter(
                            color: AppColors.kcBlackColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (isCloseIcon)
                        InkWell(
                          onTap: onBtnClose ?? Get.back,
                          child: const Icon(
                            Icons.close,
                            size: 26,
                            color: AppColors.kcTextLightColor,
                          ),
                        ),
                    ],
                  ),
                ),
              Flexible(
                child: Padding(
                  padding: all24,
                  child: SingleChildScrollView(
                    child: items,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    barrierDismissible: false,
  );
}

Widget deleteDialogItem({
  required String title,
  required String subTitle,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 30),
    child: Column(
      children: [
        const Icon(
          Icons.delete_outline_rounded,
          size: 24,
          color: AppColors.kcIconColor,
        ),
        sbh10,
        Text(
          'You are about to delete “$title” $subTitle.',
          style: GoogleFonts.inter(
            color: AppColors.kcBlackColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        sbh10,
        Text(
          'Once you delete you never get back $subTitle data. Are you still want to delete?',
          style: GoogleFonts.inter(
            color: AppColors.kcBlackColor,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    ),
  );
}
