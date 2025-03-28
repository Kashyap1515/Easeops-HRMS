import 'package:easeops_web_hrms/app_export.dart';

const double btnBorderRadius = 4;
const double btnHeight = 40;
const double formWidth = 230;
const double verticalPadding = 14;

// Different Border radius
BorderRadius br2 = BorderRadius.circular(2);
BorderRadius br4 = BorderRadius.circular(4);
BorderRadius br8 = BorderRadius.circular(8);

// App Padding
EdgeInsets all4 = const EdgeInsets.all(4);
EdgeInsets all8 = const EdgeInsets.all(8);
EdgeInsets all10 = const EdgeInsets.all(10);
EdgeInsets all12 = const EdgeInsets.all(12);
EdgeInsets all15 = const EdgeInsets.all(15);
EdgeInsets all16 = const EdgeInsets.all(16);
EdgeInsets all20 = const EdgeInsets.all(20);
EdgeInsets all24 = const EdgeInsets.all(24);
EdgeInsets symetricHV8 = const EdgeInsets.symmetric(horizontal: 8, vertical: 8);
EdgeInsets symetricV16H24 =
    const EdgeInsets.symmetric(horizontal: 24, vertical: 16);

EdgeInsets symetricH10 = const EdgeInsets.symmetric(horizontal: 10);
EdgeInsets symetricH16 = const EdgeInsets.symmetric(horizontal: 16);

// Different SizedBox Height
SizedBox sbh2 = const SizedBox(height: 2);
SizedBox sbh5 = const SizedBox(height: 5);
SizedBox sbh8 = const SizedBox(height: 8);
SizedBox sbh10 = const SizedBox(height: 10);
SizedBox sbh12 = const SizedBox(height: 12);
SizedBox sbh16 = const SizedBox(height: 16);
SizedBox sbh18 = const SizedBox(height: 18);
SizedBox sbh20 = const SizedBox(height: 20);
SizedBox sbh24 = const SizedBox(height: 24);
SizedBox sbh30 = const SizedBox(height: 30);
SizedBox sbh32 = const SizedBox(height: 32);
SizedBox sbh50 = const SizedBox(height: 50);

// Different SizedBox Width
SizedBox sbw5 = const SizedBox(width: 5);
SizedBox sbw8 = const SizedBox(width: 8);
SizedBox sbw10 = const SizedBox(width: 10);
SizedBox sbw16 = const SizedBox(width: 16);
SizedBox sbw32 = const SizedBox(width: 32);

const Color textColor = Color.fromRGBO(81, 84, 96, 1);

//font family
const String appFontFamily = 'Montserrat';

class AppStyles {
  static TextStyle get ktsTabTitle2 => GoogleFonts.montserrat(
        fontSize: 14,
        color: const Color(0xFF51545F),
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      );

  static TextStyle get ktsTextFieldTitle => GoogleFonts.montserrat(
        fontSize: 12,
        color: const Color(0xFF727272),
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
      );

  static TextStyle get ktsLoginText => GoogleFonts.montserrat(
        fontSize: 20,
        color: AppColors.kcFontTextColor,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get ktsTextFieldSelected => GoogleFonts.montserrat(
        fontSize: 12,
        color: const Color(0xFF7F8392),
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      );

  static TextStyle get ktsDropDownText => GoogleFonts.montserrat(
        fontSize: 14,
        color: AppColors.kcFontTextColor,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get ktsBodyLarge => GoogleFonts.montserrat(
        fontSize: 63,
        fontWeight: FontWeight.w600,
        color: AppColors.kcPrimaryColor,
      );
  static ThemeData removeDefaultSplash = ThemeData(
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    canvasColor: Colors.transparent,
    shadowColor: Colors.transparent,
    cardColor: Colors.transparent,
    hoverColor: Colors.transparent,
  );
}
