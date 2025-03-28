import 'package:easeops_web_hrms/app_export.dart';

Future<TimeOfDay?> customSelectTime({
  required TimeOfDay selectedTime,
  BuildContext? context,
}) async {
  final picked = await showTimePicker(
    context: Get.context!,
    initialTime: selectedTime,
    builder: (context, child) => Theme(
      data: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
      ),
      child: child!,
    ),
  );
  return picked;
}
