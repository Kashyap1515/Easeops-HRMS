import 'package:easeops_web_hrms/app_export.dart';
import 'package:easeops_web_hrms/screens/configuration_pages/config_role_screen/controller/config_role_controller.dart';

class ConfigRoleScreen extends GetView<ConfigRoleController> {
  const ConfigRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: GetBuilder(
        init: controller,
        initState: (state) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await controller.getRoleAPIData();
          });
        },
        builder: (context) {
          return ConfigurationMainLayout(
            configurationTypes: ConfigurationTypes.roles,
            body: dataBody(),
          );
        },
      ),
    );
  }

  Widget dataBody() {
    return Obx(
      () => CustomDataTable(
        isLoading: controller.isRoleLoading.value,
        searchKey: 'role',
        headers: [
          customDatatableHeader(lblValue: 'Role', flex: 3),
          customDatatableHeader(lblValue: 'Access', flex: 3),
          customDatatableHeader(lblValue: 'Description', flex: 8),
          DatatableHeader(
            flex: 2,
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
                        onPressed: () =>
                            controller.onRowEditOptionTap(rowData: row),
                      ),
                      customMenuItemButton(
                        title: 'Delete',
                        onPressed: () =>
                            controller.onRowDeleteOptionTap(rowData: row),
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
        sourceOriginal: controller.rolesDataTableData.toList(),
        headerActionTitle: 'Create Role',
        headerActionOnPressed: () =>
            controller.onCreateRoleTap(isUpdate: false),
      ),
    );
  }
}
