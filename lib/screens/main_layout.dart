// ignore_for_file: deprecated_member_use

import 'package:universal_html/html.dart' as html;
import 'package:easeops_web_hrms/app_export.dart';

class MainLayout<T extends dynamic> extends StatefulWidget {
  const MainLayout({
    required this.body,
    super.key,
    this.heading,
    this.floatingActionButton,
    this.isScrollable = true,
  });

  final Widget body;
  final Widget? heading;
  final Widget? floatingActionButton;
  final bool isScrollable;

  @override
  MainLayoutState createState() => MainLayoutState();
}

class MainLayoutState extends State<MainLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Row(
              children: [
                SizedBox(
                  height: MediaQuery.of(Get.context!).size.height,
                  child: webToolbarView(context),
                ),
                Expanded(
                  child: Column(
                    children: [
                      if (widget.heading != null) widget.heading!,
                      Expanded(
                        child: widget.isScrollable
                            ? SingleChildScrollView(
                                child: widget.body,
                              )
                            : widget.body,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: widget.floatingActionButton,
    );
  }

  Widget webToolbarView(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.kcWhiteColor,
        border: Border(
          right: BorderSide(color: AppColors.kcBorderColor),
        ),
      ),
      height: double.infinity,
      width: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: all12.copyWith(bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(AppImages.webLogo, width: 135),
                  ],
                ),
                sbh5,
                Text(
                  AppStrings.appSlogan,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: AppColors.kcTextLightColor,
                  ),
                ),
                sbh32,
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: all20.copyWith(top: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    drawerItems(
                      title: 'Configuration',
                      isSelected: AppPreferences.getSelectedItem() ==
                              CurrentRoutesName.usersPageDisplayName ||
                          AppPreferences.getSelectedItem() ==
                              CurrentRoutesName.rolesPageDisplayName ||
                          AppPreferences.getSelectedItem() ==
                              CurrentRoutesName.locationPageDisplayName,
                      iconImage: AppImages.imageConfiguration,
                      onTap: () {
                        Get.offNamedUntil(
                          AppRoutes.routeUsers,
                          (route) => false,
                        );
                        AppPreferences.setSelectedItem(
                          CurrentRoutesName.usersPageDisplayName,
                        );
                      },
                    ),
                    sbh12,
                    drawerItems(
                      title: 'Attendance',
                      isSelected: AppPreferences.getSelectedItem() ==
                          CurrentRoutesName.attendancePageDisplayName,
                      iconImage: AppImages.imageAttendance,
                      onTap: () {
                        Get.offNamedUntil(
                          '${AppRoutes.routeAttendance}?date=${formatDateToDDashMMDashY(DateTime.now())}',
                          (route) => false,
                        );
                        AppPreferences.setSelectedItem(
                          CurrentRoutesName.attendancePageDisplayName,
                        );
                      },
                    ),
                    sbh12,
                    drawerItems(
                      title: 'Manage Shift',
                      isSelected: AppPreferences.getSelectedItem() ==
                          CurrentRoutesName.shiftPageDisplayName,
                      iconImage: AppImages.imageSetting,
                      onTap: () {
                        Get.offNamedUntil(
                          AppRoutes.routeShift,
                          (route) => false,
                        );
                        AppPreferences.setSelectedItem(
                          CurrentRoutesName.shiftPageDisplayName,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: symetricV16H24,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      AppImages.imageProfile,
                      width: 32,
                      height: 32,
                    ),
                    sbw8,
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppPreferences.getUserData() != null
                                ? AppPreferences.getUserData()!.name ?? ''
                                : '',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.kcBlackColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            AppPreferences.getUserData() != null
                                ? AppPreferences.getUserData()!.email ??
                                    AppPreferences.getUserData()!.phoneNumber ??
                                    ''
                                : '',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: const Color(0xFF676767),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                sbh24,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    drawerItems(
                      title: 'Logout',
                      isSelected: true,
                      iconImage: AppImages.imageLogout,
                      onTap: () {
                        AppPreferences.removeAllData();
                        Get.offAllNamed<void>(AppRoutes.routeLogin);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          sbh10,
        ],
      ),
    );
  }

  Widget drawerTabletItems({
    required String title,
    required String iconImage,
    required bool isSelected,
    required VoidCallback onTap,
    bool isProfileImage = false,
    bool isLogout = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Tooltip(
        message: title,
        decoration: BoxDecoration(
          color: AppColors.kcTextLightColor,
          borderRadius: br4,
        ),
        padding: symetricH10.copyWith(top: 5, bottom: 5),
        excludeFromSemantics: true,
        child: SizedBox(
          width: isProfileImage ? 18 : 20,
          height: isProfileImage ? 18 : 20,
          child: FittedBox(
            child: SvgPicture.asset(
              iconImage,
              color: isProfileImage || isLogout
                  ? null
                  : isSelected
                      ? AppColors.kcSelectedColor
                      : AppColors.kcTextLightColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget drawerItems({
    required String title,
    required String iconImage,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(
            iconImage,
            width: 16,
            height: 16,
            color: isSelected
                ? AppColors.kcSelectedColor
                : AppColors.kcTextLightColor,
          ),
          sbw8,
          Text(
            title,
            style: GoogleFonts.montserrat(
              color: isSelected
                  ? AppColors.kcSelectedColor
                  : AppColors.kcTextLightColor,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
