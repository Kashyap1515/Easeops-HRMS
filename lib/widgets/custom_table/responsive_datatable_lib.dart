import 'package:adaptivex/adaptivex.dart';
import 'package:easeops_web_hrms/app_export.dart';


class OurResponsiveDatatable extends StatefulWidget {
  const OurResponsiveDatatable({
    super.key,
    this.showSelect = false,
    this.onSelectAll,
    this.onSelect,
    this.onTabRow,
    this.onSort,
    this.headers = const [],
    this.hideHeaders = false,
    this.source,
    this.selecteds,
    this.title,
    this.actions,
    this.footers,
    this.sortColumn,
    this.verticalItemPadding,
    this.padding,
    this.sortAscending,
    this.isLoading = false,
    this.autoHeight = true,
    this.hideUnderline = true,
    this.commonMobileView = false,
    this.isExpandRows = true,
    this.expanded,
    this.dropContainer,
    this.onChangedRow,
    this.onSubmittedRow,
    this.reponseScreenSizes = const [
      ScreenSize.xs,
      ScreenSize.sm,
      ScreenSize.md,
    ],
    this.headerDecoration,
    this.rowDecoration,
    this.selectedDecoration,
    this.headerTextStyle,
    this.rowTextStyle,
    this.selectedTextStyle,
  });

  final bool showSelect;
  final List<DatatableHeader> headers;
  final List<Map<String, dynamic>>? source;
  final List<Map<String, dynamic>>? selecteds;
  final Widget? title;
  final List<Widget>? actions;
  final List<Widget>? footers;
  final Function(bool? value)? onSelectAll;
  final Function(bool? value, Map<String, dynamic> data)? onSelect;
  final Function(Map<String, dynamic> value)? onTabRow;
  final Function(dynamic value)? onSort;
  final String? sortColumn;
  final bool hideHeaders;
  final bool? sortAscending;
  final double? verticalItemPadding;
  final EdgeInsets? padding;
  final bool isLoading;
  final bool autoHeight;
  final bool hideUnderline;
  final bool commonMobileView;
  final bool isExpandRows;
  final List<bool>? expanded;
  final Widget Function(Map<String, dynamic> value)? dropContainer;
  final Function(Map<String, dynamic> value, DatatableHeader header)?
      onChangedRow;
  final Function(Map<String, dynamic> value, DatatableHeader header)?
      onSubmittedRow;
  final List<ScreenSize> reponseScreenSizes;

  /// `headerDecoration`
  ///
  /// allow to decorate the header row
  final BoxDecoration? headerDecoration;

  /// `rowDecoration`
  ///
  /// allow to decorate the data row
  final BoxDecoration? rowDecoration;

  /// `selectedDecoration`
  ///
  /// allow to decorate the selected data row
  final BoxDecoration? selectedDecoration;

  /// `selectedTextStyle`
  ///
  /// allow to styling the header row
  final TextStyle? headerTextStyle;

  /// `selectedTextStyle`
  ///
  /// allow to styling the data row
  final TextStyle? rowTextStyle;

  /// `selectedTextStyle`
  ///
  /// allow to styling the selected data row
  final TextStyle? selectedTextStyle;

  @override
  ResponsiveDatatableState createState() => ResponsiveDatatableState();
}

