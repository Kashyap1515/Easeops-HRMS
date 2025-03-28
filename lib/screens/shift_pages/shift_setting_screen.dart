import 'package:easeops_web_hrms/app_export.dart';
import 'package:easeops_web_hrms/screens/shift_pages/controller/shift_controller.dart';

class ShiftScreen extends GetView<ShiftController> {
  const ShiftScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: GetBuilder(
        init: controller,
        initState: (state) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await controller.getShiftListAPIData();
          });
        },
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.kcWhiteColor,
                  border: Border(
                    right: BorderSide(color: AppColors.kcBorderColor),
                  ),
                ),
                width: Get.size.width,
                padding: symetricV16H24,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Shift Details',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.kcBlackColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1),
              sbh10,
              dataBody(),
            ],
          );
        },
      ),
    );
  }

  Widget dataBody() {
    return Obx(
      () => CustomDataTable(
        searchKey: 'name',
        headers: [
          customDatatableHeader(lblValue: 'Name', flex: 4),
          customDatatableHeader(lblValue: 'Start Time', flex: 2),
          customDatatableHeader(lblValue: 'End Time', flex: 2),
          DatatableHeader(
            textAlign: TextAlign.start,
            text: 'Users',
            value: 'users_list',
            sourceBuilder: (value, row) {
              final users = row['users_list'];
              final userCount = users?.length ?? 0;
              final isMultipleUsers = userCount > 1;
              final displayText = isMultipleUsers
                  ? '$userCount users'
                  : (userCount == 1 ? users[0]['name'] : '');
              return InkWell(
                onTap: () {
                  if (isMultipleUsers) {
                    final assignedUsers = List<AssignedUser>.from(
                      users.map((user) => AssignedUser.fromJson(user)),
                    );
                    controller.onRowAssignedUserTap(
                      rowUser: assignedUsers,
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Text(
                    displayText,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.kcBlackColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              );
            },
          ),
          DatatableHeader(
            text: 'Action',
            value: 'action',
            sourceBuilder: (value, row) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomMenuAnchor(
                    lstMenu: [
                      customMenuItemButton(
                        title: 'Edit',
                        onPressed: () {
                          controller.currentStep.value = 0;
                          controller.onRowEditOptionTap(rowData: row);
                        },
                      ),
                      customMenuItemButton(
                        title: 'Delete',
                        onPressed: () {
                          controller.onRowDeleteOptionTap(rowData: row);
                        },
                      ),
                      customMenuItemButton(
                        title: 'Assign to user',
                        onPressed: () {
                          controller.currentStep.value = 1;
                          controller.onRowEditOptionTap(rowData: row);
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
        verticalItemPadding: 11,
        isLoading: controller.isLoading.value,
        sourceOriginal: controller.shiftTableData.toList(),
        headerActionTitle: 'Create Shift',
        headerActionOnPressed: () {
          controller.currentStep.value = 0;
          controller.onCreateShiftTap(isUpdate: false);
        },
      ),
    );
  }
}
