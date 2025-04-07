import 'package:easeops_web_hrms/app_export.dart';
import 'package:easeops_web_hrms/screens/attendance_screens/controller/monthly_attendance_controller.dart';
import 'package:intl/intl.dart';
import 'package:universal_html/html.dart' as html;

class UserAttendanceViewScreen extends GetView<MonthlyAttendanceController> {
  const UserAttendanceViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: GetBuilder(
        init: controller,
        initState: (state) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            var uri = Uri.parse(html.window.location.href);
            if (uri.queryParameters.isNotEmpty) {
              controller.currUserId.value = uri.queryParameters["userId"] ?? '';
              controller.currUserName.value = uri.queryParameters["user"] ?? '';
              controller.locationIds.value =
                  (uri.queryParameters["locationId"] ?? '').split(',');
              controller.currLocationId.value = controller.locationIds.isEmpty
                  ? ''
                  : controller.locationIds.first;

              controller.startDateTime.value = DateTime(
                  controller.startDateTime.value.year,
                  controller.startDateTime.value.month,
                  1,
                  0,
                  0,
                  0);
              controller.endDateTime.value = DateTime(
                      controller.endDateTime.value.year,
                      controller.endDateTime.value.month + 1,
                      1)
                  .subtract(
                const Duration(seconds: 1),
              );
              await controller.getActiveDaysData();
              await controller.getAttendanceUserAPIData();
              controller.setTimeZone();
            }
          });
        },
        builder: (context) {
          return Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: AppColors.kcWhiteColor,
                  padding: all24.copyWith(top: 16, bottom: 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          InkWell(
                            child: const Icon(Icons.arrow_back_ios_new_rounded),
                            onTap: () {
                              Get.offAllNamed(
                                '${AppRoutes.routeAttendance}?date=${formatDateToDDashMMDashY(DateTime.now())}&locationIds=${controller.locationIds.join(',')}',
                              );
                            },
                          ),
                          sbw16,
                          Expanded(
                            child: Text(
                              "${controller.removeSubstringInParentheses(controller.currUserName.value)}'s Monthly Report",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: AppColors.kcBlackColor,
                              ),
                            ),
                          ),
                          Obx(() {
                            return controller.isListView.value
                                ? const SizedBox.shrink()
                                : controller.userListData.isEmpty
                                    ? const SizedBox.shrink()
                                    : CustomDropDown(
                                        itemList: controller
                                                .userListData.isNotEmpty
                                            ? controller.userListData.toList()
                                            : [],
                                        isMapList: true,
                                        height: 40,
                                        width: 240,
                                        hintText: 'Select User',
                                        selectedItem:
                                            controller.userListData.isNotEmpty
                                                ? controller.userListData
                                                    .firstWhere(
                                                    (user) =>
                                                        user['label'] ==
                                                        controller
                                                            .removeSubstringInParentheses(
                                                                controller
                                                                    .currUserName
                                                                    .value),
                                                    orElse: () => {
                                                      'label': controller
                                                          .userListData
                                                          .first['label']
                                                    },
                                                  )['label']
                                                : controller.userListData
                                                    .first['label'],
                                        onTapCallback: (val) async {
                                          String userName = val['label'];
                                          String userId = val['id'];

                                          html.window.history.pushState(
                                            null,
                                            ' ',
                                            "${AppRoutes.routeAttendanceDetail}?user=$userName&userId=$userId&locationId=${controller.currLocationId.value}",
                                          );
                                          controller.events.clear();
                                          controller.currUserId.value = userId;
                                          controller.currUserName.value =
                                              userName;
                                          await controller.getActiveDaysData();
                                        },
                                      );
                          }),
                          sbw10,
                          Tooltip(
                            message:
                                'Export User Attendance Check-in, Check-out, & Total Time',
                            child: CustomElevatedButton(
                              btnPressed: () {
                                if (controller.isListView.value == true) {
                                  controller.generateAttendanceExcel('Weekly',
                                      startDate:
                                          controller.startDailyDateTime.value,
                                      endDate:
                                          controller.endDailyDateTime.value);
                                } else {
                                  controller.generateAttendanceExcel('Monthly',
                                      startDate: controller.startDateTime.value,
                                      endDate: controller.endDateTime.value);
                                }
                              },
                              btnText: 'Export',
                              btnHeight: btnHeight,
                              btnTxtColor: AppColors.kcHeaderButtonColor,
                              btnColor: AppColors.kcDrawerColor,
                            ),
                          ),
                          sbw8,
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.kcWhiteColor,
                              borderRadius: br8,
                              border:
                                  Border.all(color: AppColors.kcBorderColor),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: all8,
                                  child: InkWell(
                                    child: Icon(
                                      Icons.calendar_month,
                                      color: controller.isListView.value
                                          ? AppColors.kcBlackColor
                                          : AppColors.kcPrimaryColor,
                                    ),
                                    onTap: () async {
                                      controller.isListView.value = false;
                                      await controller.getActiveDaysData();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      sbh8,
                      // const Divider(
                      //   height: 2,
                      //   thickness: 2,
                      // ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: all24.copyWith(bottom: 0),
                      child: Text(
                        '${controller.isListView.value ? 'Weekly' : 'Monthly'} Report',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.kcBlackColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // controller.isListView.value
                    //     ? dataBodyListView()
                    controller.dataBodyCalenderView(),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget dataBodyListView() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kcWhiteColor,
        borderRadius: br8,
        border: Border.all(color: AppColors.kcBorderColor),
      ),
      width: Get.size.width,
      margin: all24.copyWith(top: 10, bottom: 16),
      padding: all8,
      child: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            headerSection(),
            sbh5,
            tableHeader(),
            tableBody(),
          ],
        ),
      ),
    );
  }

  Widget headerSection() {
    var startDate = (DateFormat('dd MMMM, yyyy')
            .format(controller.startDailyDateTime.value))
        .toString();
    var endDate =
        (DateFormat('dd MMMM, yyyy').format(controller.endDailyDateTime.value))
            .toString();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            controller.endDailyDateTime.value = controller
                .startDailyDateTime.value
                .subtract(const Duration(days: 1))
                .copyWith(
                  hour: 0,
                  minute: 0,
                  second: 0,
                  millisecond: 0,
                  microsecond: 0,
                );
            controller.startDailyDateTime.value = controller
                .endDailyDateTime.value
                .subtract(const Duration(days: 7))
                .copyWith(
                  hour: 23,
                  minute: 59,
                  second: 59,
                  millisecond: 999,
                  microsecond: 999,
                );

            await controller.getDailyAttendanceData();
          },
        ),
        Text(
          '$startDate - $endDate',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: AppColors.kcBlackColor,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () async {
            controller.startDailyDateTime.value = controller
                .endDailyDateTime.value
                .add(const Duration(days: 1))
                .copyWith(
                  hour: 0,
                  minute: 0,
                  second: 0,
                  millisecond: 0,
                  microsecond: 0,
                );
            controller.endDailyDateTime.value = controller
                .startDailyDateTime.value
                .add(const Duration(days: 5))
                .copyWith(
                  hour: 23,
                  minute: 59,
                  second: 59,
                  millisecond: 999,
                  microsecond: 999,
                );

            await controller.getDailyAttendanceData();
          },
        ),
      ],
    );
  }

  Widget tableHeader() {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Day ',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: AppColors.kcBlackColor,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Check In',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: AppColors.kcBlackColor,
              ),
            ),
          ),
          const Expanded(
            flex: 4,
            child: Text(''),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Check-out',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: AppColors.kcBlackColor,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Total Session Hours',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: AppColors.kcBlackColor,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Total Hours',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: AppColors.kcBlackColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget tableBody() {
    return controller.isWeekDayLoading.value
        ? const LinearProgressIndicator()
        : controller.attendanceDailyModel.isEmpty
            ? const SizedBox()
            : ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.attendanceDailyModel
                    .toList()
                    .first
                    .attendanceList!
                    .length,
                itemBuilder: (context, index) {
                  var data = controller.attendanceDailyModel
                      .toList()
                      .first
                      .attendanceList![index];
                  var sessionData = data.sessionList ?? [];
                  return Column(
                    children: sessionData
                        .map((session) => ListTile(
                              title: Row(
                                children: [
                                  // Expanded(
                                  //   flex: 2,
                                  //   child: Tooltip(
                                  //     message: session.shift!.startTime ==
                                  //                 null ||
                                  //             session.shift!.endTime == null
                                  //         ? ''
                                  //         : '${convertTo12HourFormat(
                                  //             session.shift!.startTime ?? '',
                                  //           )} - ${convertTo12HourFormat(
                                  //             session.shift!.endTime ?? '',
                                  //           )}',
                                  //     child: Text(
                                  //       sessionData.indexOf(session) != 0
                                  //           ? ''
                                  //           : session.shift == null
                                  //               ? ''
                                  //               : session.shift!.name ?? '',
                                  //       style: GoogleFonts.inter(
                                  //         fontSize: 14,
                                  //         color: AppColors.kcBlackColor,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      sessionData.indexOf(session) != 0
                                          ? ''
                                          : data.markedAt == null
                                              ? ''
                                              : DateFormat('dd MMM, yyyy')
                                                  .format(
                                                    controller
                                                        .convertDateTimeLocalTimeZone(
                                                            data.markedAt!),
                                                  )
                                                  .toString(),
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: AppColors.kcBlackColor,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Tooltip(
                                      message: session.checkinAt == null
                                          ? ''
                                          : formatDateToDDashMMDashYHM(
                                              controller
                                                  .convertDateTimeLocalTimeZone(
                                                session.checkinAt!,
                                              ),
                                            ),
                                      child: Text(
                                        session.checkinAt == null
                                            ? ''
                                            : DateFormat.jm()
                                                .format(
                                                  controller
                                                      .convertDateTimeLocalTimeZone(
                                                          session.checkinAt!),
                                                )
                                                .toString(),
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: AppColors.kcBlackColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      '---------------------------------',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: AppColors.kcBlackColor,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Tooltip(
                                      message: session.checkoutAt == null
                                          ? ''
                                          : formatDateToDDashMMDashYHM(
                                              controller
                                                  .convertDateTimeLocalTimeZone(
                                                      session.checkoutAt!),
                                            ),
                                      child: Text(
                                        session.checkoutAt == null
                                            ? '-'
                                            : DateFormat.jm()
                                                .format(
                                                  controller
                                                      .convertDateTimeLocalTimeZone(
                                                          session.checkoutAt!),
                                                )
                                                .toString(),
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: AppColors.kcBlackColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      session.checkinAt == null ||
                                              session.checkoutAt == null
                                          ? '-'
                                          : controller.calculateDifference(
                                              startDate: session.checkinAt!,
                                              endDate: session.checkoutAt!,
                                            ),
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: AppColors.kcBlackColor,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      sessionData.indexOf(session) != 0
                                          ? ''
                                          : data.totalTimeSpentInMinutes == null
                                              ? ''
                                              : formatMinutesToHours(
                                                  data.totalTimeSpentInMinutes ??
                                                      0),
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: AppColors.kcBlackColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  );
                },
              );
  }

  String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes =
        duration.inMinutes % 60 == 0 || duration.inMinutes % 60 == 59
            ? duration.inMinutes % 60
            : (duration.inMinutes % 60) + 1;
    String formattedTime =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')} Hrs';
    return formattedTime;
  }
}
