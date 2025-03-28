import 'package:easeops_web_hrms/app_export.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    required this.btnText,
    required this.btnPressed,
    super.key,
    this.isLoading = false,
    this.btnColor,
    this.btnTxtColor,
    this.btnHeight,
    this.btnWidth,
    this.borderRadius,
  });

  final String btnText;
  final bool isLoading;
  final Color? btnColor;
  final Color? btnTxtColor;
  final VoidCallback btnPressed;
  final double? btnHeight;
  final double? btnWidth;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: btnHeight ?? 45,
      width: btnWidth,
      child: ElevatedButton(
        onPressed: btnPressed,
        style: ElevatedButton.styleFrom(
          padding: all16,
          backgroundColor: btnColor ?? AppColors.kcPrimaryColor,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(borderRadius != null ? borderRadius! : 4),
          ),
        ),
        child: FittedBox(
          child: isLoading
              ? const CustomProgressIndicator()
              : Text(
                  btnText,
                  style: AppStyles.ktsTabTitle2.apply(
                    color: btnTxtColor ?? AppColors.kcWhiteColor,
                  ),
                ),
        ),
      ),
    );
  }
}
