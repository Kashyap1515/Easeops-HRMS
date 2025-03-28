import 'package:easeops_web_hrms/app_export.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: color ?? AppColors.kcWhiteColor,
      ),
    );
  }
}
