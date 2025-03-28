import 'package:easeops_web_hrms/app_export.dart';

class ConfigUserController extends GetxController {
  final NetworkApiService _apiService = NetworkApiService();
  final formKey = GlobalKey<FormState>();
  RxList<GetUserModel> getUserModelResponse = <GetUserModel>[].obs;
  RxList<Map<String, dynamic>> usersDataTableData =
      <Map<String, dynamic>>[].obs;
  TextEditingController textNameController = TextEditingController();
  TextEditingController textEmailController = TextEditingController();
  final TextEditingController textPasswordController = TextEditingController();
  final TextEditingController textConfirmPasswordController =
      TextEditingController();
  RxBool isUserLoading = true.obs;
  RxList<Map<String, dynamic>> roleListData = <Map<String, dynamic>>[].obs;

  RxString selectedRoleDDValue = ''.obs;
  RxString selectedRoleId = ''.obs;
  RxList<Map<String, dynamic>> locationListData = <Map<String, dynamic>>[].obs;
  RxList<String> selectedLocationIds = <String>[].obs;
  RxString errName = ''.obs;
  RxString errEmail = ''.obs;
  RxString errRole = ''.obs;
  RxString errLocation = ''.obs;
  RxString errPassword = ''.obs;
  RxString errCPassword = ''.obs;
  RxBool isLoading = false.obs;
  RxBool isValid = false.obs;
  RxString selSearchRoleDDValue = ''.obs;

  void onRowRoleTap({required List<Role> rowRole}) {
    customShowDataDialog(title: 'Roles', data: rowRole);
  }

  void onRowLocationTap({required List<Location> rowLocation}) {
    customShowDataDialog(title: 'Assigned Location', data: rowLocation);
  }

  void onRowCheckListTap({required List<UserCheckList> rowChecklist}) {
    customShowDataDialog(title: 'CheckList', data: rowChecklist);
  }

  Future<void> onRowResendEmailTap({
    required Map<String?, dynamic> rowData,
  }) async {
    final id = rowData['email'] ?? '';
    if (id != '') {
      isLoading.value = true;
      try {
        final responseResend = await _apiService.postResponse(
          endpoint: '${ApiEndPoints.apiPwd}/$id/resend-verification',
          token: AppPreferences.getUserData()!.token,
          isReturnBool: true,
        );
        if (responseResend) {
          customSnackBar(
            title: AppStrings.textSuccess,
            message: 'Email Resend Successfully!',
            alertType: AlertType.alertMessage,
          );
          getUserAPIData();
        } else {
          customSnackBar(
            title: AppStrings.textError,
            message: "Sorry it didn't sent. Try Again!",
            alertType: AlertType.alertError,
          );
          isLoading.value = false;
        }
      } catch (e) {
        isLoading.value = false;
        customSnackBar(
          title: AppStrings.textError,
          message: AppStrings.textErrorMessage,
          alertType: AlertType.alertError,
        );
      }
    }
  }

  Future<void> getInitialAPIData() async {
    await _apiService
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
    await _apiService
        .getResponse(
      endpoint: ApiEndPoints.apiLocation,
      token: AppPreferences.getUserData()!.token,
    )
        .then((value) {
      if (value != null) {
        final data = locationListModelFromJson(jsonEncode(value));
        locationListData.clear();
        for (var i = 0; i < data.length; i++) {
          locationListData.add({'id': data[i].id, 'label': data[i].name});
        }
      }
    });
    getUserAPIData();
  }

  void setUserData() {
    usersDataTableData.clear();
    for (final data in getUserModelResponse.toList()) {
      usersDataTableData.add({
        'name': data.name ?? '',
        'email': data.email ?? '',
        'access': data.id ?? '',
        'roles': data.roles ?? [],
        'is_verified': data.isVerified ?? true,
        'locations': data.locations ?? [],
        'action': data.id,
        'data': data,
      });
    }
    Future.delayed(const Duration(milliseconds: 200), () {
      isUserLoading.value = false;
    });
  }

