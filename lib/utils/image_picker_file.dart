import 'package:easeops_web_hrms/app_export.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

Future<XFile?> customImagePicker() async {
  try {
    final selectedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (selectedFile == null) return null;
    return selectedFile;
  } on PlatformException catch (err) {
    Logger.log(err.toString());
    return null;
  }
}


Future<Map<String, dynamic>> onImageUploadAPICall({
  required XFile file,
  required String refId,
  required String refName,
}) async {
  final apiService = NetworkApiService();
  var fileName = file.name.toLowerCase();
  final jsonBody = <String, dynamic>{
    'ref_name': refName,
    'ref_id': refId,
    'filename_w_ext': fileName,
  };
  try {
    final result = await apiService.postResponse(
      endpoint: ApiEndPoints.apiGetImageUploadUrl,
      token: AppPreferences.getUserData()!.token,
      postBody: jsonBody,
    );
    if (result != null) {
      final imageKey = result['key'];
      final imageAWSUrlEndpoint = result['url'];
      var isSuccess = await pickAndUploadImageWithPut(
        imageKey: imageKey,
        imageAWSUrlEndpoint: imageAWSUrlEndpoint,
        file: file,
      );
      return {
        'key': imageKey,
        'url': imageAWSUrlEndpoint,
        'fileName': fileName,
        'isSuccess': isSuccess,
      };
    } else {
      customSnackBar(
        title: AppStrings.textError,
        message: AppStrings.textErrorMessage,
        alertType: AlertType.alertError,
      );
      return {
        'isSuccess': false,
      };
    }
  } catch (e) {
    customSnackBar(
      title: AppStrings.textError,
      message: AppStrings.textErrorMessage,
      alertType: AlertType.alertError,
    );
    return {
      'isSuccess': false,
    };
  }
}

Future<bool> pickAndUploadImageWithPut({
  required XFile file,
  Uint8List? bytes,
  required String imageKey,
  required String imageAWSUrlEndpoint,
}) async {
  try {
    final request = http.Request('PUT', Uri.parse(imageAWSUrlEndpoint))
      ..bodyBytes = bytes ?? await file.readAsBytes();
    final response = await http.Client().send(request);
    if (response.statusCode == 200) {
      Logger.log('Image uploaded successfully');
      return true;
    } else {
      Logger.log('Failed to upload image. Status code: $response');
      return false;
    }
  } catch (e) {
    Logger.log('Error picking/uploading image: $e');
    return false;
  }
}
