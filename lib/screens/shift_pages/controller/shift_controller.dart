import 'package:easeops_web_hrms/app_export.dart';
import 'package:easeops_web_hrms/screens/shift_pages/model/shift_model.dart';
import 'package:easeops_web_hrms/widgets/custom_time_picker.dart';
import 'package:intl/intl.dart';

class ShiftController extends GetxController {
  RxBool isLoading = false.obs;
  final formKey = GlobalKey<FormState>();
  final NetworkApiService _apiService = NetworkApiService();
  RxList<ShiftDataModel> getShiftListModelResponse = <ShiftDataModel>[].obs;
  RxList<Map<String, dynamic>> shiftTableData = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> userListData = <Map<String, dynamic>>[].obs;
  RxList<String> selectedUserIds = <String>[].obs;
  TextEditingController textNameController = TextEditingController();
  TextEditingController textStartTimeController = TextEditingController();
  TextEditingController textEndTimeController = TextEditingController();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  RxString errName = ''.obs;
  RxString errStartTime = ''.obs;
  RxString errEndTime = ''.obs;
  RxString errUser = ''.obs;
  RxInt currentStep = 0.obs;

  void setShiftData() {
    shiftTableData.clear();
    for (var data in getShiftListModelResponse) {
      startTime = stringToTimeOfDay(data.startTime ?? '');
      endTime = stringToTimeOfDay(data.endTime ?? '');
      final startFormat = startTime.format(Get.context!);
      final endFormat = endTime.format(Get.context!);
      final uniqueAssignedUsers = (data.userList ?? []).toSet().toList();
      shiftTableData.add({
        'name': data.name ?? '',
        'start_data': data.startTime ?? '',
        'start_time': startFormat,
        'end_data': data.endTime ?? '',
        'end_time': endFormat,
        'id': data.id,
        'users_list': uniqueAssignedUsers,
      });
    }
    isLoading.value = false;
  }

  Future<void> getShiftListAPIData() async {
    isLoading.value = true;
    await _apiService
        .getResponse(
      endpoint: ApiEndPoints.apiShiftData,
      token: AppPreferences.getUserData()!.token,
    )
        .then((value) async {
      if (value != null) {
        getShiftListModelResponse.clear();
        for (var i = 0; i < value.length; i++) {
          getShiftListModelResponse.add(ShiftDataModel.fromJson(value[i]));
        }
        setShiftData();
        await getUserListAPIData();
      } else {
        isLoading.value = false;
        customSnackBar(
          title: AppStrings.textError,
          message: AppStrings.textErrorMessage,
          alertType: AlertType.alertError,
        );
      }
    }).catchError((err) {
      isLoading.value = false;
      customSnackBar(
        title: AppStrings.textError,
        message: AppStrings.textErrorMessage,
        alertType: AlertType.alertError,
      );
    });
  }

  void onRowAssignedUserTap({required List<AssignedUser> rowUser}) {
    customShowDataDialog(title: 'Assigned Users', data: rowUser);
  }

  Future<void> getUserListAPIData() async {
    isLoading.value = true;
    await _apiService
        .getResponse(
      endpoint: ApiEndPoints.apiUser,
      token: AppPreferences.getUserData()!.token,
    )
        .then((value) {
      if (value != null) {
        final data = getUserModelFromJson(jsonEncode(value));
        userListData.clear();
        for (var i = 0; i < data.length; i++) {
          userListData.add({'id': data[i].id, 'label': data[i].name});
        }
      }
      isLoading.value = false;
    }).catchError((err) {
      isLoading.value = false;
      customSnackBar(
        title: AppStrings.textError,
        message: AppStrings.textErrorMessage,
        alertType: AlertType.alertError,
      );
    });
    isLoading.value = false;
  }

