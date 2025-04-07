import 'package:easeops_web_hrms/app_export.dart';
import 'package:easeops_web_hrms/screens/attendance_screens/model/active_days_model.dart';
import 'package:easeops_web_hrms/screens/attendance_screens/model/attendance_report_user.dart';
import 'package:easeops_web_hrms/utils/generate_excel.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class Event {
  final String title;
  final String locationName;

  Event(this.title, this.locationName);
}

class MonthlyAttendanceController extends GetxController {
  final NetworkApiService apiService = NetworkApiService();
  RxBool isActiveDaysLoading = true.obs;
  RxBool isWeekDayLoading = true.obs;
  RxBool isListView = true.obs;
  Rx<DateTime> startDateTime = DateTime.now().obs;
  Rx<DateTime> endDateTime = DateTime.now().obs;
  RxList<AttendanceReportUserModel> attendanceDailyModel =
      <AttendanceReportUserModel>[].obs;
  List<AttendanceReportUserModel> attendanceMonthlyModel =
      <AttendanceReportUserModel>[];
  List<AttendanceReportUserModel> allAttendanceMonthlyModel =
      <AttendanceReportUserModel>[];
  // List<LocationListModel> locListData = [];
  Rx<DateTime> startDailyDateTime = DateTime.now().obs;
  Rx<DateTime> endDailyDateTime = DateTime.now().obs;
  RxList<Map<String, dynamic>> userListData = <Map<String, dynamic>>[].obs;
  RxString currUserId = ''.obs;
  RxString currUserName = ''.obs;
  RxString currLocationId = ''.obs;
  RxList<String> locationIds = <String>[].obs;
  RxString userLocalTimeZone = 'Asia/Kolkata'.obs;
  RxMap<DateTime, List<Event>> events = <DateTime, List<Event>>{}.obs;
  Map<String, List<AttendanceReportUserModel>> locationAttendanceData = {};

  static DateTime normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  Future<void> setTimeZone() async {
    tzdata.initializeTimeZones();
    await getLocalTimezone();
  }

  void addEvent(DateTime date, Event event) {
    DateTime normalizedDate = normalizeDate(date);
    if (events.containsKey(normalizedDate)) {
      events[normalizedDate]?.add(event);
    } else {
      events[normalizedDate] = [event];
    }
    events.refresh();
  }

  Future<void> getAttendanceUserAPIData() async {
    String dateString = formatDateToYDashMMDashD(startDateTime.value);
    // var locationId = locationIds.join(',');
    await apiService
        .getResponse(
      endpoint:
          '${ApiEndPoints.apiAttendanceUserData}?utc_from_dt=$dateString 00:00:00&utc_till_dt=$dateString 23:59:59',
      token: AppPreferences.getUserData()!.token,
    )
        .then(
      (value) {
        if (value != null) {
          userListData.clear();
          final data = attendanceReportUserModelFromJson(jsonEncode(value));
          for (var index = 0; index < value.length; index++) {
            userListData.add(
                {'id': data[index].user!.id, 'label': data[index].user!.name});
          }
          isListView.value = false;
        } else {
          isListView.value = false;
          customSnackBar(
            title: AppStrings.textError,
            message: AppStrings.textErrorMessage,
            alertType: AlertType.alertError,
          );
        }
      },
    ).catchError(
      (err) {
        customSnackBar(
          title: AppStrings.textError,
          message: AppStrings.textErrorMessage,
          alertType: AlertType.alertError,
        );
      },
    );
  }