  Future<void> getUserAPIData() async {
    isUserLoading.value = true;
    _apiService
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
        setUserData();
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

  Future<void> resetByAdminDailog(
      {required Map<String?, dynamic> rowData}) async {
    await customAddDialog(
      title: 'Set Password',
      items: Form(
        child: Obx(
          () => ResponsiveFormLayout(
            childPerRow: 2,
            children: [
              CustomTextFormField(
                txtFormWidth: formWidth,
                isFillKcLightGrey: true,
                validatorCallback: (val) {
                  errPassword.value =
                      validateEmptyData(val, fieldName: 'password') ?? '';
                  return null;
                },
                onChangedCallBack: (val) {
                  errPassword.value =
                      validateEmptyData(val, fieldName: 'password') ?? '';
                  return null;
                },
                paddingVertical: verticalPadding,
                textEditingController: textPasswordController,
                title: 'Password',
              ),
              CustomTextFormField(
                txtFormWidth: formWidth,
                isFillKcLightGrey: true,
                errorMsg: errPassword.value,
                validatorCallback: (val) {
                  errCPassword.value =
                      validateEmptyData(val, fieldName: 'Confirm password') ??
                          '';
                  return null;
                },
                onChangedCallBack: (val) {
                  errCPassword.value =
                      validateEmptyData(val, fieldName: 'Confirm password') ??
                          '';
                  return null;
                },
                paddingVertical: verticalPadding,
                textEditingController: textConfirmPasswordController,
                title: 'Confirm Password',
              )
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
          btnText: 'Confirm',
          btnColor: AppColors.kcHeaderButtonColor,
          btnPressed: () {
            if (textPasswordController.value.text ==
                textConfirmPasswordController.value.text) {
              onResetByAdminApi(
                  userId: rowData['action'], name: rowData['name']);
              resetData();
            } else {
              errPassword.value = 'Password and confirm password must be same';
            }
          },
        ),
      ],
    );
  }

  Future<void> onResetByAdminApi({required String userId, String? name}) async {
    // isLoading.value = true;
    final resetByAdminMap = <String, dynamic>{
      'user_id': userId,
      'new_password': textPasswordController.value.text.trim(),
    };
    try {
      final result = await _apiService.postResponse(
        endpoint: ApiEndPoints.apiResetByAdmin,
        token: AppPreferences.getUserData()!.token,
        postBody: resetByAdminMap,
        isReturnBool: true,
      );
      Get.back<void>();
      if (result != null) {
        customSnackBar(
          title: AppStrings.textSuccess,
          message: 'User $name password set successfully.',
          alertType: AlertType.alertMessage,
        );
        resetData();
      } else {
        customSnackBar(
          title: AppStrings.textError,
          message: AppStrings.textErrorMessage,
          alertType: AlertType.alertError,
        );
        // isLoading.value = false;
      }
    } catch (e) {
      customSnackBar(
        title: AppStrings.textError,
        message: '${AppStrings.textErrorMessage} $e',
        alertType: AlertType.alertError,
      );
      // isLoading.value = false;
    }
  }

  String? getLocationName({required String locationId}) {
    for (var location in locationListData.toList()) {
      if (location['id'] == locationId) {
        return location['label'];
      }
    }
    return null;
  }

  Future<void> onCreateUserTap({
    required bool isUpdate,
    Map<String?, dynamic>? rowData,
  }) async {
    if (!isUpdate) {
      resetData();
    }
    await customAddDialog(
      title: isUpdate ? 'Edit User' : 'Create User',
      items: Form(
        key: formKey,
        child: Obx(
          () => Column(
            children: [
              ResponsiveFormLayout(
                childPerRow: 4,
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
                      errEmail.value = validateEmail(val) ?? '';
                      return null;
                    },
                    onChangedCallBack: (val) {
                      errEmail.value = validateEmail(val) ?? '';
                      return null;
                    },
                    paddingVertical: 14,
                    textEditingController: textEmailController,
                  ),
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
                      list: locationListData.toList(),
                      initiallySelected: locationListData
                          .toList()
                          .where((item) =>
                              selectedLocationIds.contains(item['id']))
                          .toList(),
                      width: 240,
                      height: 40,
                      title: 'Location',
                      errorMsg: errLocation.value,
                      onChange: (newList) async {
                        selectedLocationIds.clear();
                        if (newList.isNotEmpty) {
                          for (final data in newList) {
                            selectedLocationIds.add(data['id']);
                          }
                        }
                        errLocation.value = selectedLocationIds.toList().isEmpty
                            ? 'Please select location'
                            : '';
                      },
                      whenEmpty: 'Location(s)',
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
            btnText: isUpdate ? 'Update' : 'Create User',
            btnPressed: () async {
              errRole.value =
                  selectedRoleId.value == '' ? 'Please select role' : '';
              errLocation.value = selectedLocationIds.toList().isEmpty
                  ? 'Please select location'
                  : '';
              if (!formKey.currentState!.validate()) {
                return;
              }
              if (!checkIsItValid()) {
                return;
              }
              isUpdate
                  ? await onUpdateUserAPICall(rowData: rowData)
                  : await onCreateUserAPICall();
              formKey.currentState!.save();
            },
            borderRadius: btnBorderRadius,
          ),
        ),
      ],
    );
  }

  bool checkIsItValid() {
    return errName.value == '' &&
        textNameController.text.trim().isNotEmpty &&
        errLocation.value == '' &&
        errEmail.value == '' &&
        textEmailController.text.trim().isNotEmpty &&
        selectedRoleDDValue.value != '' &&
        selectedLocationIds.isNotEmpty;
  }

  Future<void> onCreateUserAPICall() async {
    isLoading.value = true;
    final userCreateMap = <String, dynamic>{
      'name': textNameController.text.trim(),
      'email': textEmailController.text.trim().isEmpty
          ? null
          : textEmailController.text.trim(),
      'roles': [selectedRoleId.value],
      'locations': selectedLocationIds.toList(),
    };
    try {
      final result = await _apiService.postResponse(
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
        getUserAPIData();
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
        message: '${AppStrings.textErrorMessage} $e',
        alertType: AlertType.alertError,
      );
      isLoading.value = false;
    }
  }

  Future<void> onRowEditOptionTap(
      {required Map<String?, dynamic> rowData}) async {
    selectedLocationIds.clear();
    textNameController.text = rowData['name'] ?? '';
    textEmailController.text = rowData['email'] ?? '';
    for (final data in rowData['roles'] as List<Role>) {
      selectedRoleDDValue.value = data.popupData ?? '';
      selectedRoleId.value = data.id ?? '';
    }
    for (final data in rowData['locations'] as List<Location>) {
      selectedLocationIds.add(data.id.toString());
    }
    await onCreateUserTap(isUpdate: true, rowData: rowData);
  }

  Future<void> onUpdateUserAPICall({
    required Map<String?, dynamic>? rowData,
  }) async {
    if (rowData != null) {
      isLoading.value = true;
      final id = rowData['action'] ?? '';
      if (id != '') {
        final userPutMapData = <String, dynamic>{
          'name': textNameController.text.trim(),
          'email': textEmailController.text.trim().isEmpty
              ? null
              : textEmailController.text.trim(),
          'roles': [selectedRoleId.value],
          'locations': selectedLocationIds.toList(),
        };
        try {
          final result = await _apiService.putResponse(
            endpoint: '${ApiEndPoints.apiUser}/$id',
            postBody: userPutMapData,
            token: AppPreferences.getUserData()!.token,
          );
          if (result != null) {
            Get.back<void>();
            customSnackBar(
              title: AppStrings.textSuccess,
              message: 'User (${textNameController.text}) is updated!',
              alertType: AlertType.alertMessage,
            );
            resetData();
            getUserAPIData();
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
  }

  Future<void> onRowDeleteOptionTap({
    required Map<String?, dynamic> rowData,
  }) async {
    final id = rowData['action'] ?? '';
    if (id != '') {
      await customAddDialog(
        title: '',
        items: deleteDialogItem(title: rowData['name'], subTitle: 'User'),
        btnTitle1: AppStrings.btnClose,
        btnTitle: 'Delete User',
        onBtnCallback: () async {
          isLoading.value = true;
          try {
            final responseDel = await _apiService.deleteResponse(
              endpoint: '${ApiEndPoints.apiUser}/$id',
              token: AppPreferences.getUserData()!.token,
            );
            if (responseDel) {
              Get.back<void>();
              customSnackBar(
                title: AppStrings.textSuccess,
                message: 'User is Deleted Successfully!',
                alertType: AlertType.alertMessage,
              );
              getUserAPIData();
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
    textNameController.clear();
    textEmailController.clear();
    textPasswordController.clear();
    textConfirmPasswordController.clear();
    errPassword.value = '';
    errCPassword.value = '';
    selectedRoleDDValue.value = '';
    selectedRoleId.value = '';
    selectedLocationIds.clear();
    errName.value = '';
    errEmail.value = '';
    errRole.value = '';
    errLocation.value = '';
    selSearchRoleDDValue.value = '';
  }
}