class ResponsiveDatatableState extends State<OurResponsiveDatatable> {
  Widget mobileHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Checkbox(
          value: widget.selecteds!.length == widget.source!.length &&
              widget.source != null &&
              widget.source!.isNotEmpty,
          onChanged: (value) {
            if (widget.onSelectAll != null) {
              widget.onSelectAll!(value);
            }
          },
        ),
        PopupMenuButton(
          tooltip: 'SORT BY',
          initialValue: widget.sortColumn,
          itemBuilder: (_) => widget.headers
              .where(
                (header) => header.show == true && header.sortable == true,
              )
              .toList()
              .map(
                (header) => PopupMenuItem(
                  value: header.value,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        header.text,
                        textAlign: header.textAlign,
                      ),
                      if (widget.sortColumn != null &&
                          widget.sortColumn == header.value)
                        widget.sortAscending!
                            ? const Icon(Icons.arrow_downward, size: 15)
                            : const Icon(Icons.arrow_upward, size: 15),
                    ],
                  ),
                ),
              )
              .toList(),
          onSelected: (dynamic value) {
            try {
              if (widget.onSort != null) {
                widget.onSort!(value);
              }
            }catch(e){
              Logger.log(e);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(15),
            child: const Text('SORT BY'),
          ),
        ),
      ],
    );
  }

  List<Widget> mobileList() {
    final decoration = BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
    );
    final rowDecoration = widget.rowDecoration ?? decoration;
    final selectedDecoration = widget.selectedDecoration ?? decoration;
    return widget.source!.map((data) {
      return InkWell(
        onTap: () => widget.onTabRow?.call(data),
        child: Container(
          decoration: widget.selecteds!.contains(data)
              ? selectedDecoration
              : rowDecoration,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Spacer(),
                  if (widget.showSelect && widget.selecteds != null)
                    Checkbox(
                      value: widget.selecteds!.contains(data),
                      onChanged: (value) {
                        if (widget.onSelect != null) {
                          widget.onSelect!(value, data);
                        }
                      },
                    ),
                ],
              ),
              if (widget.commonMobileView && widget.dropContainer != null)
                widget.dropContainer!(data),
              if (!widget.commonMobileView)
                ...widget.headers
                    .where((header) => header.show == true)
                    .toList()
                    .map(
                      (header) => Container(
                        padding: const EdgeInsets.all(11),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (header.headerBuilder != null)
                              header.headerBuilder!(header.value)
                            else
                              Text(
                                header.text,
                                overflow: TextOverflow.clip,
                                style: widget.selecteds!.contains(data)
                                    ? widget.selectedTextStyle
                                    : widget.rowTextStyle,
                              ),
                            const Spacer(),
                            if (header.sourceBuilder != null)
                              header.sourceBuilder!(data[header.value], data)
                            else
                              header.editable
                                  ? TextEditableWidget(
                                      data: data,
                                      header: header,
                                      textAlign: TextAlign.end,
                                      onChanged: widget.onChangedRow,
                                      onSubmitted: widget.onSubmittedRow,
                                      hideUnderline: widget.hideUnderline,
                                    )
                                  : Text(
                                      '${data[header.value]}',
                                      style: widget.selecteds!.contains(data)
                                          ? widget.selectedTextStyle
                                          : widget.rowTextStyle,
                                    ),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ),
      );
    }).toList();
  }

  static Alignment headerAlignSwitch(TextAlign? textAlign) {
    switch (textAlign) {
      case TextAlign.center:
        return Alignment.center;
      case TextAlign.left:
        return Alignment.centerLeft;
      case TextAlign.right:
        return Alignment.centerRight;
      default:
        return Alignment.center;
    }
  }

  Widget desktopHeader() {
    final headerDecoration = widget.headerDecoration ??
        BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
        );
    return Container(
      decoration: headerDecoration,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showSelect && widget.selecteds != null)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Checkbox(
                value: widget.selecteds!.length == widget.source!.length &&
                    widget.source != null &&
                    widget.source!.isNotEmpty,
                onChanged: (value) {
                  if (widget.onSelectAll != null) {
                    widget.onSelectAll!(value);
                  }
                },
                activeColor: AppColors.kcPrimaryColor,
                side:
                    const BorderSide(color: AppColors.kcWhiteColor, width: 1.5),
              ),
            ),
          ...widget.headers.where((header) => header.show == true).map(
                (header) => Expanded(
                  flex: header.flex,
                  child: InkWell(
                    onTap: () {
                      if (widget.onSort != null && header.sortable) {
                        widget.onSort!(header.value);
                      }
                    },
                    child: header.headerBuilder != null
                        ? header.headerBuilder!(header.value)
                        : Container(
                            padding: const EdgeInsets.all(11).copyWith(
                              left: widget.showSelect ? 4 : 11,
                            ),
                            alignment: headerAlignSwitch(header.textAlign),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  header.text,
                                  textAlign: header.textAlign,
                                  style: widget.headerTextStyle,
                                ),
                                if (widget.sortColumn != null &&
                                    widget.sortColumn == header.value)
                                  widget.sortAscending!
                                      ? const Icon(
                                          Icons.arrow_downward,
                                          size: 15,
                                          color: AppColors.kcWhiteColor,
                                        )
                                      : const Icon(
                                          Icons.arrow_upward,
                                          size: 15,
                                          color: AppColors.kcWhiteColor,
                                        ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
        ],
      ),
    );
  }

  List<Widget> desktopList() {
    final decoration = BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
    );
    final rowDecoration = widget.rowDecoration ?? decoration;
    final selectedDecoration = widget.selectedDecoration ?? decoration;
    final widgets = <Widget>[];
    for (var index = 0; index < widget.source!.length; index++) {
      final data = widget.source![index];
      widgets.add(
        Column(
          children: [
            Container(
              padding: widget.padding ??
                  EdgeInsets.symmetric(
                    horizontal: widget.showSelect ? 6 : 11,
                    vertical: widget.verticalItemPadding ?? 2,
                  ),
              decoration: widget.selecteds!.contains(data)
                  ? selectedDecoration
                  : rowDecoration,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.showSelect && widget.selecteds != null)
                    Row(
                      children: [
                        Checkbox(
                          value: widget.selecteds!.contains(data),
                          onChanged: (value) {
                            if (widget.onSelect != null) {
                              widget.onSelect!(value, data);
                            }
                          },
                          activeColor: AppColors.kcPrimaryColor,
                        ),
                      ],
                    ),
                  ...widget.headers.where((header) => header.show == true).map(
                        (header) => Expanded(
                          flex: header.flex,
                          child: InkWell(
                            onTap: () {
                              if (header.isClickable) {
                                widget.onTabRow?.call(data);
                                setState(() {
                                  widget.expanded![index] =
                                      !widget.expanded![index];
                                });
                              }
                            },
                            child: header.sourceBuilder != null
                                ? header.sourceBuilder!(
                                    data[header.value],
                                    data,
                                  )
                                : header.editable
                                    ? TextEditableWidget(
                                        data: data,
                                        header: header,
                                        textAlign: header.textAlign,
                                        onChanged: widget.onChangedRow,
                                        onSubmitted: widget.onSubmittedRow,
                                        hideUnderline: widget.hideUnderline,
                                      )
                                    : Padding(
                                        padding: symetricH10,
                                        child: Text(
                                          '${data[header.value]}',
                                          textAlign: header.textAlign,
                                          style:
                                              widget.selecteds!.contains(data)
                                                  ? widget.selectedTextStyle
                                                  : widget.rowTextStyle,
                                        ),
                                      ),
                          ),
                        ),
                      ),
                ],
              ),
            ),
            if (widget.isExpandRows &&
                widget.expanded![index] &&
                widget.dropContainer != null)
              widget.dropContainer!(data),
          ],
        ),
      );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return widget.reponseScreenSizes.isNotEmpty &&
            widget.reponseScreenSizes.contains(context.screenSize)
        ?

        /// for small screen
        Column(
            children: [
              /// title and actions
              if (widget.title != null || widget.actions != null)
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: Colors.grey[300]!)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.title != null) widget.title!,
                      if (widget.actions != null) ...widget.actions!,
                    ],
                  ),
                ),

              if (widget.autoHeight)
                Column(
                  children: [
                    if (widget.showSelect && widget.selecteds != null)
                      mobileHeader(),
                    if (widget.isLoading) const LinearProgressIndicator(),
                    ...mobileList(),
                  ],
                ),
              if (!widget.autoHeight)
                Expanded(
                  child: ListView(
                    /// itemCount: source.length,
                    children: [
                      if (widget.showSelect && widget.selecteds != null)
                        mobileHeader(),
                      if (widget.isLoading) const LinearProgressIndicator(),

                      /// mobileList
                      ...mobileList(),
                    ],
                  ),
                ),

              /// footer
              if (widget.footers != null)
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [...widget.footers!],
                ),
            ],
          )
        /**
     * for large screen
     */
        : Column(
            children: [
              //title and actions
              if (widget.title != null || widget.actions != null)
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: Colors.grey[300]!)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.title != null) widget.title!,
                      if (widget.actions != null) ...widget.actions!,
                    ],
                  ),
                ),

              /// desktopHeader
              if (widget.headers.isNotEmpty && !widget.hideHeaders)
                desktopHeader(),

              if (widget.isLoading) const LinearProgressIndicator(),

              Column(children: desktopList()),
              // if (widget.autoHeight) Column(children: desktopList()),
              //
              // if (!widget.autoHeight)
              //   // desktopList
              //   if (widget.source != null && widget.source!.isNotEmpty)
              //     Expanded(child: ListView(children: desktopList())),

              //footer
              if (widget.footers != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [...widget.footers!],
                ),
            ],
          );
  }
}

