// library multiselect_dropdown_flutter;

import 'package:easeops_web_hrms/app_export.dart';

const double tileHeight = 40;
const double selectAllButtonHeight = 40;
const double searchOptionHeight = 40;

class MultiSelectDropdownSchedule extends StatefulWidget {
  const MultiSelectDropdownSchedule({
    required this.list,
    required this.initiallySelected,
    required this.isOnTapValid,
    required this.onChange,
    super.key,
    this.label = 'label',
    this.title,
    this.id = 'id',
    this.errorMsg = '',
    this.numberOfItemsLabelToShow = 3,
    this.boxDecoration,
    this.width,
    this.height,
    this.whenEmpty = 'Select options',
    this.selectAllTitle = '',
    this.isLarge = false,
    this.isLoading = false,
    this.includeSelectAll = false,
    this.includeSearch = false,
    this.textStyle,
    this.duration = const Duration(milliseconds: 300),
    this.checkboxFillColor,
    this.splashColor,
    this.listTextStyle,
    this.padding,
  }) : isSimpleList = false;

  /// Mutiple selection dropdown for simple List.
  const MultiSelectDropdownSchedule.simpleList({
    required this.list,
    required this.initiallySelected,
    required this.onChange,
    super.key,
    this.numberOfItemsLabelToShow = 3,
    this.boxDecoration,
    this.isOnTapValid,
    this.title,
    this.errorMsg = '',
    this.width,
    this.height,
    this.whenEmpty = 'Select options',
    this.selectAllTitle = '',
    this.isLarge = false,
    this.isLoading = false,
    this.includeSelectAll = false,
    this.includeSearch = false,
    this.textStyle,
    this.duration = const Duration(milliseconds: 300),
    this.checkboxFillColor,
    this.splashColor,
    this.listTextStyle,
    this.padding,
  })  : label = '',
        id = '',
        isSimpleList = true;

  /// List of options to select from
  final List list;

  /// `label` key in a Map to show as an option. Defaults to 'label'
  final String label;
  final String? title;
  final String selectAllTitle;
  final String errorMsg;
  final double? height;

  /// `id` key in a Map to identify an item. Defaults to 'id'
  final String id;

  final bool? isOnTapValid;

  /// `onChange` callback, called everytime when
  /// an item is added or removed with the new
  /// list as argument
  ///
  /// {@tool snippet}
  /// ```dart
  /// onChange: (List newList) {
  ///   setState(() {
  ///     selectedList = newList;
  ///   });
  /// }
  /// ```
  /// {@end-tool}
  final ValueChanged<List> onChange;

  /// Number of items to show as text,
  /// beyond that it will show `n` selected
  final int numberOfItemsLabelToShow;

  /// Initially selected list
  final List initiallySelected;

  /// Decoration for input element
  final Decoration? boxDecoration;

  /// Dropdown size
  final bool isLarge;
  final bool isLoading;

  /// If the list is a simple list
  /// or a list of map
  final bool isSimpleList;

  /// Width of the input widget. If this
  /// is null the widget will try to take
  /// full width of the parent.
  ///
  /// When rendering in a Row it needs to have
  /// a strict parent or a fixed width as it grows
  /// horizontally
  final double? width;

  /// Text to show when selected list is empty
  final String whenEmpty;

  /// Includes a select all button when `true`
  final bool includeSelectAll;

  /// Includes a search option when `true`
  final bool includeSearch;

  /// `TextStyle?` for the text on anchor element.
  final TextStyle? textStyle;

  /// `Duration?` for debounce in search option.
  /// Defaults to 300 milliseconds.
  final Duration duration;

  /// Checkbox fill color in list tile.
  final Color? checkboxFillColor;

  /// Splash color on the list tile when the list is clicked.
  final Color? splashColor;

  /// TextStyle for the text on list tile.
  final TextStyle? listTextStyle;

  /// Padding for the input element.
  final EdgeInsets? padding;

  @override
  State<MultiSelectDropdownSchedule> createState() =>
      _MultiSelectDropdownScheduleState();
}

