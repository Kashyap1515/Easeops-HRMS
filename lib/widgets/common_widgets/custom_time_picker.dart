import 'package:easeops_web_hrms/app_export.dart';

Future<String> customSelectTime({
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
  if (picked != null) {
    selectedTime = picked;
    final time = selectedTime.format(Get.context!);
    return time;
  } else {
    return '';
  }
}

Future<TimeOfDay?> customSelectTime1({
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
