import 'package:easeops_web_hrms/app_export.dart';

class ConfigurationMainLayout<T extends dynamic> extends StatelessWidget {
  const ConfigurationMainLayout({
    required this.body,
    super.key,
    this.configurationTypes = ConfigurationTypes.users,
  });

  final Widget body;
  final ConfigurationTypes configurationTypes;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ColoredBox(
          color: AppColors.kcWhiteColor,
          child: Column(
            children: [
              Padding(
                padding: all24.copyWith(top: 32, bottom: 0),
                child: Row(
                  children: [
                    tabItem(
                      title: 'Users',
                      isSelected:
                          configurationTypes == ConfigurationTypes.users,
                      onTapCallback: () {
                        Get.offNamed(AppRoutes.routeUsers);
                        AppPreferences.setSelectedItem(
                          CurrentRoutesName.usersPageDisplayName,
                        );
                      },
                    ),
                    sbw32,
                    tabItem(
                      title: 'Roles',
                      isSelected:
                          configurationTypes == ConfigurationTypes.roles,
                      onTapCallback: () {
                        Get.offNamed(AppRoutes.routeRoles);
                        AppPreferences.setSelectedItem(
                          CurrentRoutesName.rolesPageDisplayName,
                        );
                      },
                    ),
                    sbw32,
                    tabItem(
                      title: 'Locations',
                      isSelected:
                          configurationTypes == ConfigurationTypes.locations,
                      onTapCallback: () {
                        Get.offNamed(AppRoutes.routeLocations);
                        AppPreferences.setSelectedItem(
                          CurrentRoutesName.locationPageDisplayName,
                        );
                      },
                    ),
                  ],
                ),
              ),
              sbh8,
              tabBottom(configurationTypes: configurationTypes),
            ],
          ),
        ),
        body,
      ],
    );
  }

  Widget tabItem({
    required String title,
    required bool isSelected,
    required VoidCallback onTapCallback,
  }) {
    return Theme(
      data: AppStyles.removeDefaultSplash,
      child: InkWell(
        onTap: onTapCallback,
        child: Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            color: isSelected
                ? AppColors.kcSelectedColor
                : AppColors.kcTextLightColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget tabBottom({required ConfigurationTypes configurationTypes}) {
    return Stack(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: Divider(
            height: 1,
            thickness: 1,
          ),
        ),
        Positioned(
          left: configurationTypes == ConfigurationTypes.users
              ? 26
              : configurationTypes == ConfigurationTypes.roles
                  ? 95
                  : 170,
          child: Container(
            width: configurationTypes == ConfigurationTypes.locations ? 67 : 35,
            height: 2,
            color: AppColors.kcSelectedColor,
          ),
        ),
      ],
    );
  }
}
