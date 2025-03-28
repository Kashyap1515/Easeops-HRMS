import 'package:easeops_web_hrms/app_export.dart';
import 'package:easeops_web_hrms/screens/auth_ui/set_password_screen/set_password_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:universal_html/html.dart' as html;

class SetPasswordPage extends GetWidget<SetPasswordController> {
  const SetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder(
        init: controller,
        initState: (state) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (html.window.location.toString().split('=').last != '') {
              controller.tokenAuth.value =
                  html.window.location.toString().split('=').last;
            } else {
              controller.tokenAuth.value = '';
            }
          });
        },
        builder: (context) {
          return Obx(
            () => Form(
              key: controller.form,
              child: Column(
                children: [
                  SizedBox(height: Get.size.height * 0.09),
                  Container(
                    margin: all10,
                    child: Text(
                      AppStrings.appName,
                      style: AppStyles.ktsBodyLarge,
                    ),
                  ),
                  Text(
                    AppStrings.appSlogan,
                    style:
                        AppStyles.ktsTextFieldTitle.apply(fontSizeFactor: 1.1),
                  ),
                  SizedBox(height: Get.size.height * 0.09),
                  if (controller.allOKToNavigateLogin.value)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'You have successfully created your new password.',
                          style:
                              AppStyles.ktsLoginText.apply(fontSizeFactor: 1.1),
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Click here to go to the ',
                            style: AppStyles.ktsLoginText
                                .apply(fontSizeFactor: 1.1),
                            children: [
                              TextSpan(
                                text: ' Login ',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.offAllNamed<void>(AppRoutes.routeLogin);
                                  },
                                style: AppStyles.ktsLoginText.apply(
                                  fontSizeFactor: 1.1,
                                  color: AppColors.kcPrimaryColor,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(
                                text: ' page.',
                                style: AppStyles.ktsLoginText
                                    .apply(fontSizeFactor: 1.1),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        Container(
                          margin: all15,
                          child: Text(
                            'Create New Password',
                            style: AppStyles.ktsLoginText,
                          ),
                        ),
                        Padding(
                          padding: symetricH16,
                          child: CustomTextFormField(
                            txtFormWidth: Get.size.width < 500
                                ? Get.size.width
                                : Get.size.width * 0.25,
                            labelText: 'Enter your password',
                            txtStyle: AppStyles.ktsTabTitle2,
                            textEditingController:
                                controller.passwordController,
                            obscureText: controller.isVisibleForPassword.value
                                ? false
                                : true,
                            validatorCallback: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter your Password';
                              } else if (value.length < 7) {
                                return 'For Strong Password Length Must be Min 8 Characters';
                              }
                              return null;
                            },
                            onSavedCallback: (val) {
                              // _password = val.toString();
                              // _password = passwordController.text;
                              return null;
                            },
                            suffixIcon: !controller.isVisibleForPassword.value
                                ? Icons.visibility_off
                                : Icons.visibility_sharp,
                            suffixCallBack: () {
                              controller.isVisibleForPassword.value =
                                  !controller.isVisibleForPassword.value;
                            },
                          ),
                        ),
                        sbh20,
                        Padding(
                          padding: symetricH16,
                          child: CustomTextFormField(
                            txtFormWidth: Get.size.width < 500
                                ? Get.size.width
                                : Get.size.width * 0.25,
                            labelText: 'Confirm password',
                            txtStyle: AppStyles.ktsTabTitle2,
                            textEditingController:
                                controller.newPasswordController,
                            obscureText:
                                controller.isVisibleForNewPassword.value
                                    ? false
                                    : true,
                            validatorCallback: (value) {
                              if (value!.isEmpty) {
                                return 'Please Re-Enter your Confirm Password';
                              } else if (controller
                                  .newPasswordController.text.isEmpty) {
                                return 'Please enter confirm password field first';
                              } else if (controller.passwordController.text !=
                                  value) {
                                return 'Confirm Password not matching. Enter password again!';
                              }
                              return null;
                            },
                            onSavedCallback: (val) {
                              return null;
                            },
                            suffixIcon:
                                !controller.isVisibleForNewPassword.value
                                    ? Icons.visibility_off
                                    : Icons.visibility_sharp,
                            suffixCallBack: () {
                              controller.isVisibleForNewPassword.value =
                                  !controller.isVisibleForNewPassword.value;
                            },
                          ),
                        ),
                        sbh10,
                        Padding(
                          padding: symetricH16,
                          child: CustomElevatedButton(
                            btnText: 'Create',
                            isLoading: controller.isSetPasswordLoading.value,
                            btnWidth: Get.size.width < 500
                                ? Get.size.width
                                : Get.size.width * 0.25,
                            btnPressed: () async {
                              await controller.saveForm(Get.context!);
                            },
                          ),
                        ),
                      ],
                    ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AppImages.imageC),
                      sbw5,
                      Container(
                        margin: all10,
                        child: Text(
                          AppStrings.copyrightFooter,
                          style: AppStyles.ktsTextFieldTitle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
