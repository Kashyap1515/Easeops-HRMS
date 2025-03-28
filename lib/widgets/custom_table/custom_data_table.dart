import 'package:adaptivex/adaptivex.dart';
import 'package:easeops_web_hrms/app_export.dart';
import 'package:easeops_web_hrms/widgets/custom_table/responsive_datatable_lib.dart';

class CustomDataTable extends StatefulWidget {
  const CustomDataTable({
    required this.headers,
    required this.sourceOriginal,
    super.key,
    this.selected,
    this.headerWidgets,
    this.headerWidgets1,
    this.headerWidgets2,
    this.verticalItemPadding,
    this.padding,
    this.headerSearchWidth,
    this.headerActionTitle,
    this.headerAction1Title,
    this.headerAction2Title,
    this.headerAction3Title,
    this.headerActionOnPressed,
    this.headerAction1OnPressed,
    this.headerAction2OnPressed,
    this.headerAction3OnPressed,
    this.margin,
    this.rowDecoration,
    this.isShowHeader = true,
    this.isLoading = false,
    this.isShowFooter = true,
    this.hideHeaders = false,
    this.showSelect = false,
    this.searchKey = 'id',
    this.searchKey1 = 'id',
    this.searchKey2 = 'id',
    this.searchKey3 = 'id',
    this.onTabRow,
    this.onTabSelect,
    this.onChangedRow,
    this.isHome = false,
  });

  final List<DatatableHeader> headers;
  final List<Map<String, dynamic>> sourceOriginal;
  final List<Map<String, dynamic>>? selected;
  final double? headerSearchWidth;
  final bool hideHeaders;
  final double? verticalItemPadding;
  final EdgeInsets? padding;
  final Widget? headerWidgets;
  final Widget? headerWidgets1;
  final Widget? headerWidgets2;
  final String? headerActionTitle;
  final String? headerAction1Title;
  final String? headerAction2Title;
  final String? headerAction3Title;
  final BoxDecoration? rowDecoration;
  final String? searchKey;
  final String? searchKey1;
  final String? searchKey2;
  final String? searchKey3;
  final VoidCallback? headerActionOnPressed;
  final VoidCallback? headerAction1OnPressed;
  final VoidCallback? headerAction2OnPressed;
  final VoidCallback? headerAction3OnPressed;
  final EdgeInsetsGeometry? margin;
  final bool isShowHeader;
  final bool showSelect;
  final bool isLoading;
  final bool isShowFooter;
  final bool isHome;
  final Function(Map<String, dynamic>)? onTabRow;
  final Function(List<Map<String, dynamic>>)? onTabSelect;
  final Function(Map<String, dynamic>, DatatableHeader)? onChangedRow;

  @override
  DataPageState createState() => DataPageState();
}

class DataPageState extends State<CustomDataTable> {
  TextEditingController textEditingController = TextEditingController();

  final List<int> perPages = [5, 10, 20, 50, 100, 500, 1000];
  int total = 0;
  int currentPerPage = 20;
  List<bool>? expanded;
  int currentPage = 1;
  bool isSearch = false;
  List<Map<String, dynamic>> sourceFiltered = [];
  List<Map<String, dynamic>> source = [];
  List<Map<String, dynamic>> selected = [];
  String? sortColumn;
  bool sortAscending = true;
  bool isLoading = true;

  Future<void> initializeData() async {
    isLoading = widget.isLoading;
    selected = widget.selected ?? [];
    total = widget.sourceOriginal.length;
    await mockPullData();
  }

