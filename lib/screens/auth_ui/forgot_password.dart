import 'package:easeops_web_hrms/app_export.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();

// String _emailAddress = "";
  final NetworkApiService _apiService = NetworkApiService();

  bool allOKToSendEmailLink = false;
  
  bool isGetLinkLoading = false;

  Future<void> saveForm() async {
    final isValid = formkey.currentState!.validate();
    if (!isValid) {
      return;
    }
    formkey.currentState!.save();
    final forgetPassEmailBody = <String, dynamic>{
      'user_email': emailController.text,
      'reset_type': true,
    };
    setState(() {
      isGetLinkLoading = true;
    });
    try {
      final result = await _apiService.postResponse(
        endpoint: ApiEndPoints.apiPwdResetLink,
        postBody: forgetPassEmailBody,
        token: '',
        isReturnBool: true,
      );
      if (result) {
        setState(() {
          allOKToSendEmailLink = true;
        });
      }
    } catch (e) {
      customSnackBar(
        title: AppStrings.textError,
        message: e.toString(),
        alertType: AlertType.alertError,
      );
    }
    setState(() {
      isGetLinkLoading = false;
    });
  }

  @override
  void dispose() {
    emailController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.09),
                Container(
                  margin: all10,
                  child: Text(
                    AppStrings.appName,
                    style: AppStyles.ktsBodyLarge,
                  ),
                ),
                Text(
                  AppStrings.appSlogan,
                  style: AppStyles.ktsTextFieldTitle.apply(fontSizeFactor: 1.1),
                ),
                SizedBox(height: size.height * 0.09),
                if (allOKToSendEmailLink)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'A Password reset link is sent to your email',
                        style: AppStyles.ktsLoginText.apply(fontSizeFactor: 1.1),
                      ),
                      Text(
                        'Kindly click on the link to change your password.',
                        style: AppStyles.ktsTextFieldSelected
                            .apply(fontSizeFactor: 1.5),
                      ),
                      sbh24,
                      CustomElevatedButton(
                        btnText: 'Get Back to Login Page',
                        btnWidth: MediaQuery.of(context).size.width * 0.27,
                        btnPressed: () {
                          Get.offNamedUntil(AppRoutes.routeLogin, (route) => false);
                        },
                      ),
                    ],
                  )
                else
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: all15,
                        child: Text(
                          'Forgot Password?',
                          style: AppStyles.ktsLoginText,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Please enter your email address to get the reset link.',
                          style: AppStyles.ktsDropDownText,
                        ),
                      ),
                      CustomTextFormField(
                        txtFormWidth: MediaQuery.of(context).size.width * 0.27,
                        labelText: 'Email Address',
                        txtStyle: AppStyles.ktsTabTitle2,
                        textEditingController: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validatorCallback: (val) {
                          if (val!.isEmpty) {
                            return 'Please Enter Email Address';
                          } else if (!(val.contains('@') && val.contains('.'))) {
                            return 'Enter a Valid Email Address';
                          }
                          return null;
                        },
                        onSavedCallback: (val) {
                          // _emailAddress = val.toString();
                      // _emailAddress = emailController.text;
                          return null;
                        },
                      ),
                      sbh20,
                      CustomElevatedButton(
                        btnText: 'Get Link',
                        btnWidth: MediaQuery.of(context).size.width * 0.27,
                        isLoading: isGetLinkLoading,
                        btnPressed: () async {
                          await saveForm();
                        },
                      ),
                    ],
                  ),
                sbh50,
                sbh50,
                sbh50,
                sbh30,
                sbh30,

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
        ),
      ),
    );
  }
}
