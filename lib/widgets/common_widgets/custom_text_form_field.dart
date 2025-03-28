import 'package:easeops_web_hrms/app_export.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    required this.textEditingController,
    super.key,
    this.labelText,
    this.hintText,
    this.title,
    this.errorMsg = '',
    this.borderColor,
    this.txtStyle,
    this.isFillKcLightGrey = false,
    this.isShowError = true,
    this.suffixIcon,
    this.suffixIcon1,
    this.prefixIcon,
    this.suffixCallBack,
    this.suffixCallBack1,
    this.prefixCallBack,
    this.prefixIconSize,
    this.obscureText = false,
    this.isReadOnly = false,
    this.isLoading = false,
    this.paddingVertical,
    this.maxLines,
    this.keyboardType,
    this.heightForm,
    this.validatorCallback,
    this.onChangedCallBack,
    this.onSavedCallback,
    this.onSubmitCallback,
    this.txtFormWidth,
    this.onTapCallback,
    this.focusNode,
  });

  final String? labelText;
  final String? hintText;
  final String? title;
  final String? errorMsg;
  final bool obscureText;
  final TextEditingController textEditingController;
  final Color? borderColor;
  final double? heightForm;
  final TextStyle? txtStyle;
  final FocusNode? focusNode;
  final bool isFillKcLightGrey;
  final bool isReadOnly;
  final int? maxLines;
  final bool isShowError;
  final bool isLoading;
  final IconData? suffixIcon;
  final IconData? suffixIcon1;
  final IconData? prefixIcon;
  final double? prefixIconSize;
  final VoidCallback? suffixCallBack;
  final VoidCallback? suffixCallBack1;
  final VoidCallback? prefixCallBack;
  final double? txtFormWidth;
  final double? paddingVertical;
  final TextInputType? keyboardType;
  final String? Function(String?)? validatorCallback;
  final String? Function(String?)? onChangedCallBack;
  final String? Function(String?)? onSavedCallback;
  final String? Function(String?)? onSubmitCallback;
  final VoidCallback? onTapCallback;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text.rich(
            TextSpan(
              children: [
                // Regular text without asterisks
                TextSpan(
                  text: (title ?? '').replaceAll('*', ''),
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.kcBlackColor,
                  ),
                ),
                if ((title ?? '').contains('*'))
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
        if (title != null) sbh2,
        SizedBox(
          height: (maxLines ?? 1) > 1 ? maxLines! * 24 : heightForm,
          width: txtFormWidth,
          child: TextFormField(
            controller: textEditingController,
            style: txtStyle ??
                GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  color: AppColors.kcBlackColor,
                  fontSize: 14,
                ),
            focusNode: focusNode,
            keyboardType: keyboardType,
            cursorColor: Colors.grey,
            obscureText: obscureText,
            readOnly: isReadOnly,
            maxLines: maxLines ?? 1,
            decoration: InputDecoration(
              filled: true,
              fillColor:
                  isFillKcLightGrey ? AppColors.kcLightGrey : Colors.white,
              isDense: true,
              contentPadding: isFillKcLightGrey
                  ? EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: paddingVertical ?? 16.5,
                    )
                  : EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: paddingVertical ?? 16,
                    ),
              border: OutlineInputBorder(borderRadius: br2),
              enabledBorder: OutlineInputBorder(
                borderRadius: br2,
                borderSide: BorderSide(
                  color: borderColor ?? AppColors.kcBorderStrokesColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: br2,
                borderSide: BorderSide(
                  color: borderColor ?? AppColors.kcBorderStrokesColor,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: br2,
                borderSide: const BorderSide(
                  color: AppColors.kcDangerColor,
                ),
              ),
              errorStyle: isShowError
                  ? const TextStyle(
                      fontSize: 11,
                      color: AppColors.kcDangerColor,
                    )
                  : const TextStyle(fontSize: 0.001),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: br2,
                borderSide: const BorderSide(
                  color: AppColors.kcDangerColor,
                ),
              ),
              labelText: labelText,
              hintText: hintText ?? 'Type Here',
              alignLabelWithHint: false,
              hintStyle: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.kcTextLightColor,
              ),
              labelStyle: isFillKcLightGrey
                  ? AppStyles.ktsTextFieldTitle.apply(letterSpacingFactor: 2)
                  : AppStyles.ktsTextFieldSelected,
              suffixIcon: suffixIcon != null || suffixIcon1 != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        sbw8,
                        if (suffixIcon1 != null)
                          InkWell(
                            onTap: suffixCallBack1,
                            child: Icon(
                              suffixIcon1,
                              size: 20,
                              color: AppColors.kcIconColor,
                            ),
                          ),
                        sbw8,
                        if (suffixIcon != null)
                          isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CustomProgressIndicator(
                                    color: AppColors.kcPrimaryColor,
                                  ),
                                )
                              : InkWell(
                                  onTap: suffixCallBack,
                                  child: Icon(
                                    suffixIcon,
                                    size: 20,
                                    color: AppColors.kcIconColor,
                                  ),
                                ),
                        sbw8,
                      ],
                    )
                  : null,
              prefixIcon: prefixIcon != null
                  ? InkWell(
                      onTap: prefixCallBack,
                      child: Icon(
                        prefixIcon,
                        size: prefixIconSize ?? 20,
                        color: AppColors.kcIconColor,
                      ),
                    )
                  : null,
            ),
            textInputAction: TextInputAction.done,
            validator: validatorCallback,
            onSaved: onSavedCallback,
            onFieldSubmitted: onSubmitCallback,
            onTap: onTapCallback,
            onChanged: onChangedCallBack,
          ),
        ),
        if (errorMsg != '')
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 4),
            child: SizedBox(
              width: txtFormWidth,
              child: Text(
                errorMsg.toString(),
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: AppColors.kcDangerColor,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
