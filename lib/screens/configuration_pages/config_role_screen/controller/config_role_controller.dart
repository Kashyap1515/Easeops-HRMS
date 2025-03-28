import 'package:easeops_web_hrms/app_export.dart';
import 'package:easeops_web_hrms/screens/configuration_pages/config_role_screen/model/role_model.dart';

class ConfigRoleController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isRoleLoading = true.obs;
  final NetworkApiService _apiService = NetworkApiService();
  final formKey = GlobalKey<FormState>();
  final roleNameController = TextEditingController();
  final descriptionController = TextEditingController();
  RxList<GetRoleModel> getRoleModelResponse = <GetRoleModel>[].obs;
  RxList<Map<String, dynamic>> rolesDataTableData =
      <Map<String, dynamic>>[].obs;
  RxString errRole = ''.obs;
  RxString errAccess = ''.obs;
  RxString selectedRoleDDValue = ''.obs;

  Future<void> setRoleData() async {
    rolesDataTableData.clear();
    for (final data in getRoleModelResponse.toList()) {
      rolesDataTableData.add({
        'role': data.name ?? '',
        'access': data.privilege ?? '',
        'description': data.description ?? '',
        'action': data.id,
        'data': data,
      });
    }
    Future.delayed(const Duration(milliseconds: 200), () {
      isRoleLoading.value = false;
    });
  }

  Future<void> getRoleAPIData() async {
    isRoleLoading.value = true;
    await _apiService
        .getResponse(
      endpoint: ApiEndPoints.apiRole,
      token: AppPreferences.getUserData()!.token,
    )
        .then((value) async {
      if (value != null) {
        getRoleModelResponse.clear();
        for (var i = 0; i < value.length; i++) {
          getRoleModelResponse.add(GetRoleModel.fromJson(value[i]));
        }
        await setRoleData();
      } else {
        isRoleLoading.value = false;
        customSnackBar(
          title: AppStrings.textError,
          message: AppStrings.textErrorMessage,
          alertType: AlertType.alertError,
        );
      }
    }).catchError((err) {
      isRoleLoading.value = false;
      customSnackBar(
        title: AppStrings.textError,
        message: AppStrings.textErrorMessage,
        alertType: AlertType.alertError,
      );
    });
  }

  Future<void> onCreateRoleTap({
    required bool isUpdate,
    Map<String?, dynamic>? rowData,
  }) async {
    await customAddDialog(
      title: isUpdate ? 'Edit Role' : 'Create Role',
      items: Form(
        key: formKey,
        child: Obx(
          () => ResponsiveFormLayout(
            childPerRow: 3,
            children: [
              CustomTextFormField(
                txtFormWidth: 240,
                isFillKcLightGrey: true,
                title: 'Role',
                errorMsg: errRole.value,
                validatorCallback: (val) {
                  errRole.value =
                      validateEmptyData(val, fieldName: 'Role') ?? '';
                  return null;
                },
                onChangedCallBack: (val) {
                  errRole.value =
                      validateEmptyData(val, fieldName: 'Role') ?? '';
                  return null;
                },
                paddingVertical: 14,
                textEditingController: roleNameController,
              ),
              CustomDropDown(
                width: 240,
                itemList: privilegesListLocal,
                height: 40,
                selectedItem: selectedRoleDDValue.value != ''
                    ? selectedRoleDDValue.value
                    : null,
                title: 'Access',
                hintText: 'Select Access',
                errorMsg: errAccess.value,
                onTapCallback: (val) {
                  selectedRoleDDValue.value = val;
                  errAccess.value = selectedRoleDDValue.value == ''
                      ? 'Please select access'
                      : '';
                },
              ),
              CustomTextFormField(
                txtFormWidth: 240,
                isFillKcLightGrey: true,
                paddingVertical: 14,
                title: 'Description',
                textEditingController: descriptionController,
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
            btnText: isUpdate ? 'Update' : 'Create Role',
            btnPressed: () {
              errAccess.value =
                  selectedRoleDDValue.value == '' ? 'Please select access' : '';
              if (!formKey.currentState!.validate()) {
                return;
              }
              if (errRole.value != '' || errAccess.value != '') {
                return;
              }
              isUpdate
                  ? onUpdateRoleAPICall(rowData: rowData)
                  : onCreateRoleAPICall();
              formKey.currentState!.save();
            },
            borderRadius: btnBorderRadius,
          ),
        ),
      ],
    );
  }

  bool checkIsItValid() {
    if (errRole.value == '' &&
        roleNameController.text != '' &&
        errAccess.value == '' &&
        selectedRoleDDValue.value != '') {
      return true;
    } else {
      return false;
    }
  }

  Future<void> onCreateRoleAPICall() async {
    isLoading.value = true;
    final roleCreateMap = <String, dynamic>{
      'name': roleNameController.text,
      'description': descriptionController.text,
      'privilege': selectedRoleDDValue.value,
    };
    try {
      final result = await _apiService.postResponse(
        endpoint: ApiEndPoints.apiRole,
        token: AppPreferences.getUserData()!.token,
        postBody: roleCreateMap,
      );
      if (result != null) {
        Get.back<void>();
        customSnackBar(
          title: AppStrings.textSuccess,
          message: 'Role (${roleNameController.text}) is created!',
          alertType: AlertType.alertMessage,
        );
        resetData();
        await getRoleAPIData();
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
    roleNameController.text = rowData['role'] ?? '';
    descriptionController.text = rowData['description'] ?? '';
    selectedRoleDDValue.value = rowData['access'] ?? '';
    onCreateRoleTap(isUpdate: true, rowData: rowData);
  }

  Future<void> onUpdateRoleAPICall({
    required Map<String?, dynamic>? rowData,
  }) async {
    if (rowData != null) {
      isLoading.value = true;
      final id = rowData['action'] ?? '';
      if (id != '') {
        final rolePutMapData = <String, dynamic>{
          'name': roleNameController.text.trim(),
          'description': descriptionController.text.trim(),
          'privilege': selectedRoleDDValue.value,
        };
        try {
          final result = await _apiService.putResponse(
            endpoint: '${ApiEndPoints.apiRole}/$id',
            postBody: rolePutMapData,
            token: AppPreferences.getUserData()!.token,
          );
          if (result != null) {
            Get.back<void>();
            customSnackBar(
              title: AppStrings.textSuccess,
              message: 'Role (${roleNameController.text}) is updated!',
              alertType: AlertType.alertMessage,
            );
            resetData();
            await getRoleAPIData();
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
        items: deleteDialogItem(title: rowData['role'], subTitle: 'Role'),
        btnTitle1: AppStrings.btnClose,
        btnTitle: 'Delete Role',
        onBtnCallback: () async {
          isLoading.value = true;
          try {
            final responseDel = await _apiService.deleteResponse(
              endpoint: '${ApiEndPoints.apiRole}/$id',
              token: AppPreferences.getUserData()!.token,
            );
            if (responseDel) {
              Get.back<void>();
              customSnackBar(
                title: AppStrings.textSuccess,
                message: 'Role is Deleted Successfully!',
                alertType: AlertType.alertMessage,
              );
              await getRoleAPIData();
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
    selectedRoleDDValue.value = '';
    roleNameController.clear();
    descriptionController.clear();
    errRole.value = '';
    errAccess.value = '';
  }
}
