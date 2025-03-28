import 'package:easeops_web_hrms/app_export.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _form = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String _emailAddress = '';
  String _mobileNoAddress = '';
  String _password = '';
  bool isVisible = false;
  bool allOkToNavigate = false;
  final NetworkApiService _apiService = NetworkApiService();

  bool isUserLoggingIn = false;

  Future<void> saveForm(BuildContext context) async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      isUserLoggingIn = true;
    });
    try {
      final result = await _apiService.postResponse(
        endpoint: ApiEndPoints.apiLogin,
        postBody: {
          'email': _emailAddress == '' ? null : _emailAddress,
          'phone_number': _mobileNoAddress == '' ? null : _mobileNoAddress,
          'password': _password,
        },
        token: '',
      );
      if (result != null) {
        await AppPreferences.setUserData(jsonEncode(result));
        await getMyProfile();
      }
    } catch (e) {
      setState(() {
        isUserLoggingIn = false;
      });
      customSnackBar(
        title: AppStrings.textError,
        message: e.toString(),
        alertType: AlertType.alertError,
      );
    }
  }

  Future<void> getMyProfile() async {
    try {
      final result = await _apiService.getResponse(
        endpoint: ApiEndPoints.apiMyProfile,
        token: AppPreferences.getUserData()!.token,
      );
      if (result != null) {
        Logger.log('Get My Profile LOGIN: ${jsonEncode(result)}');
        await AppPreferences.setUserProfileData(jsonEncode(result));
        await getSetting();
      }
    } catch (e) {
      setState(() {
        isUserLoggingIn = false;
      });
      customSnackBar(
        title: AppStrings.textError,
        message: e.toString(),
        alertType: AlertType.alertError,
      );
    }
  }

  Future<void> getSetting() async {
    try {
      final result = await _apiService.getResponse(
        endpoint: ApiEndPoints.apiSettings,
        token: AppPreferences.getUserData()!.token,
      );
      if (result != null) {
        Logger.log('Get Setting LOGIN: ${jsonEncode(result)}');
        var fromDate = DateTime.now().subtract(const Duration(days: 14));
        var toDate = DateTime.now();
        final startDate = formatDateToDDashMMDashY(fromDate);
        final endDate = formatDateToDDashMMDashY(toDate);
        Get.offNamedUntil(
          '${AppRoutes.routeUsers}?from=$startDate&to=$endDate',
          (route) => false,
        );
        AppPreferences.setSelectedItem(
          CurrentRoutesName.usersPageDisplayName,
        );
        setState(() {
          isUserLoggingIn = false;
          allOkToNavigate = true;
        });
      }
    } catch (e) {
      setState(() {
        isUserLoggingIn = false;
      });
      customSnackBar(
        title: AppStrings.textError,
        message: e.toString(),
        alertType: AlertType.alertError,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Column(
            children: [
              sbh50,
              sbh50,
              SvgPicture.asset(AppImages.webLogo, width: Get.size.width / 6),
              sbh10,
              // Container(
              //   margin: all10,
              //   child: Text(
              //     AppStrings.appName,
              //     style: AppStyles.ktsBodyLarge,
              //   ),
              // ),
              Text(
                AppStrings.appSlogan,
                style: AppStyles.ktsTextFieldTitle.apply(fontSizeFactor: 1.1),
              ),
              SizedBox(height: size.height * 0.09),
              Container(
                margin: all15,
                child: Text(
                  'Please Log in to your account',
                  style: AppStyles.ktsLoginText,
                ),
              ),
              sbh20,
              CustomTextFormField(
                txtFormWidth: MediaQuery.of(context).size.width * 0.27,
                labelText: 'Enter your email / phone',
                txtStyle: AppStyles.ktsTabTitle2,
                textEditingController: emailController,
                validatorCallback: (val) {
                  if (val!.isEmpty) {
                    return 'Please Enter Email / Phone';
                  }
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                  final phoneRegex = RegExp(r'^[0-9]{10}$');
                  if (!emailRegex.hasMatch(val) && !phoneRegex.hasMatch(val)) {
                    return 'Enter a valid Email or Phone';
                  }
                  return null;
                },
                onSavedCallback: (val) {
                  var emailOrPhone = emailController.text.trim();
                  if (emailOrPhone.contains('@') &&
                      emailOrPhone.contains('.')) {
                    _emailAddress = emailOrPhone;
                    _mobileNoAddress = '';
                  } else {
                    _mobileNoAddress = emailOrPhone;
                    _emailAddress = '';
                  }
                  return null;
                },
              ),
              sbh16,
              CustomTextFormField(
                txtFormWidth: MediaQuery.of(context).size.width * 0.27,
                labelText: 'Enter your password',
                txtStyle: AppStyles.ktsTabTitle2,
                textEditingController: passwordController,
                obscureText: isVisible ? false : true,
                validatorCallback: (value) {
                  if (value!.isEmpty) {
                    return 'Please Enter your Password';
                  }
                  return null;
                },
                onSavedCallback: (val) {
                  _password = passwordController.text;
                  return null;
                },
                suffixIcon:
                    !isVisible ? Icons.visibility_off : Icons.visibility_sharp,
                suffixCallBack: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
              ),
              sbh20,
              CustomElevatedButton(
                btnText: 'Log In',
                isLoading: isUserLoggingIn,
                btnWidth: MediaQuery.of(context).size.width * 0.27,
                btnPressed: () async {
                  if (!isUserLoggingIn) {
                    await saveForm(context);
                  }
                },
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: size.width * 0.16),
                margin: all10,
                child: InkWell(
                  onTap: () {
                    Get.toNamed(AppRoutes.routeForgotPwd);
                  },
                  child: Text(
                    'Forgot Password?',
                    style: AppStyles.ktsTabTitle2.apply(
                      color: AppColors.kcPrimaryColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              sbh50,
              sbh50,
              sbh24,
              sbh24,
              sbh5,
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
        // Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        //   const SizedBox(),
        //   Container(
        //     margin: all10,
        //     child: Text(
        //       AppStrings.appName,
        //       style:AppStyles.ktsBodyLarge,
        //     ),
        //   ),
        //   Container(
        //     // margin: all10,
        //     child: Text(
        //       AppStrings.appSlogan,
        //       style:AppStyles.ktsTextFieldTitle.apply(fontSizeFactor: 1.1),
        //     ),
        //   ),
        //   sbh50,

        //   // !isForgotPassword ? const LoginFields() : const ForgotPasswordPage(),
        //   !isForgotPassword ? Container(
        //     alignment: Alignment.center,
        //     padding: EdgeInsets.only(left: size.width * 0.16),
        //     margin: all10,
        //     child: InkWell(
        //       onTap: () {
        //         setState(() {
        //           isForgotPassword = true;
        //         });
        //       },
        //       child: Text("Forgot Password?",
        //           style:AppStyles.ktsTabTitle2.apply(
        //               color:AppColors.kcPrimaryColor,
        //               decoration: TextDecoration.underline)),
        //     ),
        //   ) : sbh16,

        //   // const Spacer(),
        //   Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Image.asset(AppImages.imageC),
        //       Container(
        //         margin: all10,
        //         child: Text(
        //           AppStrings.copyrightFooter,
        //           style:AppStyles.ktsTextFieldTitle,
        //         ),
        //       ),
        //     ],
        //   )
        // ]),
      ),
    );
  }
}
