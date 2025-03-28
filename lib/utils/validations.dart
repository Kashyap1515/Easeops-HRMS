import 'package:easeops_web_hrms/app_export.dart';

String? validateEmptyData(String? value, {String fieldName = ''}) {
  if (value == null || value.isEmpty) {
    return 'Please Enter $fieldName';
  }
  return null;
}

String? validateIsNumericOnly(String? value, {String fieldName = ''}) {
  if (value == null || value.isEmpty) {
    return 'Please Enter $fieldName';
  } else if (!value.isNumericOnly) {
    return 'Please Enter Number Only';
  }
  return null;
}

String? validateIsAlphaNumericOnly(String? value, {String fieldName = ''}) {
  final alphaNumeric = RegExp(r'^[a-zA-Z0-9\s]+$');
  if (value == null || value.isEmpty) {
    return 'Please Enter $fieldName';
  } else if (!alphaNumeric.hasMatch(value.trim())) {
    return 'Please Enter Alpha Number $fieldName';
  }
  return null;
}

String? validateIsDoubleOnly(String? value, {String fieldName = ''}) {
  if (value == null || value.isEmpty) {
    return 'Please Enter $fieldName';
  } else if (!value.isNum) {
    return 'Please Enter Number Only';
  }
  return null;
}

String? validate0to100Range(String? value, {String fieldName = ''}) {
  if (value == null || value.isEmpty) {
    return 'Please Enter $fieldName';
  } else if (!value.isNum) {
    return 'Please Enter Number Only';
  } else if (value.isNum && (int.parse(value) <= -1 || int.parse(value) >= 101)) {
    return 'Please Enter $fieldName between 0 to 100 only';
  }
  return null;
}

String? validateMobileNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please Enter Mobile number';
  } else if (!value.isPhoneNumber) {
    return 'Please Enter Valid Mobile number';
  } else if (value.trim().length != 10) {
    return 'Please Enter Valid Mobile number';
  }
  return null;
}

String? validateTime(String value) {
  final timeRegExp = RegExp(r'^([0-9]?[0-9]):([0-5]?[0-9]):([0-5]?[0-9])$');
  if (!timeRegExp.hasMatch(value.trim())) {
    return 'Please Enter Valid Time';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please Enter Email Id';
  } else if (!value.isEmail) {
    return 'Please Enter Valid Email Id';
  }
  return null;
}

String? validateDate(String? value) {
  final regExp = RegExp('[0-9/]');
  if (value == null || value.isEmpty) {
    return 'Please Enter Date';
  } else if (!regExp.hasMatch(value)) {
    return 'Enter Valid Date';
  }
  return null;
}
