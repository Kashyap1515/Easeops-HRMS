import 'package:easeops_web_hrms/app_export.dart';
import 'package:easeops_web_hrms/screens/attendance_screens/controller/attendance_controller.dart';
import 'package:easeops_web_hrms/screens/attendance_screens/model/attendance_report_user.dart';
import 'package:easeops_web_hrms/widgets/common_widgets/custom_date_picker.dart';
import 'package:easeops_web_hrms/widgets/common_widgets/custom_show_single_image.dart';
import 'package:universal_html/html.dart' as html;
import 'package:intl/intl.dart';

class AttendanceScreen extends GetView<AttendanceScreenController> {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: GetBuilder(
          init: controller,
          initState: (state) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              controller.setTimeZone();
              var uri = Uri.parse(html.window.location.href);
              if (uri.queryParameters.isNotEmpty) {
                String date = uri.queryParameters["date"] ?? '';
                try {
                  DateTime dateTime = DateFormat('dd-MM-yyyy').parse(
                      date != '' ? date : DateTime.now().toIso8601String());
                  controller.selectedDate.value = dateTime;
                  controller.selectDateController.text =
                      formatDateToddMMyyyy(dateTime);
                  var locationList = uri.queryParameters["locationIds"] ?? '';
                  if (locationList.isNotEmpty) {
                    controller.selectedLocationId.value =
                        locationList.split(',');
                  }
                } catch (e) {
                  controller.selectedDate.value = DateTime.now();
                  controller.selectDateController.text =
                      formatDateToddMMyyyy(DateTime.now());
                }
              }

              await controller.getLocationData();
              controller.getShiftData();
              controller.setLocation();
              html.window.history.pushState(
                null,
                'Attendance',
                '${AppRoutes.routeAttendance}?date=${formatDateToDDashMMDashY(controller.selectedDate.value)}&locationIds=${controller.selectedLocationId.join(',')}',
              );
            });
          },
          builder: (context) {
            return Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.kcWhiteColor,
                      border: Border(
                        right: BorderSide(color: AppColors.kcBorderColor),
                      ),
                    ),
                    width: Get.size.width,
                    padding: symetricV16H24,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Attendance',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.kcBlackColor,
                            ),
                          ),
                        ),
                        // const Spacer(flex: 4),
                        // Tooltip(
                        //   message:
                        //       'Export Attendance summary for All Locations',
                        //   child: CustomElevatedButton(
                        //     btnPressed: () async {
                        //       await controller.allAttendanceExcel();
                        //     },
                        //     btnText: 'Export Summary',
                        //     btnHeight: btnHeight,
                        //     btnTxtColor: AppColors.kcHeaderButtonColor,
                        //     btnColor: AppColors.kcDrawerColor,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, thickness: 1),
                  sbh10,
                  filterBody(),
                  attendanceData(),
                ],
              ),
            );
          }),
    );
  }

  Widget filterBody() {
    return Container(
      margin: symetricV16H24,
      decoration: BoxDecoration(
        color: AppColors.kcWhiteColor,
        borderRadius: br8,
        border: Border.all(color: AppColors.kcBorderColor),
      ),
      width: Get.size.width,
      padding: all10,
      child: Row(
        children: [
          SizedBox(
            height: 60,
            child: CustomTextFormField(
              heightForm: 30,
              paddingVertical: 0,
              txtFormWidth: Get.size.width / 6,
              title: 'Date',
              hintText: 'Select Date',
              suffixIcon: Icons.date_range_outlined,
              isReadOnly: true,
              onTapCallback: () {
                customSelectDate1(
                  startDate: DateTime(2000),
                  lastDate: DateTime.now(),
                  selectedDate: controller.selectedDate.value,
                ).then(
                  (value) async {
                    if (value != null) {
                      controller.selectedDate.value = value;
                      var dateFormat = formatDateToddMMyyyy(value);
                      html.window.history.pushState(
                        null,
                        'Attendance',
                        '${AppRoutes.routeAttendance}?date=${formatDateToDDashMMDashY(controller.selectedDate.value)}&locationIds=${controller.selectedLocationId.join(',')}',
                      );
                      controller.selectDateController.text = dateFormat;
                      controller.isDropDownLoading.value = false;
                      controller.isExport.value = true;
                      await controller.getAttendanceUserAPIData();
                    }
                  },
                );
              },
              textEditingController: controller.selectDateController,
            ),
          ),
          sbw16,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Location',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.kcBlackColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              // sbh2,
              if (!controller.isDropDownLoading.value) ...[
                SizedBox(
                  height: 40,
                  child: MultiSelectDropdownSchedule(
                    isOnTapValid: true,
                    height: 30,
                    width: Get.size.width / 6,
                    list: controller.locationListData.toList(),
                    errorMsg: controller.errLocation.value,
                    initiallySelected: controller.locationListData
                        .toList()
                        .where(
                          (item) => controller.selectedLocationId
                              .contains(item['id']),
                        )
                        .toList(),
                    boxDecoration: BoxDecoration(
                      borderRadius: br2,
                      color: AppColors.kcWhiteColor,
                      border: Border.all(color: AppColors.kcBorderStrokesColor),
                    ),
                    includeSelectAll: true,
                    // isLoading: controller.isAttendanceLoading.value,
                    includeSearch: true,
                    onChange: (newList) async {
                      controller.selectedLocationId.clear();
                      controller.selectedLocationDDValue.clear();
                      if (newList.isNotEmpty) {
                        for (final data in newList) {
                          controller.selectedLocationId.add(data['id']);
                          controller.selectedLocationDDValue.add(data['label']);
                        }
                      }
                      controller.errLocation.value =
                          controller.selectedLocationDDValue.isEmpty
                              ? 'Please select Location'
                              : '';
                      controller.isExport.value = true;
                      html.window.history.pushState(
                        null,
                        'Attendance',
                        '${AppRoutes.routeAttendance}?date=${formatDateToDDashMMDashY(controller.selectedDate.value)}&locationIds=${controller.selectedLocationId.join(',')}',
                      );
                      await controller.getAttendanceUserAPIData();
                    },
                    whenEmpty: 'Location(s)',
                  ),
                ),
              ] else ...[
                SizedBox(
                  height: 33.5,
                  child: Padding(
                    padding:
                        all4.copyWith(bottom: 4, top: 0, right: 0, left: 0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: br2,
                        color: AppColors.kcWhiteColor,
                        border:
                            Border.all(color: AppColors.kcBorderStrokesColor),
                      ),
                      padding:
                          all4.copyWith(right: 0, left: 0, bottom: 0, top: 4),
                      height: 30,
                      width: Get.size.width / 6,
                      child: Row(
                        children: [
                          Padding(
                            padding: all10.copyWith(top: 0, bottom: 0),
                            child: Text(
                              'Location(s)',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.kcTextLightColor,
                              ),
                              overflow: TextOverflow.fade,
                              softWrap: false,
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_drop_down_sharp),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          // const Spacer(),
          // Tooltip(
          //   message: 'Export Attendance Table for Selected Location and Date',
          //   child: CustomElevatedButton(
          //     btnPressed: () async {
          //       await controller.generateAttendanceExcel();
          //     },
          //     btnText: 'Export',
          //     btnHeight: btnHeight,
          //     btnTxtColor: AppColors.kcHeaderButtonColor,
          //     btnColor: AppColors.kcDrawerColor,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget attendanceData() {
    return Container(
      margin: symetricV16H24,
      decoration: BoxDecoration(
        color: AppColors.kcWhiteColor,
        border: Border.all(color: AppColors.kcBorderColor),
      ),
      width: Get.size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          controller.actionListHeader(),
          if (controller.isAttendanceUserLoading.value)
            const LinearProgressIndicator()
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.attendanceUserReport.length,
              itemBuilder: (context, index) {
                var userData = controller.attendanceUserReport[index];
                var userId = userData.user!.id;
                var userName = userData.user!.name;
                var locationList = controller.getUserLocationList(userId!);
                var dp = userData.user?.displayPicture ?? '';
                var attendanceList =
                    userData.attendanceList ?? <AttendanceList>[];
                var locationName = attendanceList.isNotEmpty
                    ? attendanceList.first.location!.name
                    : '';
                var adhocLocationList = attendanceList.isNotEmpty
                    ? [
                        {
                          'id': attendanceList.first.location!.id,
                          'label': attendanceList.first.location!.name
                        }
                      ]
                    : [];
                var sessionList = attendanceList.isNotEmpty
                    ? attendanceList.first.sessionList
                    : [];
                var totalTime = attendanceList.isEmpty
                    ? ''
                    : attendanceList.first.totalTimeSpentInMinutes == null
                        ? ''
                        : attendanceList.first.sessionList!.isEmpty
                            ? ''
                            : attendanceList.first.totalTimeSpentInMinutes ==
                                        0 &&
                                    attendanceList.first.sessionList!.length < 2
                                ? ''
                                : formatMinutesToHours(attendanceList
                                        .first.totalTimeSpentInMinutes ??
                                    0);

                return Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: index == controller.userLocationData.length - 1
                            ? BorderSide.none
                            : const BorderSide(color: AppColors.kcBorderColor),
                      ),
                    ),
                    child: ExpansionTile(
                      enabled: sessionList!.isNotEmpty,
                      initiallyExpanded: true,
                      title: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    if (dp.isNotEmpty) {
                                      await customShowSingleImageDialog(
                                          imageFile: dp);
                                    }
                                  },
                                  child: ClipOval(
                                    child: SizedBox(
                                      width: 32,
                                      height: 32,
                                      child: Image.network(
                                        dp,
                                        fit: BoxFit.cover,
                                        width: 32,
                                        height: 32,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                SvgPicture.asset(
                                          AppImages.imageProfile,
                                          width: 32,
                                          height: 32,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Tooltip(
                              message: '$locationName',
                              child: customText(title: userName!),
                            ),
                          ),
                          controller.buildSessionInfo(
                            timeFormatted: sessionList.isNotEmpty
                                ? sessionList.first.checkinAt
                                : null,
                            image: sessionList.isNotEmpty
                                ? sessionList.first.checkinImages
                                : [],
                            coordinates: sessionList.isNotEmpty
                                ? sessionList.first.checkinCoordinates
                                : [],
                            tooltipMessage: 'Show Check In Image',
                          ),
                          // Check-out session info
                          controller.buildSessionInfo(
                            timeFormatted: sessionList.isNotEmpty
                                ? sessionList.first.checkoutAt
                                : null,
                            image: sessionList.isNotEmpty
                                ? sessionList.first.checkoutImages
                                : [],
                            coordinates: sessionList.isNotEmpty
                                ? sessionList.first.checkoutCoordinates
                                : [],
                            tooltipMessage: 'Show Check Out Image',
                          ),
                          // Total time
                          Expanded(
                            flex: 2,
                            child: customText(title: totalTime),
                          ),
                          controller.buildCalendarButton(userName, userId),
                          controller.buildMoreActionsMenu(
                            session: sessionList.isNotEmpty
                                ? sessionList.first
                                : null,
                            userId: userId,
                            userName: userName,
                            locationList: locationList,
                            adhocLocationList: adhocLocationList,
                          ),
                        ],
                      ),
                      children: <Widget>[
                        if (attendanceList.isNotEmpty)
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: calculateHeight(
                                    attendanceList.first.sessionList!),
                                child: controller.innerList(
                                  data: userData,
                                  userName: userName,
                                  userId: userId,
                                  locationList: locationList,
                                  adhocLocationList: adhocLocationList,
                                ),
                              ),
                            ],
                          )
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  double calculateHeight(List<SessionList> sessionList) {
    return sessionList.isEmpty
        ? 0
        : sessionList.length == 1
            ? 0
            : sessionList.length == 2
                ? 45
                : sessionList.length == 3
                    ? 80
                    : sessionList.length > 3
                        ? 120
                        : 0;
  }
}