  Future<void> mockPullData() async {
    expanded = List.generate(
      total < currentPerPage || !widget.isShowFooter ? total : currentPerPage,
      (index) => false,
    );
    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 300)).then((value) {
      sourceFiltered = widget.sourceOriginal;
      total = sourceFiltered.length;
      source = sourceFiltered
          .getRange(
            0,
            total < currentPerPage || !widget.isShowFooter
                ? total
                : currentPerPage,
          )
          .toList();
      setState(() => isLoading = false);
    });
  }

  Future<void> resetData({start = 0}) async {
    setState(() => isLoading = true);
    final expandedLen = total - start <
            (total < currentPerPage || !widget.isShowFooter
                ? total
                : currentPerPage)
        ? total - start
        : (total < currentPerPage || !widget.isShowFooter
            ? total
            : currentPerPage);
    await Future.delayed(Duration.zero).then((value) {
      expanded = List.generate(expandedLen as int, (index) => false);
      source.clear();
      source = sourceFiltered.getRange(start, start + expandedLen).toList();
      setState(() => isLoading = false);
    });
  }

  Future<void> filterData(value) async {
    setState(() => isLoading = true);
    try {
      if (value == '' || value == null) {
        sourceFiltered = widget.sourceOriginal;
      } else {
        sourceFiltered = widget.sourceOriginal
            .where(
              (data) =>
                  data[widget.searchKey!.toLowerCase()]
                      .toString()
                      .toLowerCase()
                      .contains(value.toString().toLowerCase()) ||
                  data[widget.searchKey1!.toLowerCase()]
                      .toString()
                      .toLowerCase()
                      .contains(value.toString().toLowerCase()) ||
                  data[widget.searchKey2!.toLowerCase()]
                      .toString()
                      .toLowerCase()
                      .contains(value.toString().toLowerCase()) ||
                  data[widget.searchKey3!.toLowerCase()]
                      .toString()
                      .toLowerCase()
                      .contains(value.toString().toLowerCase()),
            )
            .toList();
      }

      total = sourceFiltered.length;
      final rangeTop = total <
              (total < currentPerPage || !widget.isShowFooter
                  ? total
                  : currentPerPage)
          ? total
          : (total < currentPerPage || !widget.isShowFooter
              ? total
              : currentPerPage);
      expanded = List.generate(rangeTop, (index) => false);
      source = sourceFiltered.getRange(0, rangeTop).toList();
    } catch (e) {
      Logger.log(e);
    }
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    widget.isLoading ? initializeData() : null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.isShowHeader)
          Container(
            margin: widget.margin ?? symetricV16H24.copyWith(bottom: 0),
            decoration: BoxDecoration(
              color: AppColors.kcWhiteColor,
              borderRadius: br4,
              border: Border.all(
                color: AppColors.kcBorderColor,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: widget.headerWidgets != null ||
                      widget.headerWidgets1 != null ||
                      widget.headerWidgets2 != null
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: CustomTextFormField(
                      txtFormWidth: widget.headerSearchWidth,
                      heightForm: 30,
                      isFillKcLightGrey: true,
                      textEditingController: textEditingController,
                      hintText: 'Search Here',
                      prefixIcon: Icons.search,
                      paddingVertical: 0,
                      onChangedCallBack: (value) {
                        filterData(value);
                        return null;
                      },
                      onSubmitCallback: (value) {
                        filterData(value);
                        return null;
                      },
                    ),
                  ),
                ),
                sbw10,
                if (widget.headerWidgets != null)
                  Flexible(child: widget.headerWidgets ?? const SizedBox()),
                sbw10,
                if (widget.headerWidgets1 != null)
                  Flexible(child: widget.headerWidgets1 ?? const SizedBox()),
                sbw10,
                if (widget.headerWidgets2 != null)
                  Flexible(child: widget.headerWidgets2 ?? const SizedBox()),
                Spacer(
                  flex: widget.headerWidgets == null ? 2 : 1,
                ),
                Spacer(
                  flex: widget.headerWidgets == null ? 2 : 1,
                ),
                if (widget.headerAction3Title != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: CustomElevatedButton(
                      btnPressed: widget.headerAction3OnPressed ?? () {},
                      btnText: widget.headerAction3Title ?? '',
                      btnHeight: btnHeight,
                      borderRadius: btnBorderRadius,
                      btnTxtColor: AppColors.kcHeaderButtonColor,
                      btnColor: AppColors.kcDrawerColor,
                    ),
                  ),
                if (widget.headerAction1Title != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: CustomElevatedButton(
                      btnPressed: widget.headerAction1OnPressed ?? () {},
                      btnText: widget.headerAction1Title ?? '',
                      btnHeight: btnHeight,
                      borderRadius: btnBorderRadius,
                      btnTxtColor: AppColors.kcHeaderButtonColor,
                      btnColor: AppColors.kcDrawerColor,
                    ),
                  ),
                if (widget.headerAction2Title != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: CustomElevatedButton(
                      btnPressed: widget.headerAction2OnPressed ?? () {},
                      btnText: widget.headerAction2Title ?? '',
                      btnHeight: 40,
                      borderRadius: 4,
                      btnTxtColor: AppColors.kcHeaderButtonColor,
                      btnColor: AppColors.kcDrawerColor,
                    ),
                  ),
                if (widget.headerActionTitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 0, bottom: 2),
                    child: CustomElevatedButton(
                      btnPressed: widget.headerActionOnPressed ?? () {},
                      btnText: widget.headerActionTitle ?? '',
                      btnHeight: btnHeight,
                      borderRadius: btnBorderRadius,
                      btnColor: AppColors.kcHeaderButtonColor,
                    ),
                  )
                else
                  const SizedBox(height: 44),
                sbw10,
              ],
            ),
          ),
        Container(
          margin: widget.margin ?? symetricV16H24,
          decoration: BoxDecoration(
            color: AppColors.kcWhiteColor,
            border: widget.hideHeaders
                ? const Border(
                    top: BorderSide(color: AppColors.kcBorderColor),
                  )
                : null,
          ),
          padding: EdgeInsets.zero,
          child: OurResponsiveDatatable(
            reponseScreenSizes: const [ScreenSize.xs],
            verticalItemPadding: widget.verticalItemPadding,
            padding: widget.padding,
            headerDecoration: BoxDecoration(
              color: widget.isHome
                  ? AppColors.kcWhiteColor
                  : AppColors.kcTableHeaderColor,
            ),
            headerTextStyle: GoogleFonts.inter(
              fontSize: 14,
              color: widget.isHome
                  ? AppColors.kcTableHeaderColor
                  : AppColors.kcWhiteColor,
              fontWeight: FontWeight.w600,
            ),
            rowTextStyle: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.kcBlackColor,
              fontWeight: FontWeight.w400,
            ),
            selectedTextStyle: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.kcBlackColor,
              fontWeight: FontWeight.w400,
            ),
            headers: widget.headers,
            hideHeaders: widget.hideHeaders,
            source: source,
            selecteds: selected,
            showSelect: widget.showSelect,
            autoHeight: false,
            isExpandRows: false,
            onChangedRow: widget.onChangedRow,
            onSubmittedRow: (value, header) {},
            rowDecoration: widget.rowDecoration ??
                BoxDecoration(
                  border: widget.isHome
                      ? const Border(
                          top: BorderSide(color: AppColors.kcBorderColor),
                        )
                      : const Border(
                          bottom: BorderSide(color: AppColors.kcBorderColor),
                          left: BorderSide(color: AppColors.kcBorderColor),
                          right: BorderSide(color: AppColors.kcBorderColor),
                        ),
                ),
            selectedDecoration: BoxDecoration(
              color: AppColors.kcAccentColor100,
              border: widget.isHome
                  ? const Border(
                      top: BorderSide(color: AppColors.kcBorderColor),
                    )
                  : const Border(
                      bottom: BorderSide(color: AppColors.kcBorderColor),
                      left: BorderSide(color: AppColors.kcBorderColor),
                      right: BorderSide(color: AppColors.kcBorderColor),
                    ),
            ),
            onTabRow: (data) {
              selected.clear();
              setState(() => selected.add(data));
              if (widget.onTabRow != null) {
                widget.onTabRow!(data);
              }
            },
            onSort: (value) {
              setState(() => isLoading = true);
              setState(() {
                sortColumn = value;
                sortAscending = !sortAscending;
                if (sortAscending) {
                  sourceFiltered.sort(
                    (a, b) => b['$sortColumn'].compareTo(a['$sortColumn']),
                  );
                } else {
                  sourceFiltered.sort(
                    (a, b) => a['$sortColumn'].compareTo(b['$sortColumn']),
                  );
                }
                final rangeTop = (total < currentPerPage || !widget.isShowFooter
                            ? total
                            : currentPerPage) <
                        sourceFiltered.length
                    ? (total < currentPerPage || !widget.isShowFooter
                        ? total
                        : currentPerPage)
                    : sourceFiltered.length;
                source = sourceFiltered.getRange(0, rangeTop).toList();
                // widget.searchKey = value;
                isLoading = false;
              });
            },
            expanded: expanded,
            sortAscending: sortAscending,
            sortColumn: sortColumn,
            isLoading: isLoading,
            onSelect: (value, item) {
              if (value!) {
                setState(() => selected.add(item));
                if (widget.onTabRow != null || widget.onTabSelect != null) {
                  widget.onTabSelect!(selected);
                }
              } else {
                setState(() => selected.removeAt(selected.indexOf(item)));
                widget.onTabSelect!(selected);
              }
            },
            onSelectAll: (value) {
              if (value!) {
                setState(
                  () => selected = source.map((entry) => entry).toList().cast(),
                );
                widget.onTabSelect!(selected);
              } else {
                setState(() => selected.clear());
                widget.onTabSelect!(selected);
              }
            },
            footers: widget.isShowFooter ? tableFooters() : null,
          ),
        ),
      ],
    );
  }

  List<Widget> tableFooters() {
    return [
      Flexible(
        child: Container(
          decoration: widget.isHome
              ? null
              : const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.kcBorderColor),
                    left: BorderSide(color: AppColors.kcBorderColor),
                    right: BorderSide(color: AppColors.kcBorderColor),
                  ),
                ),
          child: Row(
            children: [
              if (perPages.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: DropdownButton<int>(
                    value: currentPerPage,
                    items: perPages
                        .map(
                          (e) => DropdownMenuItem<int>(
                            value: e,
                            child: Text('$e'),
                          ),
                        )
                        .toList(),
                    dropdownColor: AppColors.kcWhiteColor,
                    elevation: 0,
                    onChanged: (dynamic value) {
                      setState(() {
                        currentPerPage = value;
                        currentPage = 1;
                        resetData();
                      });
                    },
                  ),
                ),
              Text('Per Pages | Showing $currentPerPage out of $total'),
              const Spacer(),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 16,
                    ),
                    onPressed: currentPage == 1
                        ? null
                        : () {
                            setState(() {
                              currentPage = 1;
                              resetData(start: 1);
                            });
                          },
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 16,
                    ),
                    onPressed: currentPage == 1
                        ? null
                        : () {
                            final nextSet = currentPage - currentPerPage;
                            setState(() {
                              currentPage = nextSet > 1 ? nextSet : 1;
                              resetData(start: currentPage - 1);
                            });
                          },
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 16),
                    onPressed: currentPage + currentPerPage - 1 > total
                        ? null
                        : () {
                            final nextSet = currentPage + currentPerPage;
                            setState(() {
                              currentPage = nextSet < total
                                  ? nextSet
                                  : total - currentPerPage;
                              resetData(start: nextSet - 1);
                            });
                          },
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 16),
                    onPressed: currentPage + currentPerPage - 1 > total
                        ? null
                        : () {
                            final nextSet = currentPage + currentPerPage;
                            setState(() {
                              currentPage = nextSet < total
                                  ? nextSet
                                  : total - currentPerPage;
                              resetData(start: nextSet - 1);
                            });
                          },
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ];
  }
}

DatatableHeader customDatatableHeader({
  required String lblValue,
  int flex = 1,
  bool sortable = true,
  bool isClickable = false,
}) {
  return DatatableHeader(
    text: lblValue,
    value: lblValue.trim().toLowerCase().replaceAll(' ', '_'),
    flex: flex,
    sortable: sortable,
    textAlign: TextAlign.left,
    isClickable: isClickable,
  );
}

// class DropDownContainer extends StatelessWidget {
//   final Map<String, dynamic> data;
//
//   const DropDownContainer({Key? key, required this.data}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     List<Widget> children = data.entries.map<Widget>((entry) {
//       Widget w = Row(
//         children: [
//           Text(entry.key.toString()),
//           const Spacer(),
//           Text(entry.value.toString()),
//         ],
//       );
//       return w;
//     }).toList();
//
//     return Column(
//       children: children,
//     );
//   }
// }
