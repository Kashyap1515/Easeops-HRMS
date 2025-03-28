import 'package:easeops_web_hrms/app_export.dart';

class CustomMenuAnchor extends StatelessWidget {
  const CustomMenuAnchor({
    required this.lstMenu,
    super.key,
    this.alignmentOffset,
  });
  final List<Widget> lstMenu;
  final Offset? alignmentOffset;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
        return IconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const Icon(Icons.more_horiz),
          padding: EdgeInsets.zero,
        );
      },
      menuChildren: lstMenu,
      alignmentOffset: alignmentOffset ?? const Offset(-70, -20),
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.kcWhiteColor),
        shadowColor: WidgetStateProperty.all(AppColors.kcWhiteColor),
        surfaceTintColor: WidgetStateProperty.all(AppColors.kcWhiteColor),
      ),
    );
  }
}

Widget customMenuItemButton({
  required String title,
  required VoidCallback onPressed,
}) {
  return MenuItemButton(
    onPressed: onPressed,
    child: Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    ),
  );
}
