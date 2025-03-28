import 'package:easeops_web_hrms/app_export.dart';

Future<void> customShowDataDialog({
  required String title,
  required List<dynamic> data,
  double? width,
}) {
  return Get.dialog(
    AlertDialog(
      backgroundColor: AppColors.kcWhiteColor,
      shape: RoundedRectangleBorder(borderRadius: br8),
      contentPadding: EdgeInsets.zero,
      shadowColor: AppColors.kcWhiteColor,
      elevation: 1,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              color: AppColors.kcBorderColor,
            ),
            padding: symetricHV8.copyWith(left: 24, right: 24),
            child: Row(
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
                InkWell(
                  onTap: Get.back,
                  child: const Icon(
                    Icons.close,
                    size: 26,
                    color: AppColors.kcTextLightColor,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: all24,
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    color: AppColors.kcTextLightColor,
                  ),
                  width: width ?? Get.size.width / 4,
                  padding: all10,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 30,
                        child: Text(
                          '#',
                          style: GoogleFonts.inter(
                            color: AppColors.kcWhiteColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          title.split(' ').last,
                          style: GoogleFonts.inter(
                            color: AppColors.kcWhiteColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    color: AppColors.kcWhiteColor,
                    border: Border(
                      left: BorderSide(
                        color: AppColors.kcBorderColor,
                      ),
                      bottom: BorderSide(
                        color: AppColors.kcBorderColor,
                      ),
                      right: BorderSide(
                        color: AppColors.kcBorderColor,
                      ),
                    ),
                  ),
                  width: width ?? Get.size.width / 4,
                  child: SizedBox(
                    height: data.isNotEmpty
                        ? data.length >= 14
                            ? Get.size.height / 1.4
                            : data.length * 41
                        : 0,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          data.length,
                          (index) => Column(
                            children: [
                              Padding(
                                padding: all10,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 30,
                                      child: Text(
                                        '${index + 1}',
                                        style: GoogleFonts.inter(
                                          color: AppColors.kcBlackColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        data[index]?.popupData ?? '',
                                        style: GoogleFonts.inter(
                                          color: AppColors.kcBlackColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (index < (data.length) - 1)
                                const Divider(height: 1, thickness: 1),
                            ],
                          ),
                        ).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    barrierDismissible: false,
  );
}