  Future<void> getActiveDaysData() async {
    isActiveDaysLoading.value = true;
    await apiService
        .getResponse(
      endpoint:
          '${ApiEndPoints.apiActiveDaysReport}?utc_from_dt=${startDateTime.value}&utc_till_dt=${endDateTime.value}&user_id=${currUserId.value}',
      token: AppPreferences.getUserData()!.token,
    )
        .then((value) async {
      if (value != null) {
        var activeDayData = attendanceActiveDayModelFromJson(jsonEncode(value));
        getMonthlyAttendanceData();
        events.clear();
        if (activeDayData.isNotEmpty) {
          activeDayData = activeDayData.toSet().toList();
          events.clear();
          final newEventsMap = <DateTime, List<Event>>{};

          for (var data in activeDayData) {
            DateTime normalizedDate =
                normalizeDate(DateTime.parse(data['marked_at']));
            String locationName = data['location']['name'] ?? '';

            Event newEvent = Event('Present', locationName);

            if (newEventsMap[normalizedDate] == null) {
              newEventsMap[normalizedDate] = [];
            }
            newEventsMap[normalizedDate]!.add(newEvent);
          }
          events.assignAll(newEventsMap);
          update();
        }
        isActiveDaysLoading.value = false;
      } else {
        isActiveDaysLoading.value = false;
      }
    });
  }

  Future<void> getMonthlyAttendanceData() async {
    // var locationId = locationIds.join(',');
    await apiService
        .getResponse(
      endpoint:
          '${ApiEndPoints.apiAttendanceUserData}?utc_from_dt=${formatDateToYDashMMDashD(startDateTime.value)} 00:00:00.000&utc_till_dt=${formatDateToYDashMMDashD(endDateTime.value)} 23:59:59.000&user_id=${currUserId.value}',
      token: AppPreferences.getUserData()!.token,
    )
        .then((value) async {
      if (value != null) {
        attendanceMonthlyModel.clear();
        for (var i = 0; i < value.length; i++) {
          attendanceMonthlyModel
              .add(AttendanceReportUserModel.fromJson(value[i]));
        }
      }
    });
  }

  Future<void> getDailyAttendanceData() async {
    var locationId = locationIds.join(',');
    isWeekDayLoading.value = true;
    await apiService
        .getResponse(
      endpoint:
          '${ApiEndPoints.apiAttendanceUserData}?utc_from_dt=${formatDateToYDashMMDashD(startDailyDateTime.value)} 00:00:00.000&utc_till_dt=${formatDateToYDashMMDashD(endDailyDateTime.value)} 23:59:59.000&user_id=${currUserId.value}&location_id_list=$locationId',
      token: AppPreferences.getUserData()!.token,
    )
        .then((value) async {
      if (value != null) {
        attendanceDailyModel.clear();
        for (var i = 0; i < value.length; i++) {
          attendanceDailyModel
              .add(AttendanceReportUserModel.fromJson(value[i]));
        }
        // var activeDayData = attendanceDailyModelFromJson(jsonEncode(value));
        // activeDayData.sort((a, b) {
        //   DateTime dateA =
        //       DateTime.parse('${a.checkinDate} ${a.checkinTime ?? '00:00:00'}');
        //   DateTime dateB =
        //       DateTime.parse('${b.checkinDate} ${b.checkinTime ?? '00:00:00'}');
        //   return dateB.compareTo(dateA);
        // });
        isWeekDayLoading.value = false;
      } else {
        isWeekDayLoading.value = false;
      }
    });
  }

