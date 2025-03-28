import 'package:easeops_web_hrms/app_export.dart';
import 'package:easeops_web_hrms/screens/attendance_screens/model/attendance_report_user.dart';
import 'package:easeops_web_hrms/screens/attendance_screens/model/image_upload_model.dart';
import 'package:easeops_web_hrms/screens/shift_pages/model/shift_model.dart';
import 'package:easeops_web_hrms/utils/generate_excel.dart';
import 'package:easeops_web_hrms/utils/image_picker_file.dart';
import 'package:easeops_web_hrms/widgets/common_widgets/custom_show_single_image.dart';
import 'package:easeops_web_hrms/widgets/common_widgets/custom_time_picker.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

class AttendanceScreenController extends GetxController {
  final NetworkApiService apiService = NetworkApiService();
  final formKey = GlobalKey<FormState>();

  RxList<AttendanceReportUserModel> attendanceUserReport =
      <AttendanceReportUserModel>[].obs;
  List<AttendanceReportUserModel> attendanceReport =
      <AttendanceReportUserModel>[];
  RxList<GetUserModel> getUserModelResponse = <GetUserModel>[].obs;
  TextEditingController textNameController = TextEditingController();
  TextEditingController textEmailController = TextEditingController();
  TextEditingController textPhoneNoController = TextEditingController();
  TextEditingController departmentTextController = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool isUserLoading = false.obs;
  RxBool isAttendanceUserLoading = true.obs;
  RxBool isDropDownLoading = false.obs;
  RxBool isExport = true.obs;

  // RxBool isChecklistLoc = false.obs;
  // RxList checkinCoordinates = [].obs;

  RxMap<String, String?> userAttendanceMap = <String, String?>{}.obs;
  RxList<Map<String, dynamic>> userLocationData = <Map<String, dynamic>>[].obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  RxList<Map<String, dynamic>> locationListData = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> roleListData = <Map<String, dynamic>>[].obs;

  // RxList<Map<String, dynamic>> checklistListData = <Map<String, dynamic>>[].obs;
  // RxList<Map<String, dynamic>> checklistFilterListData =
  //     <Map<String, dynamic>>[].obs;
  RxList<String> departmentListData = <String>[].obs;

  // RxList<Map<String, dynamic>> userlocationListData =
  //     <Map<String, dynamic>>[].obs;

  RxList<Map<String, dynamic>> shiftListData = <Map<String, dynamic>>[].obs;
  TextEditingController selectDateController = TextEditingController();
  TextEditingController selectPunchInDateController = TextEditingController();
  TextEditingController selectPunchInTimeController = TextEditingController();
  TextEditingController checkinImageUploadController = TextEditingController();
  TextEditingController checkoutImageUploadController = TextEditingController();

  Rx<TimeOfDay> selectedPunchInTime = TimeOfDay.now().obs;
  TextEditingController selectPunchOutDateController = TextEditingController();
  TextEditingController selectPunchOutTimeController = TextEditingController();

  Rx<TimeOfDay> selectedPunchOutTime = TimeOfDay.now().obs;
  TextEditingController textCommentController = TextEditingController();
  RxString selectedLocationValue = ''.obs;
  RxString selectedLocId = ''.obs;
  RxString selectedShiftDDValue = ''.obs;
  RxString selectedShiftId = ''.obs;
  RxString errShift = ''.obs;
  RxString errLocation = ''.obs;
  RxString errPunchInDate = ''.obs;
  RxString errPunchInTime = ''.obs;
  RxString errPunchOutDate = ''.obs;
  RxString errPunchOutTime = ''.obs;
  RxString errComment = ''.obs;
  RxString errImageUpload = ''.obs;
  RxString errName = ''.obs;
  RxString errDepartment = ''.obs;
  RxString errEmail = ''.obs;
  RxString errPhoneNo = ''.obs;
  RxString errRole = ''.obs;
  RxString errLocationUser = ''.obs;

  // RxString errChecklist = ''.obs;
  RxDouble userLat = 0.0.obs;
  RxDouble userLon = 0.0.obs;
  RxString userLocalTimeZone = 'Asia/Kolkata'.obs;
  RxList<XFile> checkinImageList = <XFile>[].obs;
  RxList<XFile> checkoutImageList = <XFile>[].obs;
  RxList<String> checkinImageUrls = <String>[].obs;
  RxList<String> checkoutImageUrls = <String>[].obs;
  RxList<String> selectedLocationId = <String>[].obs;
  RxList<String> selectedLocationDDValue = <String>[].obs;

  // RxList<String> selectedChecklistIds = <String>[].obs;
  RxString selectedRoleDDValue = ''.obs;
  RxString selectedRoleId = ''.obs;

  // RxList<String> userLocationName = <String>[].obs;
  Map<String, List<AttendanceReportUserModel>> locationWiseAttendanceData = {};
  List<LocationListModel> locListData = [];
  Map<String, List<AttendanceReportUserModel>> locationAttendanceData = {};
  Rx<DateTime> startDateTime = DateTime.now().obs;
  Rx<DateTime> endDateTime = DateTime.now().obs;

  Future<void> setTimeZone() async {
    tzdata.initializeTimeZones();
    await getLocalTimezone();
  }

  Widget innerList({
    required AttendanceReportUserModel data,
    String? userName,
    String? userId,
    List<Map<String, dynamic>>? locationList,
    List<dynamic>? adhocLocationList,
  }) {
    if (data.attendanceList!.isEmpty) {
      return const SizedBox();
    }
    var sessionList = data.attendanceList?.first.sessionList ?? [];
    if (sessionList.isEmpty) {
      return const SizedBox();
    }
    sessionList.removeAt(0);
    return ListView.builder(
      shrinkWrap: true,
      itemCount: sessionList.length,
      itemBuilder: (BuildContext context, int index) {
        var sessionData = sessionList[index];
        final checkinCoordinates = sessionData.checkinCoordinates ?? [];
        final checkinImage = sessionData.checkinImages ?? [];
        final checkoutCoordinates = sessionData.checkoutCoordinates ?? [];
        final checkoutImage = sessionData.checkoutImages ?? [];
        return Container(
          padding: symetricH16.copyWith(top: 0, bottom: 0),
          child: Row(
            children: [
              const Expanded(child: SizedBox()),
              const Expanded(flex: 2, child: SizedBox()),
              buildSessionInfo(
                timeFormatted: sessionData.checkinAt,
                image: checkinImage,
                coordinates: checkinCoordinates,
                tooltipMessage: 'Show Check In Image',
              ),
              buildSessionInfo(
                timeFormatted: sessionData.checkoutAt,
                image: checkoutImage,
                coordinates: checkoutCoordinates,
                tooltipMessage: 'Show Check Out Image',
              ),
              const SizedBox(width: 40),
              const Expanded(flex: 2, child: SizedBox()),
              buildMoreActionsMenu(
                  flex: 2,
                  session: sessionData,
                  userName: userName,
                  userId: userId,
                  locationList: locationList,
                  adhocLocationList: adhocLocationList),
            ],
          ),
        );
      },
    );
  }

