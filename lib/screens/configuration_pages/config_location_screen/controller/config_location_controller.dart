import 'package:easeops_web_hrms/app_export.dart';
import 'package:easeops_web_hrms/screens/configuration_pages/config_location_screen/model/location_model.dart';
import 'package:easeops_web_hrms/screens/configuration_pages/config_location_screen/model/search_loc_model.dart';
import 'package:intl/intl.dart';
import 'package:universal_html/html.dart';

class ConfigLocationController extends GetxController {
  final NetworkApiService _apiService = NetworkApiService();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxList<GetLocationModel> getLocationModelResponse = <GetLocationModel>[].obs;
  RxList<Map<String, dynamic>> locationDataTableData =
      <Map<String, dynamic>>[].obs;
  final textAliasController = TextEditingController();
  Rx<TextEditingController> searchLocationTextController =
      TextEditingController().obs;
  RxList<Prediction> locGoogleList = <Prediction>[].obs;
  RxString errBrand = ''.obs;
  RxString errAlias = ''.obs;
  RxString errMarket = ''.obs;
  RxString errLocation = ''.obs;
  RxBool isLoading = true.obs;
  RxBool isLocationLoading = true.obs;
  RxString placeIdSelectedLoc = ''.obs;
  RxString timeZone = ''.obs;
  RxDouble latOfSelectedLoc = 0.0.obs;
  RxDouble longOfSelectedLoc = 0.0.obs;

  Future<void> setLocationData() async {
    locationDataTableData.clear();
    for (final data in getLocationModelResponse.toList()) {
      locationDataTableData.add({
        'alias': data.name ?? '',
        'location': data.location ?? '',
        'type': data.locationType ?? '',
        'action': data.id,
        'latData': data.lat,
        'longData': data.lon,
        'data': data,
      });
    }
    Future.delayed(const Duration(milliseconds: 200), () {
      isLocationLoading.value = false;
    });
  }

  Future<void> getLocationAPIData() async {
    isLocationLoading.value = true;
    await _apiService
        .getResponse(
      endpoint: ApiEndPoints.apiLocation,
      token: AppPreferences.getUserData()!.token,
    )
        .then((value) {
      if (value != null) {
        getLocationModelResponse.clear();
        for (var i = 0; i < value.length; i++) {
          getLocationModelResponse.add(GetLocationModel.fromJson(value[i]));
        }
        setLocationData();
      } else {
        isLocationLoading.value = false;
        customSnackBar(
          title: AppStrings.textError,
          message: AppStrings.textErrorMessage,
          alertType: AlertType.alertError,
        );
      }
    }).catchError((err) {
      isLocationLoading.value = false;
      customSnackBar(
        title: AppStrings.textError,
        message: AppStrings.textErrorMessage,
        alertType: AlertType.alertError,
      );
    });
  }