  //Generate Monthly/Weekly Excel file
  Future<void> generateAttendanceExcel(String? timePeriod,
      {required DateTime startDate, required DateTime endDate}) async {
    if (attendanceMonthlyModel.isEmpty) {
      customSnackBar(
        title: AppStrings.textInfo,
        message: 'There is no data to export',
        alertType: AlertType.alertMessage,
      );
      return;
    }

    List<xlsio.ExcelDataRow> excelDataRows = [];

    for (int index = 0; index < attendanceMonthlyModel.length; index++) {
      for (DateTime date = startDate;
          date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
          date = date.add(const Duration(days: 1))) {
        List<String> lstInTime = [];
        List<String> lstOutTime = [];
        // String delay = '-';
        String shiftTime = '-';
        String totalTime = '-';

        var attendanceItem =
            attendanceMonthlyModel[index].attendanceList?.firstWhere(
                  (item) =>
                      item.markedAt?.toLocal().day == date.day &&
                      item.markedAt?.toLocal().month == date.month &&
                      item.markedAt?.toLocal().year == date.year,
                  orElse: () => AttendanceList(),
                );

        if (attendanceItem != null && attendanceItem.markedAt != null) {
          bool isFirstCheckin = true;
          if (attendanceItem.sessionList?.isNotEmpty ?? false) {
            for (var session in attendanceItem.sessionList!) {
              String inTime = session.checkinAt != null
                  ? formatDateToHHMMAP(
                      convertDateTimeLocalTimeZone(session.checkinAt!))
                  : '-';

              String outTime = session.checkoutAt != null
                  ? formatDateToHHMMAP(
                      convertDateTimeLocalTimeZone(session.checkoutAt!))
                  : '-';

              lstInTime.add(inTime);
              lstOutTime.add(outTime);

              if (session.shift != null) {
                shiftTime =
                    '${formatTime(session.shift!.startTime!)} - ${formatTime(session.shift!.endTime!)}';
              }

              if (isFirstCheckin &&
                  session.shift != null &&
                  session.checkinAt != null) {
                DateTime shiftStart = parseTime(session.shift!.startTime!);
                DateTime checkin =
                    convertDateTimeLocalTimeZone(session.checkinAt!);

                shiftStart = DateTime(
                  checkin.year,
                  checkin.month,
                  checkin.day,
                  shiftStart.hour,
                  shiftStart.minute,
                  shiftStart.second,
                );

                // Duration checkinDelay = checkin.difference(shiftStart);
                // delay = formatDurationAtten(checkinDelay);
                isFirstCheckin = false;
              }
            }

            totalTime = attendanceItem.totalTimeSpentInMinutes != null
                ? formatMinutesToHours(attendanceItem.totalTimeSpentInMinutes!)
                : '-';
          }
        }

        excelDataRows.add(
          xlsio.ExcelDataRow(
            cells: [
              xlsio.ExcelDataCell(
                  columnHeader: 'Date', value: formatDateToDMMMY(date)),
              xlsio.ExcelDataCell(
                  columnHeader: 'Check-In',
                  value: lstInTime.isNotEmpty ? lstInTime.join('\n') : '-'),
              xlsio.ExcelDataCell(
                  columnHeader: 'Check-Out',
                  value: lstOutTime.isNotEmpty ? lstOutTime.join('\n') : '-'),
              xlsio.ExcelDataCell(
                  columnHeader: 'Shift',
                  value: shiftTime.isNotEmpty ? shiftTime : '-'),
              xlsio.ExcelDataCell(columnHeader: 'Total Time', value: totalTime),
              // xlsio.ExcelDataCell(
              //     columnHeader: 'Delay', value: delay.isNotEmpty ? delay : '-'),
            ],
          ),
        );
      }
    }

    String fileName = '';
    if (timePeriod == 'Monthly') {
      fileName =
          "${removeSubstringInParentheses(currUserName.value)}_${formatDateToMMMM(startDateTime.value)}_Attendance.xlsx";
    } else {
      fileName =
          "${removeSubstringInParentheses(currUserName.value)}_${formatDateToDMMM(startDailyDateTime.value)}-${formatDateToDMMM(endDailyDateTime.value)}_Attendance.xlsx";
    }
    await generateExcel(fileName: fileName, dataRows: excelDataRows);
  }