  Widget buildSessionInfo({
    required DateTime? timeFormatted,
    required List<String> image,
    required List<String> coordinates,
    required String tooltipMessage,
  }) {
    final timeFormat = DateFormat.jm();
    return Expanded(
      flex: 2,
      child: Row(
        children: [
          Tooltip(
            message: timeFormatted != null
                ? formatDateToDDashMMDashYHMA(
                    convertDateTimeLocalTimeZone(timeFormatted))
                : '',
            child: customText(
              title: timeFormatted != null
                  ? timeFormat
                      .format(convertDateTimeLocalTimeZone(timeFormatted))
                  : '',
            ),
          ),
          sbw10,
          if (timeFormatted != null)
            InkWell(
              onTap: () async {
                if (image.isNotEmpty) {
                  await customShowSingleImageDialog(imageFile: image.first);
                }
              },
              child: Tooltip(
                message: tooltipMessage,
                child: const Icon(
                  Icons.photo_outlined,
                  color: AppColors.kcBlackColor,
                  size: 16,
                ),
              ),
            ),
          sbw5,
          // if (timeFormatted != null)
          // InkWell(
          //   onTap: () async {
          //     if (coordinates.isNotEmpty && coordinates.length == 2) {
          //       await customAddDialog(
          //         title: 'Google Map View',
          //         items: Column(
          //           children: [
          //             SizedBox(
          //               height: Get.size.height / 1.5,
          //               width: Get.size.width / 1.5,
          //               child: CustomGoogleMap(
          //                 storeLocation: LatLng(
          //                   double.parse(coordinates.first),
          //                   double.parse(coordinates.last),
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //         padding: EdgeInsets.zero,
          //         btnTitle: AppStrings.btnClose,
          //         onBtnCallback: Get.back,
          //       );
          //     }
          //   },
          //   child: Tooltip(
          //     message: 'Show Location',
          //     child: SvgPicture.asset(AppImages.imageMapLocation),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget actionListHeader({bool isFromNone = false}) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.kcTableHeaderColor,
      ),
      child: ListTile(
        title: Row(
          children: [
            Expanded(
              flex: 1,
              child: customText(
                title: 'DP',
                isHeader: true,
              ),
            ),
            Expanded(
              flex: 2,
              child: customText(
                title: 'Name',
                isHeader: true,
              ),
            ),
            // Expanded(
            //   flex: 3,
            //   child: customText(
            //     title: 'Location',
            //     isHeader: true,
            //     textAlign: TextAlign.center,
            //   ),
            // ),
            Expanded(
              flex: 2,
              child: customText(
                title: 'In Time',
                isHeader: true,
              ),
            ),
            Expanded(
              flex: 2,
              child: customText(
                title: 'Out Time',
                isHeader: true,
              ),
            ),
            Expanded(
              flex: 2,
              child: customText(
                title: 'Total Time',
                isHeader: true,
              ),
            ),
            Expanded(
              child: customText(
                title: 'Report',
                isHeader: true,
              ),
            ),
            const SizedBox(
              width: 30,
            ),
            Expanded(
              child: customText(
                title: 'Action',
                textAlign: TextAlign.end,
                isHeader: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCalendarButton(
    String userName,
    String userId,
  ) {
    return Expanded(
      child: InkWell(
        onTap: () {
          final locationId = selectedLocationId.join(',');
          Get.toNamed(
              "${AppRoutes.routeAttendanceDetail}?user=$userName&userId=$userId&locationId=$locationId");
        },
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 8),
            child: Icon(
              Icons.calendar_month,
              size: 24,
              color: AppColors.kcPrimaryColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMoreActionsMenu({
    SessionList? session,
    int flex = 1,
    String? userId,
    String? userName,
    List<Map<String, dynamic>>? locationList,
    List<dynamic>? adhocLocationList,
  }) {
    final parts = userId!.split('-');

    return Expanded(
      flex: flex,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomMenuAnchor(
            alignmentOffset: const Offset(-100, -10),
            lstMenu: [
              customMenuItemButton(
                title: 'Add Punch',
                onPressed: () async {
                  await onAttendanceTap(
                    isUpdate: false,
                    userId: userId,
                    userName: userName,
                    locationList: locationList,
                  );
                },
              ),
              if (session != null)
                customMenuItemButton(
                  title: 'Edit Punch',
                  onPressed: () async {
                    await onRowEditOptionTap(
                      session: session,
                      userName: userName,
                    );
                  },
                ),
              if (session != null)
                customMenuItemButton(
                  title: 'Delete Punch',
                  onPressed: () async {
                    await onRowDeleteOptionTap(session: session);
                  },
                ),
              if (session != null && userName == parts.last)
                customMenuItemButton(
                  title: 'Add as user',
                  onPressed: () async {
                    getRoleDepartAPIData();
                    onAddUserTap(
                      locationList: adhocLocationList,
                      session: session,
                      userId: userId,
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> onAddUserTap({
    List<dynamic>? locationList,
    SessionList? session,
    String? userId,
  }) async {
    if (session != null) {
      selectedLocationValue.value = locationList!.first['label'];
      selectedLocId.value = locationList.first['id'];
    }
    // getChecklist();
    // getUniqueChecklists(locationList:locationList);
    await customAddDialog(
      title: 'Create User',
      items: Form(
        key: formKey,
        child: Obx(
          () => Column(
            children: [
              ResponsiveFormLayout(
                childPerRow: 3,
                children: [
                  CustomTextFormField(
                    txtFormWidth: 240,
                    isFillKcLightGrey: true,
                    title: 'Name',
                    errorMsg: errName.value,
                    validatorCallback: (val) {
                      errName.value =
                          validateEmptyData(val, fieldName: 'Name') ?? '';
                      return null;
                    },
                    onChangedCallBack: (val) {
                      errName.value =
                          validateEmptyData(val, fieldName: 'Name') ?? '';
                      return null;
                    },
                    paddingVertical: 14,
                    textEditingController: textNameController,
                  ),
                  CustomTextFormField(
                    txtFormWidth: 240,
                    isFillKcLightGrey: true,
                    title: 'Email',
                    errorMsg: errEmail.value,
                    validatorCallback: (val) {
                      if (textPhoneNoController.text.trim().isEmpty) {
                        errEmail.value = validateEmail(val) ?? '';
                      } else {
                        errEmail.value = '';
                        errPhoneNo.value = '';
                      }
                      return null;
                    },
                    onChangedCallBack: (val) {
                      if (textPhoneNoController.text.trim().isEmpty) {
                        errEmail.value = validateEmail(val) ?? '';
                      } else {
                        errEmail.value = '';
                        errPhoneNo.value = '';
                      }
                      return null;
                    },
                    paddingVertical: 14,
                    textEditingController: textEmailController,
                  ),
                  CustomTextFormField(
                    txtFormWidth: 240,
                    isFillKcLightGrey: true,
                    title: 'Phone Number',
                    errorMsg: errPhoneNo.value,
                    validatorCallback: (val) {
                      if (textEmailController.text.trim().isEmpty) {
                        errPhoneNo.value = validateMobileNumber(val) ?? '';
                      } else {
                        errPhoneNo.value = '';
                        errEmail.value = '';
                      }
                      return null;
                    },
                    onChangedCallBack: (val) {
                      if (textEmailController.text.trim().isEmpty) {
                        errPhoneNo.value = validateMobileNumber(val) ?? '';
                      } else {
                        errPhoneNo.value = '';
                        errEmail.value = '';
                      }
                      return null;
                    },
                    paddingVertical: 14,
                    textEditingController: textPhoneNoController,
                  ),
                ],
              ),
              ResponsiveFormLayout(
                childPerRow: 3,
                // flex: 2,
                // flexForChildren: 2,
                children: <Widget>[
                  CustomDropDown(
                    itemList: roleListData.toList(),
                    isMapList: true,
                    height: 40,
                    width: 240,
                    selectedItem: selectedRoleDDValue.value != ''
                        ? selectedRoleDDValue.value
                        : null,
                    title: 'Role',
                    hintText: 'Select Role',
                    errorMsg: errRole.value,
                    onTapCallback: (val) {
                      selectedRoleDDValue.value = val['label'];
                      selectedRoleId.value = val['id'];
                      errRole.value = selectedRoleDDValue.value == ''
                          ? 'Please select Role'
                          : '';
                    },
                  ),
                  SizedBox(
                    height: 70,
                    width: 240,
                    child: MultiSelectDropdownSchedule(
                      isOnTapValid: true,
                      list: locationList!.toList(),
                      initiallySelected: locationListData
                          .toList()
                          .where((item) => selectedLocId.contains(item['id']))
                          .toList(),
                      width: 240,
                      height: 40,
                      title: 'Location',
                      errorMsg: errLocationUser.value,
                      onChange: (newList) async {
                        // isChecklistLoc.value = true;
                        selectedLocId.value = '';
                        // checklistLocData.clear();
                        if (newList.isNotEmpty) {
                          for (final data in newList) {
                            selectedLocId.value = data['id'];
                          }
                          // await getUniqueChecklists();
                        }
                        // else {
                        //   isChecklistLoc.value = false;
                        // }
                        errLocationUser.value = selectedLocId.isEmpty
                            ? 'Please select location'
                            : '';
                      },
                      whenEmpty: 'Location(s)',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0)
                        .copyWith(bottom: 10, top: 0, left: 0, right: 0),
                    child: CustomDropDownWithTextField(
                      itemList: departmentListData.toList(),
                      height: 40,
                      width: 240,
                      textEditingController: departmentTextController,
                      title: 'Department',
                      hintText: 'All Department',
                      // errorMsg: errDepartment.value,
                      // validatorCallback: (val) {
                      //   errDepartment.value =
                      //       validateEmptyData(val, fieldName: 'Department') ?? '';
                      //   return null;
                      // },
                      // onChangedCallBack: (val) {
                      //   errDepartment.value =
                      //       validateEmptyData(val, fieldName: 'Department') ?? '';
                      //   return null;
                      // },
                      onSelectedCallback: (dynamic value) async {
                        departmentTextController.text = value
                            .toString()
                            .replaceAll('Create ', '')
                            .replaceAll('"', '');
                        errDepartment.value = validateEmptyData(
                              departmentTextController.text,
                              fieldName: 'Department',
                            ) ??
                            '';
                        // await getUniqueChecklists();
                        // isChecklistLoc.value = true;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      buttons: [
        CustomElevatedButton(
          btnHeight: btnHeight,
          btnColor: AppColors.kcDrawerColor,
          btnText: AppStrings.btnClose,
          btnTxtColor: AppColors.kcHeaderButtonColor,
          btnPressed: () {
            resetData();
            Get.back<void>();
          },
          borderRadius: btnBorderRadius,
        ),
        CustomElevatedButton(
          btnHeight: btnHeight,
          btnColor: AppColors.kcHeaderButtonColor,
          btnText: 'Create User',
          btnPressed: () async {
            errRole.value =
                selectedRoleId.value == '' ? 'Please select role' : '';
            errLocation.value =
                locationList!.toList().isEmpty ? 'Please select location' : '';
            if (!formKey.currentState!.validate()) {
              return;
            }
            if (!checkIsItValidForUser(locationList: locationList) ||
                selectedRoleDDValue.value == '') {
              return;
            }
            await onCreateUserAPICall(
                userId: userId, dp: session!.checkinImages);
            formKey.currentState!.save();
          },
          borderRadius: btnBorderRadius,
        ),
      ],
    );
  }

  Future<void> onCreateUserAPICall({String? userId, List<String>? dp}) async {
    isAttendanceUserLoading.value = true;
    final userCreateMap = <String, dynamic>{
      'name': textNameController.text.trim(),
      'id': userId,
      'display_picture': dp!.first,
      'email': textEmailController.text.trim().isEmpty
          ? null
          : textEmailController.text.trim(),
      'phone_number': textPhoneNoController.text.trim().isEmpty
          ? null
          : textPhoneNoController.text.trim(),
      'roles': [selectedRoleId.value],
      'locations': [selectedLocId.value],
      'department_name': departmentTextController.text.trim(),
      'checklists': [],
    };
    try {
      final result = await apiService.postResponse(
        endpoint: ApiEndPoints.apiUser,
        token: AppPreferences.getUserData()!.token,
        postBody: userCreateMap,
      );
      if (result != null) {
        Get.back<void>();
        customSnackBar(
          title: AppStrings.textSuccess,
          message: 'User (${textNameController.text}) is created!',
          alertType: AlertType.alertMessage,
        );
        resetData();
        getAttendanceUserAPIData();
      } else {
        customSnackBar(
          title: AppStrings.textError,
          message: AppStrings.textErrorMessage,
          alertType: AlertType.alertError,
        );
        isAttendanceUserLoading.value = false;
      }
    } catch (e) {
      customSnackBar(
        title: AppStrings.textError,
        message: '${AppStrings.textErrorMessage} $e',
        alertType: AlertType.alertError,
      );
      isAttendanceUserLoading.value = false;
    }
  }

  Future<void> getRoleDepartAPIData() async {
    await apiService
        .getResponse(
      endpoint: ApiEndPoints.apiRole,
      token: AppPreferences.getUserData()!.token,
    )
        .then((value) {
      if (value != null) {
        final data = locationListModelFromJson(jsonEncode(value));
        roleListData.clear();
        for (var i = 0; i < data.length; i++) {
          roleListData.add({'id': data[i].id, 'label': data[i].name});
        }
      }
    });
    await apiService
        .getResponse(
      endpoint: ApiEndPoints.apiDepartment,
      token: AppPreferences.getUserData()!.token,
    )
        .then((value) {
      if (value != null) {
        departmentListData.clear();
        for (var i = 0; i < value.length; i++) {
          departmentListData.add(value[i]['name'] ?? '');
        }
      }
    });
  }

  Future<void> getLocationData() async {
    isDropDownLoading.value = true;
    locListData.clear();
    await apiService
        .getResponse(
      endpoint: ApiEndPoints.apiLocation,
      token: AppPreferences.getUserData()!.token,
    )
        .then((value) async {
      if (value != null) {
        final allLocationData = locationListModelFromJson(jsonEncode(value));
        locationListData.clear();
        locListData = locationListModelFromJson(jsonEncode(value));
        for (var data in allLocationData) {
          locationListData.add({'id': data.id, 'label': data.name});
        }
        if (allLocationData.isNotEmpty) {
          if (selectedLocationId.isEmpty && selectedLocationDDValue.isEmpty) {
            selectedLocationId.add(locationListData.first['id'] ?? '');
            selectedLocationDDValue.add(locationListData.first['label'] ?? '');
          }
          await getUserAPIData();
          await getAttendanceUserAPIData();
          isDropDownLoading.value = false;
        } else {
          isDropDownLoading.value = false;
        }
      } else {
        isDropDownLoading.value = false;
      }
    });
  }

  Future<void> getShiftData() async {
    isLoading.value = true;
    await apiService
        .getResponse(
      endpoint: ApiEndPoints.apiShiftData,
      token: AppPreferences.getUserData()!.token,
    )
        .then((value) async {
      if (value != null) {
        final shiftData = shiftDataModelFromJson(jsonEncode(value));
        shiftListData.clear();
        for (var data in shiftData) {
          shiftListData.add({'id': data.id, 'label': data.name});
        }
        if (shiftData.isNotEmpty) {
          selectedShiftId.value = shiftListData.first['id'] ?? '';
          selectedShiftDDValue.value = shiftListData.first['label'] ?? '';
          isLoading.value = false;
        } else {
          isLoading.value = false;
        }
      } else {
        isLoading.value = false;
      }
    });
  }

  Future<void> getUserAPIData() async {
    isUserLoading.value = true;
    await apiService
        .getResponse(
      endpoint: ApiEndPoints.apiUser,
      token: AppPreferences.getUserData()!.token,
    )
        .then((value) {
      if (value != null) {
        getUserModelResponse.clear();
        for (var i = 0; i < value.length; i++) {
          getUserModelResponse.add(GetUserModel.fromJson(value[i]));
        }
        isUserLoading.value = false;
      } else {
        isUserLoading.value = false;
        customSnackBar(
          title: AppStrings.textError,
          message: AppStrings.textErrorMessage,
          alertType: AlertType.alertError,
        );
      }
    }).catchError((err) {
      isUserLoading.value = false;
      customSnackBar(
        title: AppStrings.textError,
        message: AppStrings.textErrorMessage,
        alertType: AlertType.alertError,
      );
    });
  }

  List<Map<String, String>> getUserLocationList(String userId) {
    final user = getUserModelResponse.firstWhere(
      (user) => user.id == userId,
      orElse: () => GetUserModel(locations: []),
    );

    List<Map<String, String>> locationList = user.locations?.map((location) {
          return {
            'id': location.id ?? '',
            'label': location.alias ?? '',
          };
        }).toList() ??
        [];

    return locationList;
  }

  Future<void> getAttendanceUserAPIData() async {
    if (isExport.value) {
      isAttendanceUserLoading.value = true;
    }
    locationWiseAttendanceData.clear();
    userLocationData.clear();
    String dateString = formatDateToYDashMMDashD(selectedDate.value);
    var locationId = selectedLocationId.join(',');
    await apiService
        .getResponse(
      endpoint:
          '${ApiEndPoints.apiAttendanceUserData}?utc_from_dt=$dateString 00:00:00&utc_till_dt=$dateString 23:59:59&location_id_list=$locationId',
      token: AppPreferences.getUserData()!.token,
    )
        .then(
      (value) async {
        if (value != null) {
          attendanceUserReport.clear();
          attendanceReport.clear();
          List<AttendanceReportUserModel> locData = [];
          for (var index = 0; index < value.length; index++) {
            attendanceUserReport.add(
              AttendanceReportUserModel.fromJson(value[index]),
            );
            attendanceReport.add(
              AttendanceReportUserModel.fromJson(value[index]),
            );
            locData.add(
              AttendanceReportUserModel.fromJson(value[index]),
            );
          }
          locationWiseAttendanceData[locationId] = locData;
          // userLocationData.assignAll(await getUserLocationList());
        } else {
          isAttendanceUserLoading.value = false;
          customSnackBar(
            title: AppStrings.textError,
            message: AppStrings.textErrorMessage,
            alertType: AlertType.alertError,
          );
        }
      },
    ).catchError(
      (err) {
        isAttendanceUserLoading.value = false;
        customSnackBar(
          title: AppStrings.textError,
          message: AppStrings.textErrorMessage,
          alertType: AlertType.alertError,
        );
      },
    );
    Future.delayed(const Duration(milliseconds: 50), () {
      isAttendanceUserLoading.value = false;
    });
  }

  Future<void> onRowEditOptionTap({
    required SessionList session,
    String? userName,
  }) async {
    if (session.checkinAt != null) {
      var convertedCheckIn = convertDateTimeLocalTimeZone(session.checkinAt!);
      TimeOfDay timeOfDay = TimeOfDay(
        hour: convertedCheckIn.hour,
        minute: convertedCheckIn.minute,
      );
      selectedPunchInTime.value = timeOfDay;
      final punchInTimeFormat = selectedPunchInTime.value.format(Get.context!);
      selectPunchInTimeController.text = punchInTimeFormat;
    }
    if (session.checkoutAt != null) {
      var convertedCheckOut = convertDateTimeLocalTimeZone(session.checkoutAt!);
      TimeOfDay timeOfDay = TimeOfDay(
        hour: convertedCheckOut.hour,
        minute: convertedCheckOut.minute,
      );
      selectedPunchOutTime.value = timeOfDay;
      final punchOutTimeFormat =
          selectedPunchOutTime.value.format(Get.context!);
      selectPunchOutTimeController.text = punchOutTimeFormat;
    }
    await onAttendanceTap(
      isUpdate: true,
      session: session,
      userName: userName,
    );
  }

  Future<void> onAttendanceTap({
    required bool isUpdate,
    SessionList? session,
    String? userId,
    String? userName,
    List<Map<String, dynamic>>? locationList,
  }) async {
    if (!isUpdate) {
      selectedLocationValue.value =
          locationList == null ? '' : locationList.first['label'] ?? '';
      selectedLocId.value =
          locationList == null ? '' : locationList.first['id'] ?? '';
    }
    await customAddDialog(
      title: isUpdate
          ? 'Edit $userName Punch In/Out'
          : 'Mark $userName Punch In/Out',
      items: Form(
        key: formKey,
        child: Obx(
          () => ResponsiveFormLayout(
            childPerRow: 2,
            children: [
              if (!isUpdate)
                CustomDropDown(
                  itemList: shiftListData.toList(),
                  isMapList: true,
                  height: 40,
                  width: 230,
                  selectedItem: selectedShiftDDValue.value != ''
                      ? selectedShiftDDValue.value
                      : null,
                  hintText: 'Select Shift',
                  title: 'Select Shift',
                  errorMsg: errShift.value,
                  onTapCallback: (val) {
                    selectedShiftDDValue.value = val['label'];
                    selectedShiftId.value = val['id'];
                    errShift.value = selectedShiftDDValue.value == ''
                        ? 'Please select Shift'
                        : '';
                  },
                ),
              if (!isUpdate)
                CustomDropDown(
                  itemList: locationList!.toList(),
                  isMapList: true,
                  height: 40,
                  width: 230,
                  selectedItem: selectedLocationValue.value != ''
                      ? selectedLocationValue.value
                      : null,
                  hintText: 'Select Location',
                  title: 'Select Location',
                  onTapCallback: (val) {
                    selectedLocationValue.value = val['label'];
                    selectedLocId.value = val['id'];
                  },
                ),
              CustomTextFormField(
                isFillKcLightGrey: true,
                txtFormWidth: 230,
                title: 'Punch In Time',
                errorMsg: errPunchInTime.value,
                textEditingController: selectPunchInTimeController,
                validatorCallback: (val) {
                  errPunchInTime.value =
                      validateEmptyData(val, fieldName: 'In Time') ?? '';
                  return null;
                },
                onChangedCallBack: (val) {
                  errPunchInTime.value =
                      validateEmptyData(val, fieldName: 'In Time') ?? '';
                  return null;
                },
                isReadOnly: true,
                onTapCallback: () async {
                  await customSelectTime1(
                    selectedTime: selectedPunchInTime.value,
                  ).then(
                    (value) {
                      errPunchInTime.value = '';
                      if (value == null) {
                        errPunchInTime.value = validateEmptyData(
                              null,
                              fieldName: 'In Time',
                            ) ??
                            '';
                        selectPunchInTimeController.text = '';
                        return;
                      }
                      selectedPunchInTime.value = value;
                      final time = value.format(Get.context!);
                      selectPunchInTimeController.text = time;
                    },
                  );
                },
                paddingVertical: 14,
              ),
              if (isUpdate) const SizedBox(),
              if (!isUpdate)
                CustomTextFormField(
                  isFillKcLightGrey: true,
                  title: 'Upload Punch In Image',
                  hintText: 'Select',
                  suffixIcon: Icons.attach_file,
                  txtFormWidth: 230,
                  isReadOnly: true,
                  errorMsg: errImageUpload.value,
                  validatorCallback: (val) {
                    return null;
                  },
                  onTapCallback: () async {
                    final file = await customImagePicker();
                    if (file != null) {
                      checkinImageList.add(file);
                      checkinImageUploadController.text = checkinImageList
                              .isEmpty
                          ? ''
                          : '${checkinImageList.length} ${checkinImageList.length == 1 ? 'file' : 'files'} selected';
                    }
                  },
                  paddingVertical: 14,
                  textEditingController: checkinImageUploadController,
                ),

              // CustomTextFormField(
              //   txtFormWidth: 230,
              //   isFillKcLightGrey: true,
              //   title: 'Punch Out Date',
              //   errorMsg: errPunchOutDate.value,
              //   validatorCallback: (val) {
              //     if (isUpdate) {
              //       errPunchOutDate.value =
              //           validateEmptyData(val, fieldName: 'Punch Out') ?? '';
              //     }
              //     return null;
              //   },
              //   onChangedCallBack: (val) {
              //     if (isUpdate) {
              //       errPunchOutDate.value =
              //           validateEmptyData(val, fieldName: 'Punch Out') ?? '';
              //     }
              //     return null;
              //   },
              //   suffixIcon: Icons.date_range_outlined,
              //   isReadOnly: true,
              //   onTapCallback: () {
              //     customSelectDate1(
              //       startDate: DateTime(2000),
              //       lastDate: DateTime.now(),
              //       selectedDate: selectedPunchOutDate.value,
              //     ).then(
              //       (value) {
              //         if (value != null) {
              //           selectedPunchOutDate.value = value;
              //           var dateFormat = formatDateToddMMyyyy(value);
              //           selectPunchOutDateController.text = dateFormat;
              //         }
              //       },
              //     );
              //   },
              //   paddingVertical: 14,
              //   textEditingController: selectPunchOutDateController,
              // ),
              CustomTextFormField(
                isFillKcLightGrey: true,
                txtFormWidth: 230,
                title: 'Punch Out Time',
                errorMsg: errPunchOutTime.value,
                textEditingController: selectPunchOutTimeController,
                isReadOnly: true,
                onTapCallback: () async {
                  await customSelectTime1(
                    selectedTime: selectedPunchOutTime.value,
                  ).then(
                    (value) {
                      if (value == null) {
                        selectPunchOutTimeController.text = '';
                        return;
                      }
                      selectedPunchOutTime.value = value;
                      final time = value.format(Get.context!);
                      selectPunchOutTimeController.text = time;
                    },
                  );
                },
                paddingVertical: 14,
              ),
              if (isUpdate) const SizedBox(),
              if (!isUpdate)
                CustomTextFormField(
                  isFillKcLightGrey: true,
                  title: 'Upload Punch out Image',
                  hintText: 'Select',
                  txtFormWidth: 230,
                  suffixIcon: Icons.attach_file,
                  isReadOnly: true,
                  errorMsg: errImageUpload.value,
                  validatorCallback: (val) {
                    return null;
                  },
                  onTapCallback: () async {
                    final file = await customImagePicker();
                    if (file != null) {
                      checkoutImageList.add(file);
                      checkoutImageUploadController.text = checkoutImageList
                              .isEmpty
                          ? ''
                          : '${checkoutImageList.length} ${checkoutImageList.length == 1 ? 'file' : 'files'} selected';
                      // isLoading.value = false;
                    }
                  },
                  paddingVertical: 14,
                  textEditingController: checkoutImageUploadController,
                ),
              // const SizedBox(),
            ],
          ),
        ),
      ),
      buttons: [
        CustomElevatedButton(
          btnHeight: btnHeight,
          btnColor: AppColors.kcDrawerColor,
          btnText: AppStrings.btnClose,
          btnTxtColor: AppColors.kcHeaderButtonColor,
          btnPressed: () {
            resetData();
            Get.back<void>();
          },
          borderRadius: btnBorderRadius,
        ),
        Obx(
          () => CustomElevatedButton(
            btnHeight: btnHeight,
            btnColor: checkIsItValid(isUpdate: isUpdate)
                ? AppColors.kcHeaderButtonColor
                : AppColors.kcHeaderButtonColor.withOpacity(0.3),
            btnText: isUpdate ? 'Update Attendance' : 'Mark Punch In/Out',
            btnPressed: () async {
              if (!formKey.currentState!.validate()) {
                return;
              }

              // Perform check-in and check-out time validation here
              DateTime punchInDateTime = DateTime(
                selectedDate.value.year,
                selectedDate.value.month,
                selectedDate.value.day,
                selectedPunchInTime.value.hour,
                selectedPunchInTime.value.minute,
              );

              if (selectPunchOutTimeController.text.isNotEmpty) {
                DateTime punchOutDateTime = DateTime(
                  selectedDate.value.year,
                  selectedDate.value.month,
                  selectedDate.value.day,
                  selectedPunchOutTime.value.hour,
                  selectedPunchOutTime.value.minute,
                );

                // Validation: Check if check-in time is greater than check-out time
                if (punchInDateTime.isAfter(punchOutDateTime)) {
                  errPunchOutTime.value =
                      'Check-in time must be earlier than check-out time';
                  return;
                } else {
                  errPunchOutTime.value = '';
                }
              }

              if (session != null) {
                onUpdateAttendanceAPICall(session: session);
                resetData();
              } else {
                initializeUserAttendance(userId!);
                await onCreateAttendanceAPICall(userId: userId);
                resetData();
              }
              formKey.currentState!.save();
            },
            borderRadius: btnBorderRadius,
          ),
        ),
      ],
    );
  }

  bool checkIsItValid({required bool isUpdate}) {
    if (isUpdate &&
        errPunchInTime.value == '' &&
        selectPunchInTimeController.text != '') {
      return true;
    } else if (!isUpdate &&
        errPunchInDate.value == '' &&
        errPunchInTime.value == '' &&
        selectPunchInDateController.text != '' &&
        selectPunchInTimeController.text != '' &&
        errComment.value == '' &&
        textCommentController.text != '') {
      return true;
    } else {
      return false;
    }
  }

  Future<void> onUpdateAttendanceAPICall({
    required SessionList session,
  }) async {
    DateTime punchInTime = DateTime(
      selectedDate.value.year,
      selectedDate.value.month,
      selectedDate.value.day,
      selectedPunchInTime.value.hour,
      selectedPunchInTime.value.minute,
    ).toUtc();

    DateTime? punchOutTime = selectPunchOutTimeController.text.trim() != ''
        ? DateTime(
            selectedDate.value.year,
            selectedDate.value.month,
            selectedDate.value.day,
            selectedPunchOutTime.value.hour,
            selectedPunchOutTime.value.minute,
          ).toUtc()
        : null;

    final String? checkinAt = formatDateTime(punchInTime);
    final String? checkoutAt = formatDateTime(punchOutTime);

    final id = session.id;
    if (id != '') {
      final userPutMapData = <String, dynamic>{
        "checkin_at": checkinAt,
        "checkin_images": session.checkinImages,
        "checkin_coordinates": session.checkinCoordinates,
        "checkout_at": checkoutAt,
        "checkout_images": session.checkoutImages,
        "checkout_coordinates": session.checkinCoordinates
      };
      try {
        final result = await apiService.putResponse(
          endpoint: '${ApiEndPoints.apiAttendanceSessions}/$id',
          postBody: userPutMapData,
          token: AppPreferences.getUserData()!.token,
        );
        if (result != null) {
          Get.back<void>();
          customSnackBar(
            title: AppStrings.textSuccess,
            message: 'Attendance for user is updated!',
            alertType: AlertType.alertMessage,
          );
          resetData();
          getAttendanceUserAPIData();
        } else {
          customSnackBar(
            title: AppStrings.textError,
            message: AppStrings.textErrorMessage,
            alertType: AlertType.alertError,
          );
        }
      } catch (e) {
        if (e is ApiException) {
          customSnackBar(
            title: AppStrings.textError,
            message: AppStrings.textErrorMessage,
            alertType: AlertType.alertError,
          );
        } else {
          customSnackBar(
            title: AppStrings.textError,
            message: AppStrings.textErrorMessage,
            alertType: AlertType.alertError,
          );
        }
        Logger.log('ROLES Catch ERROR: $e');
      }
    }
  }

  Future<void> initializeUserAttendance(String userId) async {
    for (var data in attendanceUserReport) {
      String? reportUserId = data.user!.id;
      if (reportUserId == userId) {
        String? attendanceId = data.attendanceList?.isNotEmpty ?? false
            ? data.attendanceList!.first.id
            : null;

        userAttendanceMap.assign(userId, attendanceId);
      }
    }
  }

  Future<void> onCreateAttendanceAPICall({required String userId}) async {
    if (checkinImageList.isNotEmpty) {
      for (final image in checkinImageList) {
        final isImageSuccess = ImageUploadModel.fromJson(
          await onImageUploadAPICall(
            file: image,
            refId: userId,
            refName: 'checkin',
          ),
        );
        if (isImageSuccess.isSuccess && isImageSuccess.url != null) {
          final questionMarkIndex = isImageSuccess.url!.indexOf('?');
          final contentData =
              isImageSuccess.url!.substring(0, questionMarkIndex);
          checkinImageUrls.add(contentData);
        }
      }
    }

    if (checkoutImageList.isNotEmpty) {
      for (final image in checkoutImageList) {
        final isImageSuccess = ImageUploadModel.fromJson(
          await onImageUploadAPICall(
            file: image,
            refId: userId,
            refName: 'checkout',
          ),
        );
        if (isImageSuccess.isSuccess && isImageSuccess.url != null) {
          final questionMarkIndex = isImageSuccess.url!.indexOf('?');
          final contentData =
              isImageSuccess.url!.substring(0, questionMarkIndex);
          checkoutImageUrls.add(contentData);
        }
      }
    }

    DateTime punchInTime = DateTime(
      selectedDate.value.year,
      selectedDate.value.month,
      selectedDate.value.day,
      selectedPunchInTime.value.hour,
      selectedPunchInTime.value.minute,
    );

    DateTime? punchOutTime = selectPunchOutTimeController.text.trim() != ''
        ? DateTime(
            selectedDate.value.year,
            selectedDate.value.month,
            selectedDate.value.day,
            selectedPunchOutTime.value.hour,
            selectedPunchOutTime.value.minute,
          )
        : null;

    final String? checkinAt = formatDateTime(punchInTime);
    final String? checkoutAt = formatDateTime(punchOutTime);

    final userPostMapData = <String, dynamic>{
      "checkin_at": checkinAt,
      "checkin_images": checkinImageUrls.toList(),
      // "checkin_coordinates": checkinCoordinates,
      "checkout_at": checkoutAt,
      "checkout_images": checkoutImageUrls.toList(),
      // "checkout_coordinates": checkinCoordinates,
      "shift_id": selectedShiftId.value,
      "user_id": userId,
      "attendance_id": userAttendanceMap[userId],
      "location_id": selectedLocId.value,
    };
    try {
      final result = await apiService.postResponse(
        endpoint: ApiEndPoints.apiAttendanceSessions,
        postBody: userPostMapData,
        token: AppPreferences.getUserData()!.token,
      );
      if (result != null) {
        if (userAttendanceMap[userId] == null) {
          userAttendanceMap[userId] = result['attendance_id'];
        }
        Get.back<void>();
        customSnackBar(
          title: AppStrings.textSuccess,
          message: 'Attendance for user is updated!',
          alertType: AlertType.alertMessage,
        );
        resetData();
        getAttendanceUserAPIData();
      } else {
        customSnackBar(
          title: AppStrings.textError,
          message: AppStrings.textErrorMessage,
          alertType: AlertType.alertError,
        );
      }
    } catch (e) {
      Logger.log('ROLES Catch ERROR: $e');
      customSnackBar(
        title: AppStrings.textError,
        message: AppStrings.textErrorMessage,
        alertType: AlertType.alertError,
      );
    }
  }

  Future<void> onRowDeleteOptionTap({
    required SessionList session,
  }) async {
    if (session.id != '') {
      await customAddDialog(
        title: '',
        items: deleteDialogItem(title: 'Session', subTitle: 'Punch'),
        btnTitle1: AppStrings.btnClose,
        btnTitle: 'Delete Punch',
        onBtnCallback: () async {
          isLoading.value = true;
          try {
            final responseDel = await apiService.deleteResponse(
              endpoint: '${ApiEndPoints.apiAttendanceSessions}/${session.id}',
              token: AppPreferences.getUserData()!.token,
            );
            if (responseDel) {
              Get.back<void>();
              customSnackBar(
                title: AppStrings.textSuccess,
                message: 'Punch is Deleted Successfully!',
                alertType: AlertType.alertMessage,
              );
              getAttendanceUserAPIData();
            } else {
              isLoading.value = false;
              customSnackBar(
                title: AppStrings.textError,
                message: AppStrings.textErrorDeleteMessage,
                alertType: AlertType.alertError,
              );
            }
          } catch (e) {
            isLoading.value = false;
            customSnackBar(
              title: AppStrings.textError,
              message: AppStrings.textErrorMessage,
              alertType: AlertType.alertError,
            );
          }
        },
        onBtnCallback1: Get.back,
      );
    }
  }

  bool checkIsItValidForUser({List<dynamic>? locationList}) {
    bool isCommonValid = errName.value == '' &&
        textNameController.text.trim().isNotEmpty &&
        errLocation.value == '' &&
        locationList!.isNotEmpty;

    bool isEmailValid =
        errEmail.value == '' && textEmailController.text.trim().isNotEmpty;
    bool isPhoneValid =
        errPhoneNo.value == '' && textPhoneNoController.text.trim().isNotEmpty;
    return isCommonValid && (isEmailValid || isPhoneValid);
  }

  String? formatDateTime(DateTime? time) {
    if (time == null) return null;
    DateTime utcTime = time.toUtc();
    String formattedDate = formatDateToYDashMMDashD(utcTime);
    String formattedTime = DateFormat("HH:mm:ss.SSS'Z'").format(utcTime);
    return '${formattedDate}T$formattedTime';
  }

  Future<void> setLocation() async {
    final permission = await Geolocator.checkPermission();
    if (permission != LocationPermission.always ||
        permission != LocationPermission.whileInUse) {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        final position = await Geolocator.getCurrentPosition();
        userLat.value = position.latitude;
        userLon.value = position.longitude;
      }
    }
  }

  // Generate pdf file
  // Future<void> generateAttendancePDF() async {
  //   if (attendanceReport.isEmpty) {
  //     customSnackBar(
  //       title: AppStrings.textInfo,
  //       message: 'There is no data to export',
  //       alertType: AlertType.alertMessage,
  //     );
  //     return;
  //   }

  //   List<List<String>> data = [
  //     <String>['No', 'Name', 'Check-In', 'Check-Out', 'Total Time'],
  //   ];

  //   for (int index = 0; index < attendanceReport.length; index++) {
  //     var entry = attendanceReport[index];
  //     String name = entry.user?.name ?? 'N/A';

  //     if (entry.attendanceList?.isNotEmpty ?? false) {
  //       for (var attendanceItem in entry.attendanceList!) {
  //         if (attendanceItem.sessionList?.isNotEmpty ?? false) {
  //           List<String> lstInTime = <String>[];
  //           List<String> lstOutTime = <String>[];
  //           for (var session in attendanceItem.sessionList!) {
  //             String inTime = session.checkinAt != null
  //                 ? formatDateToDDashMMDashYHMA(
  //                     convertDateTimeLocalTimeZone(session.checkinAt!))
  //                 : '-';
  //             lstInTime.add(inTime);
  //             String outTime = session.checkoutAt != null
  //                 ? formatDateToDDashMMDashYHMA(
  //                     convertDateTimeLocalTimeZone(session.checkoutAt!))
  //                 : '-';
  //             lstOutTime.add(outTime);
  //           }
  //           String totalTime = entry.attendanceList!.isNotEmpty &&
  //                   entry.attendanceList!.first.totalTimeSpentInMinutes != null
  //               ? formatMinutesToHours(
  //                   entry.attendanceList!.first.totalTimeSpentInMinutes!)
  //               : '-';
  //           data.add(<String>[
  //             (index + 1).toString(),
  //             name,
  //             lstInTime.join('\n'),
  //             lstOutTime.join('\n'),
  //             totalTime,
  //           ]);
  //         } else {
  //           data.add(<String>[
  //             (index + 1).toString(),
  //             name,
  //             '-',
  //             '-',
  //             '-',
  //           ]);
  //         }
  //       }
  //     } else {
  //       data.add(<String>[
  //         (index + 1).toString(),
  //         name,
  //         '-',
  //         '-',
  //         '-',
  //       ]);
  //     }
  //   }

  //   String fileName =
  //       "EaseOps_${selectedLocationDDValue.value}_Attendance_Report_${formatDateToddMMyyyy(selectedDate.value)}.pdf";

  //   await generatePDF(
  //       fileName: fileName,
  //       data: data,
  //       heading:
  //           'EaseOps Attendance Report ${formatDateToddMMyyyy(selectedDate.value)}',
  //       heading1: 'Location: ${selectedLocationDDValue.value}');
  // }

  // Generate Excel file
  Future<void> generateAttendanceExcel() async {
    isExport.value = false;
    await getAttendanceUserAPIData();
    if (selectedLocationId.isEmpty) {
      customSnackBar(
        title: AppStrings.textInfo,
        message: 'Please select at least one location to export data',
        alertType: AlertType.alertMessage,
      );
      return;
    }

    List<xlsio.ExcelDataRow> excelDataRows = <xlsio.ExcelDataRow>[];

    for (int index = 0; index < attendanceReport.length; index++) {
      String name = attendanceReport[index].user?.name ?? '-';
      if (attendanceReport[index].attendanceList?.isNotEmpty ?? false) {
        for (var attendanceItem in attendanceReport[index].attendanceList!) {
          if (attendanceItem.sessionList?.isNotEmpty ?? false) {
            List<String> lstInTime = <String>[];
            List<String> lstOutTime = <String>[];
            for (var session in attendanceItem.sessionList!) {
              String inTime = session.checkinAt != null
                  ? formatDateToDDashMMDashYHMA(
                      convertDateTimeLocalTimeZone(session.checkinAt!))
                  : '-';
              String outTime = session.checkoutAt != null
                  ? formatDateToDDashMMDashYHMA(
                      convertDateTimeLocalTimeZone(session.checkoutAt!))
                  : '-';

              lstInTime.add(inTime);
              lstOutTime.add(outTime);
            }
            String totalTime = attendanceItem.totalTimeSpentInMinutes != null
                ? formatMinutesToHours(attendanceItem.totalTimeSpentInMinutes!)
                : '-';
            String? locationName = attendanceItem.location != null
                ? attendanceItem.location!.name
                : '-';
            excelDataRows.add(
              xlsio.ExcelDataRow(
                cells: <xlsio.ExcelDataCell>[
                  xlsio.ExcelDataCell(value: name, columnHeader: "Name"),
                  xlsio.ExcelDataCell(
                      value: lstInTime.join('\n'), columnHeader: "Check-In"),
                  xlsio.ExcelDataCell(
                      value: lstOutTime.join('\n'), columnHeader: "Check-Out"),
                  xlsio.ExcelDataCell(
                      value: totalTime, columnHeader: "Total Time"),
                  xlsio.ExcelDataCell(
                      value: locationName, columnHeader: "Location"),
                ],
              ),
            );
          } else {
            excelDataRows.add(
              xlsio.ExcelDataRow(
                cells: <xlsio.ExcelDataCell>[
                  xlsio.ExcelDataCell(value: name, columnHeader: "Name"),
                  const xlsio.ExcelDataCell(
                      value: '-', columnHeader: "Check-In"),
                  const xlsio.ExcelDataCell(
                      value: '-', columnHeader: "Check-Out"),
                  const xlsio.ExcelDataCell(
                      value: '-', columnHeader: "Total Time"),
                  const xlsio.ExcelDataCell(
                      value: '-', columnHeader: "Location"),
                ],
              ),
            );
          }

          await Future.delayed(const Duration(milliseconds: 50));
        }
      } else {
        excelDataRows.add(
          xlsio.ExcelDataRow(
            cells: <xlsio.ExcelDataCell>[
              xlsio.ExcelDataCell(value: name, columnHeader: "Name"),
              const xlsio.ExcelDataCell(value: '-', columnHeader: "Check-In"),
              const xlsio.ExcelDataCell(value: '-', columnHeader: "Check-Out"),
              const xlsio.ExcelDataCell(value: '-', columnHeader: "Total Time"),
              const xlsio.ExcelDataCell(value: '-', columnHeader: "Location"),
            ],
          ),
        );
        await Future.delayed(const Duration(milliseconds: 50));
      }
    }

    if (excelDataRows.isEmpty) {
      customSnackBar(
        title: AppStrings.textInfo,
        message: 'There is no data to export for the selected locations',
        alertType: AlertType.alertMessage,
      );
      return;
    }

    String fileName =
        "EaseOps_${selectedLocationDDValue.join(', ')}_Attendance_Report_${formatDateToddMMyyyy(selectedDate.value)}.xlsx";

    await generateExcel(fileName: fileName, dataRows: excelDataRows);
  }

//Generate Summary Excel

  Map<String, dynamic> aggregateLocationData(String locationId) {
    int totalEmployees = 0;
    int totalPresentDays = 0;
    int totalAbsentDays = 0;
    int totalHoursWorked = 0;

    List<AttendanceReportUserModel>? locationData =
        locationAttendanceData[locationId];

    if (locationData != null) {
      totalEmployees = locationData.length;

      Set<String> uniquePresentDays = {};

      for (var report in locationData) {
        if (report.attendanceList != null) {
          for (var attendance in report.attendanceList!) {
            if (attendance.location?.id == locationId) {
              if (attendance.sessionList != null) {
                for (var session in attendance.sessionList!) {
                  if (session.checkinAt != null) {
                    String presentDate =
                        formatDateToYDashMMDashD(session.checkinAt!);
                    uniquePresentDays.add(presentDate);
                  }
                }
              }

              totalHoursWorked += attendance.totalTimeSpentInMinutes ?? 0;
            }
          }
        }
      }

      totalPresentDays = uniquePresentDays.length;

      int daysInMonth =
          DateTime(startDateTime.value.year, startDateTime.value.month + 1, 0)
              .day;

      totalAbsentDays = (totalEmployees * daysInMonth) - totalPresentDays;
    }

    double percentageAttendance = totalEmployees > 0
        ? (totalPresentDays / (totalEmployees * 30)) * 100
        : 0.0;

    return {
      'totalEmployees': totalEmployees,
      'totalPresentDays': totalPresentDays,
      'totalAbsentDays': totalAbsentDays,
      'totalHoursWorked': totalHoursWorked,
      'percentageAttendance': percentageAttendance.toStringAsFixed(2),
    };
  }

  String formatMonthSummary(DateTime date) {
    return "${DateFormat('MMMM').format(date)} Summary";
  }

  Future<void> getMonthlyAttendanceDataForAllLocations() async {
    startDateTime.value =
        DateTime(selectedDate.value.year, selectedDate.value.month, 1, 0, 0, 0);
    endDateTime.value =
        DateTime(selectedDate.value.year, selectedDate.value.month + 1, 1)
            .subtract(
      const Duration(seconds: 1),
    );
    for (var location in locListData) {
      await apiService
          .getResponse(
        endpoint:
            '${ApiEndPoints.apiAttendanceUserData}?utc_from_dt=${formatDateToYDashMMDashD(startDateTime.value)} 00:00:00&utc_till_dt=${formatDateToYDashMMDashD(endDateTime.value)} 23:59:59&location_id_list=${location.id}',
        token: AppPreferences.getUserData()!.token,
      )
          .then(
        (value) {
          if (value != null) {
            List<AttendanceReportUserModel> locationData = [];
            for (var index = 0; index < value.length; index++) {
              locationData
                  .add(AttendanceReportUserModel.fromJson(value[index]));
            }
            locationAttendanceData[location.id!] = locationData;
          } else {
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
  }

  Future<void> allAttendanceExcel() async {
    await getMonthlyAttendanceDataForAllLocations();
    if (locationAttendanceData.isEmpty) {
      customSnackBar(
        title: AppStrings.textInfo,
        message: 'There is no data to export',
        alertType: AlertType.alertMessage,
      );
      return;
    }

    final workbook = xlsio.Workbook();

    final xlsio.Style headerStyle = workbook.styles.add('HeaderStyle');
    headerStyle.hAlign = xlsio.HAlignType.center;
    headerStyle.vAlign = xlsio.VAlignType.center;
    headerStyle.wrapText = true;
    headerStyle.bold = true;

    final xlsio.Style dataStyle = workbook.styles.add('DataStyle');
    dataStyle.hAlign = xlsio.HAlignType.center;
    dataStyle.vAlign = xlsio.VAlignType.center;
    dataStyle.wrapText = true;

    final summarySheet = workbook.worksheets[0];
    summarySheet.name = formatMonthSummary(startDateTime.value);
    List<xlsio.ExcelDataRow> summaryRows = <xlsio.ExcelDataRow>[];
    num grandTotalEmployees = 0;
    num grandTotalPresentDays = 0;
    num grandTotalAbsentDays = 0;
    num grandTotalHoursWorked = 0;

    final xlsio.Style grandTotalStyle = workbook.styles.add('GrandTotalStyle');
    grandTotalStyle.hAlign = xlsio.HAlignType.center;
    grandTotalStyle.vAlign = xlsio.VAlignType.center;
    grandTotalStyle.wrapText = true;
    grandTotalStyle.bold = true;
    for (var location in locListData) {
      var aggregatedData = aggregateLocationData(location.id!);

      summaryRows.add(
        xlsio.ExcelDataRow(cells: <xlsio.ExcelDataCell>[
          xlsio.ExcelDataCell(
              value: location.name, columnHeader: "Location Name"),
          xlsio.ExcelDataCell(
              value: aggregatedData['totalPresentDays'],
              columnHeader: "Total Present Days"),
          xlsio.ExcelDataCell(
              value: aggregatedData['totalAbsentDays'],
              columnHeader: "Total Absent Days"),
          xlsio.ExcelDataCell(
              value: formatMinutesToHours(aggregatedData['totalHoursWorked']),
              columnHeader: "Total Hours Worked"),
          xlsio.ExcelDataCell(
              value: aggregatedData['totalEmployees'],
              columnHeader: "Total Employees"),
          xlsio.ExcelDataCell(
              value: '${aggregatedData['percentageAttendance']}%',
              columnHeader: "Percentage Attendance"),
        ]),
      );
      grandTotalEmployees += aggregatedData['totalEmployees'];
      grandTotalPresentDays += aggregatedData['totalPresentDays'];
      grandTotalAbsentDays += aggregatedData['totalAbsentDays'];
      grandTotalHoursWorked += aggregatedData['totalHoursWorked'];
    }

    summaryRows.add(
      xlsio.ExcelDataRow(cells: <xlsio.ExcelDataCell>[
        const xlsio.ExcelDataCell(
            value: 'Grand Total', columnHeader: "Location Name"),
        xlsio.ExcelDataCell(
            value: grandTotalPresentDays, columnHeader: "Total Present Days"),
        xlsio.ExcelDataCell(
            value: grandTotalAbsentDays, columnHeader: "Total Absent Days"),
        xlsio.ExcelDataCell(
            value: formatMinutesToHours(grandTotalHoursWorked.toInt()),
            columnHeader: "Total Hours Worked"),
        xlsio.ExcelDataCell(
            value: grandTotalEmployees, columnHeader: "Total Employees"),
      ]),
    );

    summarySheet.importData(summaryRows, 1, 1);
    int summaryRowCount = summaryRows.length + 1;
    int summaryColumnCount = 6;
    summarySheet.getRangeByIndex(1, 1, 1, summaryColumnCount).cellStyle =
        headerStyle;
    summarySheet
        .getRangeByIndex(2, 1, summaryRowCount, summaryColumnCount)
        .cellStyle = dataStyle;
    summarySheet
        .getRangeByIndex(
            summaryRowCount, 1, summaryRowCount, summaryColumnCount)
        .cellStyle = grandTotalStyle;

    for (int col = 1; col <= summaryColumnCount; col++) {
      double maxColumnWidth = 10;
      String? headerValue = summarySheet.getRangeByIndex(1, col).text;
      if (headerValue != null && headerValue.length > maxColumnWidth) {
        maxColumnWidth = headerValue.length.toDouble();
      }

      for (int row = 2; row <= summaryRowCount; row++) {
        String? cellValue = summarySheet.getRangeByIndex(row, col).text;
        if (cellValue != null && cellValue.length > maxColumnWidth) {
          maxColumnWidth = cellValue.length.toDouble();
        }
      }

      summarySheet.getRangeByIndex(1, col, summaryRowCount, col).columnWidth =
          maxColumnWidth + 5;
    }

    for (var location in locListData) {
      final locationSheet = workbook.worksheets.addWithName(location.name!);
      List<xlsio.ExcelDataRow> locationRows = <xlsio.ExcelDataRow>[];

      List<AttendanceReportUserModel>? locationData =
          locationAttendanceData[location.id!];

      if (locationData != null) {
        DateFormat dateFormatter = DateFormat('dd-MM-yyyy');
        int numberOfDaysInMonth =
            endDateTime.value.difference(startDateTime.value).inDays + 1;

        List<int> totalPresentPerDay = List.filled(numberOfDaysInMonth, 0);
        int grandTotalPresentDays = 0;

        for (var report in locationData) {
          String userName = report.user?.name ?? '-';
          List<int> presentDays = List.filled(numberOfDaysInMonth, 0);
          Set<int> uniquePresentDays = {};

          if (report.attendanceList != null) {
            for (var attendance in report.attendanceList!) {
              if (attendance.location?.id == location.id) {
                Set<int> dayPresenceTracker = {};
                if (attendance.sessionList != null &&
                    attendance.sessionList!.isNotEmpty) {
                  for (var session in attendance.sessionList!) {
                    if (session.checkinAt != null) {
                      var dayIndex = session.checkinAt!
                          .difference(startDateTime.value)
                          .inDays;
                      if (dayIndex >= 0 &&
                          dayIndex < presentDays.length &&
                          !dayPresenceTracker.contains(dayIndex)) {
                        presentDays[dayIndex] = 1;
                        dayPresenceTracker.add(dayIndex);
                        totalPresentPerDay[dayIndex]++;
                        uniquePresentDays.add(dayIndex);
                      }
                    }
                  }
                }
              }
            }
          }

          int totalPresentDays = uniquePresentDays.length;
          grandTotalPresentDays += totalPresentDays;

          locationRows.add(
            xlsio.ExcelDataRow(
              cells: <xlsio.ExcelDataCell>[
                xlsio.ExcelDataCell(value: userName, columnHeader: "Name"),
                xlsio.ExcelDataCell(
                    value: totalPresentDays,
                    columnHeader: "Total Present Days"),
                ...List.generate(
                  presentDays.length,
                  (i) => xlsio.ExcelDataCell(
                    value: presentDays[i],
                    columnHeader: dateFormatter
                        .format(startDateTime.value.add(Duration(days: i))),
                  ),
                ),
              ],
            ),
          );
        }

        // Add the total row
        locationRows.add(
          xlsio.ExcelDataRow(
            cells: <xlsio.ExcelDataCell>[
              const xlsio.ExcelDataCell(value: "Total", columnHeader: "Total"),
              xlsio.ExcelDataCell(
                  value: grandTotalPresentDays,
                  columnHeader: "Total Present Days"),
              ...List.generate(
                totalPresentPerDay.length,
                (i) => xlsio.ExcelDataCell(
                  value: "${totalPresentPerDay[i]} present",
                  columnHeader: dateFormatter
                      .format(startDateTime.value.add(Duration(days: i))),
                ),
              ),
            ],
          ),
        );

        locationSheet.importData(locationRows, 1, 1);
        int locationRowCount = locationRows.length + 1;
        int locationColumnCount = numberOfDaysInMonth + 2;

        locationSheet.getRangeByIndex(1, 1, 1, locationColumnCount).cellStyle =
            headerStyle;
        locationSheet
            .getRangeByIndex(2, 1, locationRowCount, locationColumnCount)
            .cellStyle = dataStyle;
        locationSheet
            .getRangeByIndex(
                locationRowCount, 1, locationRowCount, locationColumnCount)
            .cellStyle = grandTotalStyle;
        for (int col = 1; col <= locationColumnCount; col++) {
          double maxColumnWidth = 10;

          String? headerValue = locationSheet.getRangeByIndex(1, col).text;
          if (headerValue != null && headerValue.length > maxColumnWidth) {
            maxColumnWidth = headerValue.length.toDouble();
          }

          for (int row = 2; row <= locationRowCount; row++) {
            String? cellValue = locationSheet.getRangeByIndex(row, col).text;
            if (cellValue != null && cellValue.length > maxColumnWidth) {
              maxColumnWidth = cellValue.length.toDouble();
            }
          }

          locationSheet
              .getRangeByIndex(1, col, locationRowCount, col)
              .columnWidth = maxColumnWidth + 5;
        }
      } else {
        locationSheet.importData([
          const xlsio.ExcelDataRow(cells: <xlsio.ExcelDataCell>[
            xlsio.ExcelDataCell(
                value: "No data available", columnHeader: "Message"),
          ])
        ], 1, 1);
      }
    }

    String fileName =
        "EaseOps_AllLocation_${formatDateToMMMM(startDateTime.value)}.xlsx";
    List<int> bytes = workbook.saveAsStream();
    storeToFileStorage(fileName: fileName, bytes: bytes);
    workbook.dispose();
  }

  void resetData() {
    selectPunchInDateController.clear();
    selectPunchInTimeController.clear();
    selectPunchOutDateController.clear();
    selectPunchOutTimeController.clear();
    textCommentController.clear();
    checkoutImageUploadController.clear();
    checkinImageUploadController.clear();
    selectedPunchInTime.value = TimeOfDay.now();
    selectedPunchOutTime.value = TimeOfDay.now();
    errPunchInDate.value = '';
    errPunchInTime.value = '';
    errPunchOutDate.value = '';
    errPunchOutTime.value = '';
    errComment.value = '';
    checkinImageList.clear();
    checkoutImageList.clear();
    errImageUpload.value = '';
    isExport = true.obs;
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

  Future<void> getLocalTimezone() async {
    userLocalTimeZone.value =
        await FlutterTimezone.getLocalTimezone() == 'Asia/Calcutta'
            ? 'Asia/Kolkata'
            : await FlutterTimezone.getLocalTimezone();
  }
}

Widget customText({
  required String title,
  bool isHeader = false,
  TextAlign? textAlign,
  String? status,
  Color? color,
  int? line,
}) {
  return Text(
    title,
    style: GoogleFonts.inter(
      fontSize: 14,
      color: color ??
          (isHeader
              ? AppColors.kcWhiteColor
              : status == 'Missed'
                  ? AppColors.kcFailedColor
                  : status == 'Submitted'
                      ? AppColors.kcSuccessColor
                      : status == 'Not_Started'
                          ? AppColors.kcPrimaryColor
                          : AppColors.kcBlackColor),
      fontWeight: FontWeight.w400,
    ),
    maxLines: line,
    textAlign: textAlign,
    overflow: TextOverflow.ellipsis,
  );
}
