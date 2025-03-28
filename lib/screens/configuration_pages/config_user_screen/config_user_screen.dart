import 'package:easeops_web_hrms/app_export.dart';

class ConfigUserScreen extends GetView<ConfigUserController> {
  const ConfigUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: GetBuilder(
        init: controller,
        initState: (state) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.getInitialAPIData();
          });
        },
        builder: (context) {
          return ConfigurationMainLayout(
            configurationTypes: ConfigurationTypes.users,
            body: Obx(
              () => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomDataTable(
                    isLoading: controller.isUserLoading.value,
                    searchKey: 'name',
                    headers: [
                      DatatableHeader(
                        flex: 4,
                        text: 'Name',
                        value: 'name',
                        sourceBuilder: (value, row) {
                          final isVerified = row['is_verified'] ?? true;
                          return Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              if (!isVerified)
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 8,
                                  ),
                                  child: Image.asset(
                                    AppImages.imageNotVerify,
                                    color: AppColors.kcDangerColor
                                        .withOpacity(0.5),
                                    width: 20,
                                  ),
                                ),
                              if (isVerified)
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 8,
                                  ),
                                  child: Image.asset(
                                    AppImages.imageVerify,
                                    color: AppColors.kcSuccessColor,
                                    width: 20,
                                  ),
                                ),
                              Text(
                                value,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: AppColors.kcBlackColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          );
                        },
                        textAlign: TextAlign.left,
                      ),
                      customDatatableHeader(lblValue: 'Email', flex: 5),
                      DatatableHeader(
                        text: 'Action',
                        value: 'action',
                        flex: 4,
                        sourceBuilder: (value, row) {
                          final rowRole = (row['roles'] as List<Role>).toList();
                          return Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.end,
                            children: [
                              if (!(row['is_verified'] ?? true) &&
                                  row['email'] != '')
                                InkWell(
                                  onTap: () => controller.onRowResendEmailTap(
                                    rowData: row,
                                  ),
                                  child: Text(
                                    'Resend Email',
                                    style: GoogleFonts.inter(
                                      color: AppColors.kcPrimaryColor,
                                    ),
                                  ),
                                ),
                              sbw10,
                              CustomMenuAnchor(
                                lstMenu: [
                                  customMenuItemButton(
                                    title: 'Edit',
                                    onPressed: () {
                                      if (AppPreferences.getUserProfileData()!
                                              .userAccountsDetails!
                                              .first
                                              .privileges!
                                              .contains('Write') &&
                                          rowRole
                                              .where(
                                                (element) =>
                                                    element.name == 'CEO',
                                              )
                                              .toList()
                                              .isEmpty) {
                                        customSnackBar(
                                          title: 'Error',
                                          message: "You Can't edit this user.",
                                          alertType: AlertType.alertError,
                                        );
                                      } else {
                                        controller.onRowEditOptionTap(
                                          rowData: row,
                                        );
                                      }
                                    },
                                  ),
                                  customMenuItemButton(
                                    title: 'Delete    ',
                                    onPressed: () =>
                                        controller.onRowDeleteOptionTap(
                                      rowData: row,
                                    ),
                                  ),
                                  customMenuItemButton(
                                    title: 'Set Password',
                                    onPressed: () {
                                      controller.resetByAdminDailog(
                                          rowData: row);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                        textAlign: TextAlign.right,
                      ),
                    ],
                    verticalItemPadding: null,
                    sourceOriginal: controller.usersDataTableData.toList(),
                    headerActionTitle: 'Create User',
                    headerActionOnPressed: () =>
                        controller.onCreateUserTap(isUpdate: false),
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