/// `TextEditableWidget`
///
/// use to display when user allow any header columns to be editable
class TextEditableWidget extends StatelessWidget {
  const TextEditableWidget({
    required this.data,
    required this.header,
    super.key,
    this.textAlign = TextAlign.center,
    this.hideUnderline = false,
    this.onChanged,
    this.onSubmitted,
  });

  /// `data`
  ///
  /// current data as Map
  final Map<String, dynamic> data;

  /// `header`
  ///
  /// current editable text header
  final DatatableHeader header;

  /// `textAlign`
  ///
  /// by default textAlign will be center
  final TextAlign textAlign;

  /// `hideUnderline`
  ///
  /// allow use to decorate hideUnderline false or true
  final bool hideUnderline;

  /// `onChanged`
  ///
  /// trigger the call back update when user make any text change
  final Function(Map<String, dynamic> vaue, DatatableHeader header)? onChanged;

  /// `onSubmitted`
  ///
  /// trigger the call back when user press done or enter
  final Function(Map<String, dynamic> vaue, DatatableHeader header)?
      onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 100),
      padding: const EdgeInsets.all(6),
      margin: EdgeInsets.zero,
      decoration: const BoxDecoration(color: AppColors.kcLightGrey),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(6),
          border:
              hideUnderline ? InputBorder.none : const UnderlineInputBorder(),
          alignLabelWithHint: false,
          isDense: true,
          hintText: 'Enter score',
        ),
        textAlign: textAlign,
        style: GoogleFonts.inter(fontSize: 14),
        controller: TextEditingController.fromValue(
          TextEditingValue(text: '${data[header.value]}'),
        ),
        onChanged: (newValue) {
          data[header.value] = newValue;
          onChanged?.call(data, header);
        },
        onSubmitted: (x) => onSubmitted?.call(data, header),
      ),
    );
  }
}
