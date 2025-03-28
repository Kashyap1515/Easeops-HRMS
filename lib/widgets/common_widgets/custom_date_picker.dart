import 'package:easeops_web_hrms/app_export.dart';

Future<String> customSelectDate({
  DateTime? startDate,
  DateTime? lastDate,
  required DateTime selectedDate,
  BuildContext? context,
}) async {
  final picked = await showDatePicker(
    builder: (context, child) => Theme(
      data: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple,
        ),
      ),
      child: child!,
    ),
    context: Get.context!,
    initialDate: selectedDate,
    firstDate: startDate ?? DateTime.now(),
    lastDate: lastDate ?? DateTime.now().add(const Duration(days: 365 * 10)),
  );
  if (picked != null) {
    selectedDate = picked;
    final date = formatDateToddMMyyyy(selectedDate);
    return date;
  } else {
    return '';
  }
}

Future<DateTime?> customSelectDate1({
  DateTime? startDate,
  DateTime? lastDate,
  required DateTime selectedDate,
  BuildContext? context,
}) async {
  final picked = await showDatePicker(
    builder: (context, child) => Theme(
      data: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple,
        ),
      ),
      child: child!,
    ),
    context: Get.context!,
    initialDate: selectedDate,
    firstDate: startDate ?? DateTime.now(),
    lastDate: lastDate ?? DateTime.now().add(const Duration(days: 365 * 10)),
  );
  return picked;
}