class _MultiSelectDropdownScheduleState
    extends State<MultiSelectDropdownSchedule> {
  late List selected = [...widget.initiallySelected];
  late final Decoration boxDecoration;
  List filteredOptions = [];

  late final TextEditingController filterController;
  Timer? debounce;

  bool isSelected(dynamic data) {
    if (widget.isSimpleList) {
      return selected.contains(data);
    } else {
      for (final Map obj in selected) {
        if (obj[widget.id] == data) {
          return true;
        }
      }
      return false;
    }
  }

  void handleOnChange({required bool newValue, dynamic data}) {
    if (newValue) {
      setState(() {
        selected.add(data);
      });
    } else {
      if (widget.isSimpleList) {
        setState(() {
          selected.remove(data);
        });
      } else {
        final itemIndex = selected.indexWhere(
          (obj) => obj[widget.id] == data[widget.id],
        );
        if (itemIndex == -1) {
          return;
        } else {
          setState(() {
            selected.removeAt(itemIndex);
          });
        }
      }
    }

    widget.onChange(selected);
  }

  Widget buildTile(dynamic data) {
    if (widget.isSimpleList) {
      return _CustomTile(
        value: isSelected(data),
        onChanged: (bool newValue) {
          handleOnChange(newValue: newValue, data: data);
        },
        isOnTappTrue: widget.isOnTapValid,
        title: '$data',
        checkboxFillColor: widget.checkboxFillColor ?? Colors.transparent,
        splashColor: widget.splashColor ?? Colors.transparent,
        textStyle: widget.listTextStyle,
      );
    } else {
      return _CustomTile(
        value: isSelected(data[widget.id]),
        onChanged: (bool newValue) {
          handleOnChange(newValue: newValue, data: data);
        },
        isOnTappTrue: widget.isOnTapValid,
        title: '${data[widget.label]}',
        checkboxFillColor: widget.checkboxFillColor ?? Colors.transparent,
        splashColor: widget.splashColor ?? Colors.transparent,
        textStyle: widget.listTextStyle,
      );
    }
  }

  String? onSearchTextChanged(String? searchText) {
    if (debounce?.isActive ?? false) debounce?.cancel();

    debounce = Timer(widget.duration, () {
      if (searchText!.isEmpty) {
        setState(() {
          filteredOptions = widget.list;
        });
      } else {
        searchText.toLowerCase();
        if (widget.isSimpleList) {
          final newList = widget.list.where((text) {
            return '$text'.toLowerCase().contains(searchText);
          }).toList();
          setState(() {
            filteredOptions = newList;
          });
        } else {
          final newList = widget.list.where((objData) {
            return '${objData[widget.label]}'
                .toLowerCase()
                .contains(searchText);
          }).toList();
          setState(() {
            filteredOptions = newList;
          });
        }
      }
    });
    return null;
  }

  Widget buildSearchOption() {
    return Padding(
      padding: all10,
      child: CustomTextFormField(
        // prefixIcon: Icons.search,
        textEditingController: filterController,
        onChangedCallBack: onSearchTextChanged,
        paddingVertical: 10,
      ),
    );
  }

  Widget buildSelectAllButton() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey),
              ),
            ),
            child: _CustomTile(
              value: selected.length == filteredOptions.length,
              onChanged: (bool newValue) {
                if (selected.length == filteredOptions.length) {
                  selected.clear();
                } else {
                  selected.clear();
                  selected = [...filteredOptions];
                }
                widget.onChange(selected);
                setState(() {});
              },
              isOnTappTrue: widget.isOnTapValid,
              title: widget.selectAllTitle == ''
                  ? 'Select all'
                  : widget.selectAllTitle,
              checkboxFillColor: widget.checkboxFillColor ?? Colors.transparent,
              splashColor: widget.splashColor ?? Colors.transparent,
              textStyle: widget.listTextStyle,
            ),
          ),
        ),
        // Expanded(
        //   child: Container(
        //     height: selectAllButtonHeight,
        //     alignment: Alignment.centerLeft,
        //     padding: const EdgeInsets.symmetric(horizontal: 18),
        //     decoration: const BoxDecoration(
        //       border: Border(
        //         bottom: BorderSide(color: Colors.grey),
        //       ),
        //     ),
        //     child: Text(
        //         '${widget.selectAllTitle == '' ? 'Select all' : widget.selectAllTitle}'),
        //   ),
        // ),
      ],
    );
  }

  double getWidth(BoxConstraints boxConstraints) {
    if (widget.width != null &&
        widget.width != double.infinity &&
        widget.width != double.maxFinite) {
      return widget.width!;
    }
    if (boxConstraints.maxWidth == double.infinity ||
        boxConstraints.maxWidth == double.maxFinite) {
      Logger.log(
        "Invalid width given, MultiSelectDropdownSchedule's width will fallback to 250.",
      );
      return 250;
    }
    return boxConstraints.maxWidth;
  }

  double getModalHeight() {
    var height = filteredOptions.length > 4
        ? widget.isLarge
            ? filteredOptions.length > 6
                ? 8 * tileHeight
                : filteredOptions.length * tileHeight
            : 6 * tileHeight
        : filteredOptions.length * tileHeight;

    if (widget.includeSelectAll) {
      height += selectAllButtonHeight;
    }

    if (widget.includeSearch) {
      height += searchOptionHeight + 20;
    }

    return height;
  }

  String buildText() {
    if (selected.isEmpty) {
      return widget.whenEmpty;
    }

    if (widget.numberOfItemsLabelToShow < selected.length) {
      return (selected.length == widget.list.length &&
              widget.selectAllTitle != '')
          ? widget.selectAllTitle
          : '${selected.length} selected';
    }

    if (widget.isSimpleList) {
      final itemsToShow = selected.length;
      var finalString = '';
      for (var i = 0; i < itemsToShow; i++) {
        finalString = '$finalString ${selected[i]}, ';
      }
      return finalString.substring(0, finalString.length - 2);
    } else {
      final itemsToShow = selected.length;
      var finalString = '';
      for (var i = 0; i < itemsToShow; i++) {
        finalString = '$finalString ${selected[i][widget.label]}, ';
      }
      return finalString.substring(0, finalString.length - 2);
    }
  }

  @override
  void initState() {
    super.initState();
    filterController = TextEditingController();
    filteredOptions = [...widget.list];
    boxDecoration = widget.boxDecoration ??
        BoxDecoration(
          borderRadius: br2,
          color: AppColors.kcLightGrey,
          border: Border.all(color: AppColors.kcBorderStrokesColor),
        );
  }

  @override
  void dispose() {
    filterController.dispose();
    debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textToShow = buildText();
    final modalHeight = getModalHeight();

    // final scheduleProvider = Provider.of<ScheduleAssessProvider>(context);

    // if (scheduleProvider.isSelectedListToBeCleared == true) {
    //   Logger.log('IN THE MULTI SELECT');
    //   selected.clear();
    //   scheduleProvider.isSelectedListToBeCleared = false;
    //   Logger.log('LIST VALUE: $selected');
    //   textToShow = widget.whenEmpty;
    //   setState(() {});
    // }

    return LayoutBuilder(
      builder: (ctx, boxConstraints) {
        final modalWidth = getWidth(boxConstraints);

        return ConstrainedBox(
          constraints: BoxConstraints.expand(
            height: tileHeight,
            width: modalWidth,
          ),
          child: MenuAnchor(
            crossAxisUnconstrained: false,
            style: MenuStyle(
              fixedSize: WidgetStateProperty.resolveWith((states) {
                return Size(modalWidth, modalHeight);
              }),
              shadowColor: WidgetStateProperty.all(AppColors.kcDrawerColor),
              backgroundColor: WidgetStateProperty.all(AppColors.kcDrawerColor),
              elevation: WidgetStateProperty.all(0),
              padding: WidgetStateProperty.resolveWith((states) {
                return EdgeInsets.zero;
              }),
              side: WidgetStateProperty.all(
                const BorderSide(
                  color: AppColors.kcTextLightColor,
                ),
              ),
            ),
            builder: (context, controller, _) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.title != null)
                    Text(
                      widget.title ?? '',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.kcBlackColor,
                      ),
                    ),
                  if (widget.title != null) sbh2,
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        if (controller.isOpen) {
                          controller.close();
                        } else {
                          controller.open();
                        }
                      },
                      child: Container(
                        padding: widget.padding ??
                            const EdgeInsets.symmetric(horizontal: 12),
                        decoration: boxDecoration,
                        width: modalWidth,
                        height: widget.height,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Text(
                                textToShow,
                                style: widget.whenEmpty == textToShow
                                    ? GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.kcTextLightColor,
                                      )
                                    : GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.kcBlackColor,
                                      ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down_sharp),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (widget.errorMsg != '')
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 4),
                      child: Text(
                        widget.errorMsg,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: AppColors.kcDangerColor,
                        ),
                      ),
                    ),
                ],
              );
            },
            menuChildren: [
              if (widget.includeSearch) buildSearchOption(),
              if (widget.includeSelectAll) buildSelectAllButton(),
              ...filteredOptions.map(buildTile),
            ],
          ),
        );
      },
    );
  }
}

// Simple list tiles in the modal
class _CustomTile extends StatelessWidget {
  const _CustomTile({
    required this.title,
    required this.value,
    required this.onChanged,
    required this.isOnTappTrue,
    this.checkboxFillColor,
    this.splashColor,
    this.textStyle,
  });

  final String title;
  final bool value;
  final bool? isOnTappTrue;
  final ValueChanged<bool> onChanged;

  final Color? checkboxFillColor;
  final Color? splashColor;
  final TextStyle? textStyle;

  void handleOnChange() {
    if (value) {
      onChanged(false);
    } else {
      onChanged(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isOnTappTrue! ? handleOnChange : null,
      child: SizedBox(
        height: tileHeight,
        child: Row(
          children: [
            const SizedBox(width: 6),
            Checkbox(
              activeColor: AppColors.kcPrimaryColor,
              fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.kcPrimaryColor;
                }
                return Colors.transparent;
              }),
              splashRadius: 0,
              side: const BorderSide(
                color: AppColors.kcTextLightColor,
                width: 0.8,
              ),
              value: value,
              onChanged: (val) {
                isOnTappTrue! ? handleOnChange() : null;
              },
            ),
            sbw5,
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.kcBlackColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