  DateTime parseTime(String time) {
    List<String> parts = time.split(':');
    return DateTime(
        0, 1, 1, int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
  }

  String formatDurationAtten(Duration duration) {
    if (duration.inMinutes == 0) return 'On Time';
    final hours = duration.inHours;
    final minutes = duration.inMinutes.abs() % 60;
    final sign = duration.isNegative ? '-' : '+';
    return '$sign${hours.abs()}h ${minutes}m';
  }

  String formatTime(String time) {
    DateTime parsedTime = parseTime(time);
    return formatDateToHHMMAP(parsedTime);
  }

  String calculateDifference({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    Duration difference = endDate.difference(startDate);
    String formattedDifference = formatDuration(difference);
    return formattedDifference;
  }

  Widget dataBodyCalenderView() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kcWhiteColor,
        borderRadius: br8,
        border: Border.all(color: AppColors.kcBorderColor),
      ),
      width: Get.size.width,
      margin: all24.copyWith(top: 10, bottom: 16),
      padding: all10,
      child: Obx(() {
        return TableCalendar<Event>(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: startDateTime.value,
          eventLoader: (day) {
            return events[normalizeDate(day)] ?? [];
          },
          calendarStyle: CalendarStyle(
            cellMargin: symetricH10 * 2,
            markersMaxCount: 1,
            markerDecoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            isTodayHighlighted: true,
            cellAlignment: Alignment.center,
            selectedDecoration: const BoxDecoration(
              shape: BoxShape.rectangle,
            ),
            todayTextStyle: const TextStyle(
              color: AppColors.kcPrimaryColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            todayDecoration: const BoxDecoration(
              shape: BoxShape.rectangle,
            ),
            defaultDecoration: const BoxDecoration(
              shape: BoxShape.rectangle,
            ),
            weekendDecoration: const BoxDecoration(
              shape: BoxShape.rectangle,
            ),
            canMarkersOverflow: false,
          ),
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              final events = this.events[normalizeDate(day)] ?? [];
              return _buildEventsMarker(day, events);
            },
          ),
          onPageChanged: (focusedDay) async {
            startDateTime.value =
                DateTime(focusedDay.year, focusedDay.month, 1);
            endDateTime.value =
                DateTime(focusedDay.year, focusedDay.month + 1, 1)
                    .subtract(const Duration(seconds: 1));
            await getActiveDaysData();
          },
        );
      }),
    );
  }

  Widget _buildEventsMarker(DateTime date, List<Event> events) {
    var today = DateTime.now();
    var isToday = date.day == today.day &&
        date.month == today.month &&
        date.year == today.year;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          decoration: isToday
              ? const BoxDecoration(
                  color: AppColors.kcPrimaryColor,
                  shape: BoxShape.circle,
                )
              : null,
          padding: isToday ? all10 : null,
          child: Text(
            date.day.toString(),
            style: TextStyle(
              fontSize: isToday ? 12 : 16,
              fontWeight: isToday ? FontWeight.w500 : null,
              color: isToday ? AppColors.kcWhiteColor : null,
            ),
          ),
        ),
        if (events.isNotEmpty)
          Tooltip(
            message: events.first.locationName,
            child: Text(
              events.first.title,
              style: TextStyle(
                fontSize: 12,
                color: events.first.title.toLowerCase() == "present"
                    ? AppColors.kcPrimaryColor
                    : AppColors.kcDangerColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        if (events.length > 1)
          Text(
            '+${events.length - 1} more',
            style: const TextStyle(
              fontSize: 8,
              color: Colors.grey,
            ),
          ),
      ],
    );
  }

  DateTime convertDateTimeLocalTimeZone(DateTime dateTime) {
    try {
      final utcDateTime = dateTime.toString().split('').last == 'Z'
          ? dateTime
          : DateTime.parse('${dateTime.toIso8601String()}Z');

      final userTimeZone = tz.getLocation(userLocalTimeZone.value);
      final localDateTime = tz.TZDateTime.from(utcDateTime, userTimeZone);
      return localDateTime;
    } catch (e) {
      return dateTime;
    }
  }

  void resetDailyData() {
    isListView.value = false;
    startDateTime.value = DateTime.now();
    endDateTime.value = DateTime.now();
    attendanceDailyModel.clear();
    events.clear();
    startDailyDateTime.value = DateTime.now();
    endDailyDateTime.value = DateTime.now();
  }

  Future<void> getLocalTimezone() async {
    userLocalTimeZone.value =
        await FlutterTimezone.getLocalTimezone() == 'Asia/Calcutta'
            ? 'Asia/Kolkata'
            : await FlutterTimezone.getLocalTimezone();
  }

  String removeSubstringInParentheses(String input) {
    return input.replaceAll(RegExp(r'\s*\(.*?\)\s*'), '');
  }
}
