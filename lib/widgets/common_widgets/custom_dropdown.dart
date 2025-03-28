import 'package:easeops_web_hrms/app_export.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CustomDropDown extends StatefulWidget {
  const CustomDropDown({
    required this.itemList,
    super.key,
    this.hintText,
    this.selectedItem,
    this.title,
    this.errorMsg = '',
    this.isWhiteFill = false,
    this.onTapCallback,
    this.padding,
    this.isMapList = false,
    this.fontSize,
    this.iconStyleData,
    this.height = 32,
    this.width,
    this.onClearCallback,
  });

  final String? hintText;
  final String? selectedItem;
  final bool isMapList;
  final String? title;
  final String errorMsg;
  final bool isWhiteFill;
  final double height;
  final double? width;
  final double? fontSize;
  final EdgeInsets? padding;
  final List<dynamic> itemList;
  final IconStyleData? iconStyleData;
  final Function(dynamic)? onTapCallback;
  final VoidCallback? onClearCallback;

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  final GlobalKey _dropdownKey = GlobalKey();
  String? _currentSelectedItem;

  @override
  void initState() {
    super.initState();
    _currentSelectedItem = widget.selectedItem;
  }

  void _showDropdown() {
    GestureDetector? detector;
    void searchForGestureDetector(Element element) {
      if (element.widget is GestureDetector) {
        detector = element.widget as GestureDetector?;
      } else {
        element.visitChildren(searchForGestureDetector);
      }
    }

    _dropdownKey.currentContext?.visitChildElements(searchForGestureDetector);
    detector?.onTap!();
  }

  void _clearSelection() {
    setState(() {
      _currentSelectedItem = null;
    });
    if (widget.onClearCallback != null) {
      widget.onClearCallback!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: (widget.title ?? '').replaceAll('*', ''),
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.kcBlackColor,
                  ),
                ),
                if ((widget.title ?? '').contains('*'))
                  TextSpan(
                    text: '*',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: AppColors.kcDangerColor,
                    ),
                  ),
              ],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        if (widget.title != null) const SizedBox(height: 2),
        SizedBox(
          width: widget.width,
          height: widget.height,
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<dynamic>(
              key: _dropdownKey,
              isExpanded: true,
              value: _currentSelectedItem ?? widget.selectedItem,
              hint: Text(
                widget.hintText ?? '',
                style: GoogleFonts.inter(
                  color: AppColors.kcTextLightColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              items: widget.itemList
                  .map(
                    (item) => DropdownMenuItem<dynamic>(
                  value: widget.isMapList ? item['label'] : item,
                  child: Text(
                    widget.isMapList ? item['label'] : item,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.kcBlackColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    setState(() {
                      _currentSelectedItem =
                      widget.isMapList ? item['label'] : item;
                    });
                    widget.onTapCallback?.call(item);
                  },
                ),
              )
                  .toList(),
              onChanged: (_) {},
              buttonStyleData: ButtonStyleData(
                overlayColor: WidgetStateProperty.all(
                  AppColors.kcPrimaryColor.withOpacity(0.3),
                ),
                decoration: BoxDecoration(
                  color: widget.isWhiteFill ? Colors.white : AppColors.kcLightGrey,
                  border: Border.all(color: AppColors.kcBorderStrokesColor),
                  borderRadius: BorderRadius.circular(2),
                ),
                padding: widget.padding,
                elevation: 0,
              ),
              iconStyleData: widget.iconStyleData ??
                  IconStyleData(
                    icon: Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: InkWell(
                        onTap: _currentSelectedItem != null && widget.onClearCallback != null
                            ? _clearSelection
                            : _showDropdown,
                        child: Icon(
                          _currentSelectedItem != null && widget.onClearCallback != null
                              ? Icons.close
                              : Icons.keyboard_arrow_down,
                          size: 20,
                        ),
                      ),
                    ),
                    iconDisabledColor: Colors.black,
                  ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 160,
                elevation: 0,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white,
                  border: Border.all(color: AppColors.kcBorderColor),
                ),
                scrollbarTheme: ScrollbarThemeData(
                  thumbColor: WidgetStateProperty.all(
                    AppColors.kcPrimaryColor.withOpacity(0.3),
                  ),
                  trackVisibility: WidgetStateProperty.all(true),
                  radius: const Radius.circular(40),
                  thickness: WidgetStateProperty.all<double>(6),
                  thumbVisibility: WidgetStateProperty.all<bool>(true),
                ),
              ),
              menuItemStyleData: MenuItemStyleData(
                overlayColor: WidgetStateProperty.all(
                  AppColors.kcPrimaryColor.withOpacity(0.1),
                ),
              ),
            ),
          ),
        ),
        if (widget.errorMsg.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 8),
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
  }
}

class CustomDropDownWithTextField extends StatelessWidget {
  const CustomDropDownWithTextField({
    required this.itemList,
    required this.textEditingController,
    super.key,
    this.hintText,
    this.title,
    this.errorMsg = '',
    this.isWhiteFill = false,
    this.isGoogleLocation = false,
    this.onTapCallback,
    this.onSelectedCallback,
    this.onChangedCallBack,
    this.validatorCallback,
    this.padding,
    this.fontSize,
    this.isCreatable = true,
    this.height = 32,
    this.width = 200,
  });

  final TextEditingController textEditingController;
  final String? hintText;
  final String? title;
  final String errorMsg;
  final bool isWhiteFill;
  final bool isGoogleLocation;
  final double height;
  final double width;
  final double? fontSize;
  final bool isCreatable;
  final EdgeInsets? padding;
  final List<dynamic> itemList;
  final Function(dynamic)? onTapCallback;
  final Function(dynamic)? onSelectedCallback;
  final String? Function(String?)? onChangedCallBack;
  final String? Function(String?)? validatorCallback;

  @override
  Widget build(BuildContext context) {
    return TypeAheadField(
      suggestionsCallback: (pattern) {
        return isGoogleLocation
            ? itemList
                .where(
                  (lang) => lang.description
                      .toLowerCase()
                      .contains(pattern.toLowerCase()),
                )
                .toList()
            : isCreatable
                ? itemList
                        .where(
                          (lang) => lang
                              .toLowerCase()
                              .contains(pattern.toLowerCase()),
                        )
                        .toList()
                        .isNotEmpty
                    ? itemList
                        .where(
                          (lang) => lang
                              .toLowerCase()
                              .contains(pattern.toLowerCase()),
                        )
                        .toList()
                    : ['Create "${textEditingController.text.trim()}"']
                : itemList
                    .where(
                      (lang) =>
                          lang.toLowerCase().contains(pattern.toLowerCase()),
                    )
                    .toList();
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(
            isGoogleLocation
                ? suggestion.description.toString()
                : suggestion.toString(),
          ),
        );
      },
      decorationBuilder: (context, child) {
        return Material(
          type: MaterialType.card,
          elevation: 4,
          borderRadius: BorderRadius.circular(8),
          color: AppColors.kcWhiteColor,
          shadowColor: AppColors.kcWhiteColor,
          child: child,
        );
      },
      constraints: const BoxConstraints(maxHeight: 200),
      controller: textEditingController,
      builder: (context, controller, focusNode) {
        return CustomTextFormField(
          title: title,
          heightForm: height,
          txtFormWidth: width,
          textEditingController: textEditingController,
          focusNode: focusNode,
          hintText: hintText,
          onChangedCallBack: onChangedCallBack,
          errorMsg: errorMsg,
          validatorCallback: validatorCallback,
          isFillKcLightGrey: !isWhiteFill,
        );
      },
      onSelected: onSelectedCallback,
    );
  }
}
