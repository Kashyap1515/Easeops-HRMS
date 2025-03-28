import 'package:easeops_web_hrms/app_export.dart';
import 'package:easeops_web_hrms/screens/configuration_pages/config_location_screen/controller/config_location_controller.dart';

class ConfigLocationScreen extends GetView<ConfigLocationController> {
  const ConfigLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: GetBuilder(
        init: controller,
        initState: (state) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await controller.getLocationAPIData();
          });
        },
        builder: (context) {
          return ConfigurationMainLayout(
            configurationTypes: ConfigurationTypes.locations,
            body: Obx(
              () => CustomDataTable(
                isLoading: controller.isLocationLoading.value,
                searchKey: 'alias',
                headers: [
                  customDatatableHeader(lblValue: 'Alias', flex: 2),
                  customDatatableHeader(lblValue: 'Location', flex: 7),
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
                                onPressed: () => controller
                                    .onRowDeleteOptionTap(rowData: row),
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
                sourceOriginal: controller.locationDataTableData.toList(),
                headerActionTitle: 'Create Location',
                headerActionOnPressed: () =>
                    controller.onCreateLocationTap(isUpdate: false),
              ),
            ),
          );
        },
      ),
    );
  }
}