  Future<void> onCreateLocationTap({
    required bool isUpdate,
    Map<String?, dynamic>? rowData,
  }) async {
    await customAddDialog(
      title: isUpdate ? 'Edit Location' : 'Create Location',
      items: Form(
        key: formKey,
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResponsiveFormLayout(
                childPerRow: 2,
                wrapSpacing: 16,
                runSpacing: 16,
                children: [
                  CustomTextFormField(
                    isFillKcLightGrey: true,
                    title: 'Alias',
                    errorMsg: errAlias.value,
                    validatorCallback: (val) {
                      errAlias.value =
                          validateEmptyData(val, fieldName: 'Alias') ?? '';
                      return null;
                    },
                    onChangedCallBack: (val) {
                      errAlias.value =
                          validateEmptyData(val, fieldName: 'Alias') ?? '';
                      return null;
                    },
                    paddingVertical: 14,
                    textEditingController: textAliasController,
                  ),
                  CustomDropDownWithTextField(
                    itemList: locGoogleList.toList(),
                    height: 44,
                    width: 410,
                    textEditingController: searchLocationTextController.value,
                    title: 'Search Location',
                    isGoogleLocation: true,
                    hintText: 'Search Google Location',
                    errorMsg: errLocation.value,
                    validatorCallback: (val) {
                      errLocation.value =
                          validateEmptyData(val, fieldName: 'Location') ?? '';
                      return null;
                    },
                    onChangedCallBack: (String? val) {
                      if (val != null || val != '') {
                        placesAutoComplete(
                          val!,
                          AppPreferences.getUserData()!.token,
                        );
                      }
                      return null;
                    },
                    onSelectedCallback: (value) {
                      if (value != null) {
                        searchLocationTextController.value.text =
                            (value as Prediction).description.toString();
                        errLocation.value = validateEmptyData(
                              value.description.toString(),
                              fieldName: 'Location',
                            ) ??
                            '';
                        placeIdSelectedLoc.value = value.placeId.toString();
                      }
                    },
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
            btnText: isUpdate ? 'Update' : 'Create Location',
            btnPressed: () async {
              if (!formKey.currentState!.validate()) {
                return;
              }
              if (errAlias.value != '' ||
                  // errMarket.value != '' ||
                  // errBrand.value != '' ||
                  errLocation.value != '') {
                return;
              }
              if (placeIdSelectedLoc.value != '') {
                await setCoordinates(isUpdate: isUpdate, rowData: rowData);
              } else if (isUpdate) {
                await onUpdateLocationAPICall(rowData: rowData);
              } else {
                customSnackBar(
                  title: AppStrings.textError,
                  message: AppStrings.textErrorMessage,
                  alertType: AlertType.alertError,
                );
              }
              formKey.currentState!.save();
            },
            borderRadius: btnBorderRadius,
          ),
        ),
      ],
    );
  }

  bool checkIsItValid() {
    if (errLocation.value == '' &&
        searchLocationTextController.value.text != '' &&
        errAlias.value == '' &&
        textAliasController.text != '') {
      return true;
    } else {
      return false;
    }
  }

  Future<void> placesAutoComplete(String query, String? token) async {
    try {
      final response = await _apiService.getResponse(
        endpoint: '${ApiEndPoints.apiLocSearch}/$query',
        token: token,
      );
      if (response != null) {
        final data = LocationSearchListModel.fromJson(response);
        locGoogleList.clear();
        for (final d in data.predictions!) {
          locGoogleList.add(d);
        }
      }
    } catch (e) {
      Logger.log(e.toString());
    }
  }

  Future<void> setCoordinates({
    required bool isUpdate,
    Map<String?, dynamic>? rowData,
  }) async {
    try {
      isLoading.value = true;
      final latLonDataRes = await _apiService.getResponse(
        endpoint:
            '${ApiEndPoints.apiLocSearch}/${placeIdSelectedLoc.value}/coordinates',
        token: AppPreferences.getUserData()!.token,
      );
      if (latLonDataRes != null) {
        latOfSelectedLoc.value = double.parse(latLonDataRes['latitude']);
        longOfSelectedLoc.value = double.parse(latLonDataRes['longitude']);
        timeZone.value = latLonDataRes['time_zone'] ?? '';
        isUpdate
            ? await onUpdateLocationAPICall(rowData: rowData)
            : await onCreateLocationAPICall();
      } else {
        customSnackBar(
          title: AppStrings.textError,
          message: 'Latitude or Longitude not found.',
          alertType: AlertType.alertError,
        );
      }
    } catch (e) {
      isLoading.value = false;
    }
  }

  Future<void> onCreateLocationAPICall() async {
    isLoading.value = true;
    final locationCreateMap = <String, dynamic>{
      'name': textAliasController.text.trim(),
      'location': searchLocationTextController.value.text.trim(),
      'time_zone': timeZone.value,
      'lat': latOfSelectedLoc.value,
      'lon': longOfSelectedLoc.value,
      'is_corporate': true,
    };
    try {
      final result = await _apiService.postResponse(
        endpoint: ApiEndPoints.apiLocation,
        token: AppPreferences.getUserData()!.token,
        postBody: locationCreateMap,
      );
      if (result != null) {
        Get.back<void>();
        customSnackBar(
          title: AppStrings.textSuccess,
          message: 'Location (${textAliasController.text}) is created!',
          alertType: AlertType.alertMessage,
        );
        resetData();
        await getLocationAPIData();
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

  void onRowEditOptionTap({required Map<String?, dynamic> rowData}) {
    textAliasController.text = rowData['alias'] ?? '';
    searchLocationTextController.value.text = rowData['location'] ?? '';
    latOfSelectedLoc.value = rowData['latData'] ?? 0.0;
    longOfSelectedLoc.value = rowData['longData'] ?? 0.0;
    onCreateLocationTap(isUpdate: true, rowData: rowData);
  }

  Future<void> onUpdateLocationAPICall({
    required Map<String?, dynamic>? rowData,
  }) async {
    if (rowData != null) {
      isLoading.value = true;
      final id = rowData['action'] ?? '';
      if (id != '') {
        final locationPutMapData = <String, dynamic>{
          'name': textAliasController.text.trim(),
          'location': searchLocationTextController.value.text.trim(),
          'time_zone': timeZone.value,
          'lat': latOfSelectedLoc.value,
          'lon': longOfSelectedLoc.value,
        };
        try {
          final result = await _apiService.putResponse(
            endpoint: '${ApiEndPoints.apiLocation}/$id',
            postBody: locationPutMapData,
            token: AppPreferences.getUserData()!.token,
          );
          if (result != null) {
            Get.back<void>();
            resetData();
            customSnackBar(
              title: AppStrings.textSuccess,
              message: 'Location (${textAliasController.text}) is updated!',
              alertType: AlertType.alertMessage,
            );
            await getLocationAPIData();
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
        items: deleteDialogItem(title: rowData['alias'], subTitle: 'Location'),
        btnTitle1: AppStrings.btnClose,
        btnTitle: 'Delete Location',
        onBtnCallback: () async {
          isLoading.value = true;
          try {
            final responseDel = await _apiService.deleteResponse(
              endpoint: '${ApiEndPoints.apiLocation}/$id',
              token: AppPreferences.getUserData()!.token,
            );
            if (responseDel) {
              Get.back<void>();
              customSnackBar(
                title: AppStrings.textSuccess,
                message: 'Location is Deleted Successfully!',
                alertType: AlertType.alertMessage,
              );
              await getLocationAPIData();
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
    textAliasController.clear();
    searchLocationTextController.value.clear();
    locGoogleList.clear();
    latOfSelectedLoc.value = 0.0;
    longOfSelectedLoc.value = 0.0;
    timeZone.value = '';
    placeIdSelectedLoc.value = '';
  }
}