  Future<void> onCreateShiftTap({
    required bool isUpdate,
    Map<String?, dynamic>? rowData,
  }) async {
    var shiftName = '';
    if (isUpdate) {
      shiftName = rowData!['name'];
    }
    await customAddDialog(
      title: isUpdate
          ? currentStep.value == 1
              ? 'Assign $shiftName to User'
              : 'Edit Shift'
          : 'Create shift',
      items: Obx(
        () => currentStep.value == 0
            ? Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResponsiveFormLayout(
                      childPerRow: 3,
                      children: [
                        CustomTextFormField(
                          isFillKcLightGrey: true,
                          txtFormWidth: 230,
                          title: 'Name',
                          errorMsg: errName.value,
                          textEditingController: textNameController,
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
                        ),
                        CustomTextFormField(
                          isFillKcLightGrey: true,
                          txtFormWidth: 230,
                          title: 'Start Time',
                          errorMsg: errStartTime.value,
                          textEditingController: textStartTimeController,
                          validatorCallback: (val) {
                            errStartTime.value = validateEmptyData(val,
                                    fieldName: 'Start Time') ??
                                '';
                            return null;
                          },
                          onChangedCallBack: (val) {
                            errStartTime.value = validateEmptyData(val,
                                    fieldName: 'Start Time') ??
                                '';
                            return null;
                          },
                          isReadOnly: true,
                          onTapCallback: () async {
                            await customSelectTime(
                              selectedTime: TimeOfDay.now(),
                            ).then(
                              (value) {
                                errStartTime.value = '';
                                if (value == null) {
                                  errStartTime.value = validateEmptyData(
                                        null,
                                        fieldName: 'Start Time',
                                      ) ??
                                      '';
                                  return;
                                }
                                startTime = value;
                                final time = value.format(Get.context!);
                                textStartTimeController.text = time;
                              },
                            );
                          },
                          paddingVertical: 14,
                        ),
                        CustomTextFormField(
                          isFillKcLightGrey: true,
                          txtFormWidth: 230,
                          title: 'End Time',
                          errorMsg: errEndTime.value,
                          textEditingController: textEndTimeController,
                          validatorCallback: (val) {
                            errEndTime.value =
                                validateEmptyData(val, fieldName: 'End Time') ??
                                    '';
                            return null;
                          },
                          onChangedCallBack: (val) {
                            errEndTime.value =
                                validateEmptyData(val, fieldName: 'End Time') ??
                                    '';
                            return null;
                          },
                          isReadOnly: true,
                          onTapCallback: () async {
                            await customSelectTime(
                              selectedTime: TimeOfDay.now(),
                            ).then(
                              (value) {
                                errEndTime.value = '';
                                if (value == null) {
                                  errEndTime.value = validateEmptyData(
                                        null,
                                        fieldName: 'End Time',
                                      ) ??
                                      '';
                                  return;
                                }
                                endTime = value;
                                final time = value.format(Get.context!);
                                textEndTimeController.text = time;
                              },
                            );
                          },
                          paddingVertical: 14,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResponsiveFormLayout(
                      childPerRow: 2,
                      children: [
                        SizedBox(
                          height: 70,
                          width: 240,
                          child: MultiSelectDropdownSchedule(
                            isOnTapValid: true,
                            list: userListData,
                            includeSearch: true,
                            includeSelectAll: true,
                            initiallySelected: userListData
                                .where(
                                  (item) =>
                                      selectedUserIds.contains(item['id']),
                                )
                                .toList(),
                            width: 240,
                            height: 40,
                            title: 'Users',
                            errorMsg: errUser.value,
                            onChange: (newList) {
                              selectedUserIds.clear();
                              if (newList.isNotEmpty) {
                                for (final data in newList) {
                                  selectedUserIds.add(data['id']);
                                }
                              }
                              errUser.value = selectedUserIds.toList().isEmpty
                                  ? 'Please Select Users'
                                  : '';
                            },
                            whenEmpty: 'User(s)',
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
        Obx(
          () => CustomElevatedButton(
            btnHeight: btnHeight,
            btnColor: checkIsItValid()
                ? AppColors.kcHeaderButtonColor
                : AppColors.kcHeaderButtonColor.withOpacity(0.3),
            btnText: isUpdate
                ? currentStep.value == 1
                    ? 'Assign Shift'
                    : 'Update '
                : 'Create shift',
            btnPressed: () async {
              errUser.value =
                  selectedUserIds.toList().isEmpty ? 'Please Select Users' : '';
              if (!formKey.currentState!.validate()) {
                return;
              }
              if (!checkIsItValid()) {
                return;
              }
              onCreateShiftAPICall(rowData: rowData, isUpdate: isUpdate);
              formKey.currentState!.save();
            },
            borderRadius: btnBorderRadius,
          ),
        ),
      ],
    );
  }

  bool checkIsItValid() {
    if (currentStep.value == 0 &&
        textNameController.text != '' &&
        errName.value == '' &&
        textStartTimeController.text != '' &&
        errStartTime.value == '' &&
        textEndTimeController.text != '' &&
        errEndTime.value == '') {
      return true;
    } else if (currentStep.value == 1 &&
        (selectedUserIds.toList().isNotEmpty)) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> onCreateShiftAPICall({
    Map<String?, dynamic>? rowData,
    required bool isUpdate,
  }) async {
    isLoading.value = true;
    DateTime now = DateTime.now();
    DateTime startDateTime = DateTime(
        now.year, now.month, now.day, startTime.hour, startTime.minute);
    DateTime endDateTime =
        DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute);
    String startFormattedTime =
        DateFormat("HH:mm:ss.SSS'Z'").format(startDateTime);
    String endFormattedTime = DateFormat("HH:mm:ss.SSS'Z'").format(endDateTime);

    var id = '';
    if (rowData != null) {
      id = rowData['id'];
    }
    if (!isUpdate) {
      selectedUserIds.clear();
    }
    final shiftCreateMap = <String, dynamic>{
      "name": textNameController.text.trim(),
      "start_time": startFormattedTime,
      "end_time": endFormattedTime,
      "user_id_list": selectedUserIds.toList(),
    };
    try {
      final result = isUpdate
          ? await _apiService.putResponse(
              endpoint: '${ApiEndPoints.apiShiftData}/$id',
              token: AppPreferences.getUserData()!.token,
              postBody: shiftCreateMap,
            )
          : await _apiService.postResponse(
              endpoint: ApiEndPoints.apiShiftData,
              token: AppPreferences.getUserData()!.token,
              postBody: shiftCreateMap,
            );
      if (result != null) {
        Get.back<void>();
        customSnackBar(
          title: AppStrings.textSuccess,
          message:
              'Shift (${textNameController.text}) is ${isUpdate ? 'updated' : 'created'}!',
          alertType: AlertType.alertMessage,
        );
        resetData();
        await getShiftListAPIData();
      } else {
        customSnackBar(
          title: AppStrings.textError,
          message: AppStrings.textErrorMessage,
          alertType: AlertType.alertError,
        );
        isLoading.value = false;
      }
    } catch (e) {
      customSnackBar(
        title: AppStrings.textError,
        message: AppStrings.textErrorMessage,
        alertType: AlertType.alertError,
      );
      isLoading.value = false;
    }
  }

  void onRowEditOptionTap({required Map<String?, dynamic> rowData}) {
    textNameController.text = rowData['name'] ?? '';
    startTime = stringToTimeOfDay(rowData['start_data']);
    endTime = stringToTimeOfDay(rowData['end_data']);
    final startFormat = startTime.format(Get.context!);
    textStartTimeController.text = startFormat;
    final endFormat = endTime.format(Get.context!);
    textEndTimeController.text = endFormat;
    selectedUserIds.clear();
    for (final data in rowData['users_list'].toList()) {
      selectedUserIds.add(data['id'].toString());
    }
    onCreateShiftTap(isUpdate: true, rowData: rowData);
  }

  TimeOfDay stringToTimeOfDay(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    return TimeOfDay(hour: hour, minute: minute);
  }

  Future<void> onRowDeleteOptionTap({
    required Map<String?, dynamic> rowData,
  }) async {
    final id = rowData['id'] ?? '';
    if (id != '') {
      await customAddDialog(
        title: '',
        items: deleteDialogItem(
          title: rowData['name'] ?? '',
          subTitle: 'shift',
        ),
        btnTitle1: AppStrings.btnClose,
        btnTitle: 'Delete Shift',
        onBtnCallback: () async {
          isLoading.value = true;
          try {
            final responseDel = await _apiService.deleteResponse(
              endpoint: '${ApiEndPoints.apiShiftData}/$id',
              token: AppPreferences.getUserData()!.token,
            );
            if (responseDel) {
              Get.back<void>();
              customSnackBar(
                title: AppStrings.textSuccess,
                message: 'Shift ${rowData['name']} is Deleted Successfully!',
                alertType: AlertType.alertMessage,
              );
              await getShiftListAPIData();
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

  void resetData() {
    textNameController.text = '';
    textStartTimeController.text = '';
    textEndTimeController.text = '';
    startTime = TimeOfDay.now();
    endTime = TimeOfDay.now();
    errName.value = '';
    errStartTime.value = '';
    errEndTime.value = '';
    selectedUserIds.clear();
  }
}
