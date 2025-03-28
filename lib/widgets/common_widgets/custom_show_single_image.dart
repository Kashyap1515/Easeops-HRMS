import 'package:easeops_web_hrms/app_export.dart';
import 'package:easeops_web_hrms/widgets/common_widgets/custom_show_network_image.dart';
import 'package:universal_html/html.dart' as html;

Future<void> customShowSingleImageDialog({
  required String imageFile,
}) {
  return Get.dialog(
    AlertDialog(
      backgroundColor: AppColors.kcWhiteColor,
      shape: RoundedRectangleBorder(borderRadius: br8),
      contentPadding: all4,
      shadowColor: AppColors.kcWhiteColor,
      elevation: 1,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: br8,
              color: AppColors.kcWhiteColor,
            ),
            constraints: BoxConstraints(
              maxHeight: Get.size.height / 1.3,
              maxWidth: Get.size.width / 2,
            ),
            child: Stack(
              children: [
                CustomShowNetworkImage(
                  imageUrl: imageFile,
                  boxFit: BoxFit.fitHeight,
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: InkWell(
                    onTap: () async {
                      try {
                        final fileName = Uri.parse(imageFile).pathSegments.last;
                        final anchor = html.AnchorElement(href: imageFile)
                          ..setAttribute("download", fileName)
                          ..click();
                        html.Url.revokeObjectUrl(anchor.href!);
                      } catch (e) {
                        customSnackBar(
                            title: 'Error',
                            message: 'An error occurred: $e',
                            alertType: AlertType.alertMessage);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.5),
                      ),
                      child: const Icon(
                        Icons.download,
                        color: Colors.white,
                        size: 24,
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
    barrierDismissible: true,
  );
}
