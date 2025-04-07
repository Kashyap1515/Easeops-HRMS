import 'package:intl/intl.dart';

String formatDateToddMMyyyy(DateTime? date) {
  if (date == null) {
    return '-';
  } else {
    return DateFormat("dd/MM/yyyy").format(date);
  }
}

String formatDateToDDashMMDashY(DateTime? date) {
  if (date == null) {
    return '-';
  } else {
    return DateFormat("dd-MM-yyyy").format(date);
  }
}

String formatDateToDDashMMDashYHM(DateTime? date) {
  if (date == null) {
    return '-';
  } else {
    return DateFormat("dd-MM-yyyy HH:mm").format(date);
  }
}

String formatDateToDDashMMDashYHMA(DateTime? date) {
  if (date == null) {
    return '';
  } else {
    return DateFormat("dd-MM-yyyy hh:mm a").format(date);
  }
}

String formatDateToYDashMMDashD(DateTime? date) {
  if (date == null) {
    return '-';
  } else {
    return DateFormat("yyyy-MM-dd").format(date);
  }
}

String formatDateToDMMMMY(DateTime? date) {
  if (date == null) {
    return '-';
  } else {
    return DateFormat("dd, MMMM yyyy").format(date);
  }
}

String formatDateToMMMMY(DateTime? date) {
  if (date == null) {
    return '-';
  } else {
    return DateFormat("MMMM yyyy").format(date);
  }
}

String formatDateToMMMM(DateTime? date) {
  if (date == null) {
    return '-';
  } else {
    return DateFormat("MMMM").format(date);
  }
}

String formatDateToDMMMM(DateTime? date) {
  if (date == null) {
    return '-';
  } else {
    return DateFormat("dd, MMMM").format(date).toString();
  }
}

String formatDateToDMMMY(DateTime? date) {
  if (date == null) {
    return '-';
  } else {
    return DateFormat("dd MMM, yyyy").format(date).toString();
  }
}

String formatDateToDMMM(DateTime? date) {
  if (date == null) {
    return '-';
  } else {
    return DateFormat("dd MMM").format(date).toString();
  }
}

String formatDateTodMMMyyyy(DateTime dateTime) {
  return DateFormat('d MMM yyyy').format(
    DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime.toString()),
  );
}

String formatDateToHHMMAP(DateTime? date) {
  if (date == null) {
    return '';
  } else {
    return DateFormat("hh:mm a").format(date);
  }
}

String convertTo12HourFormat(String time24) {
  DateFormat inputFormat = DateFormat("HH:mm:ss");
  DateTime dateTime = inputFormat.parse(time24);

  DateFormat outputFormat = DateFormat("hh:mm a");
  return outputFormat.format(dateTime);
}

String formatMinutesToHours(int totalMinutes) {
  int hours = totalMinutes ~/ 60;
  int minutes = totalMinutes % 60;

  String formattedTime =
      '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')} Hrs';

  return formattedTime.toString();
}

String formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes % 60 == 0 || duration.inMinutes % 60 == 59
      ? duration.inMinutes % 60
      : (duration.inMinutes % 60);
  final formattedDifference =
      '${hours != 0 ? '$hours hour' : ''}${minutes != 0 ? '$minutes minute' : ''}';
  return formattedDifference;
}
