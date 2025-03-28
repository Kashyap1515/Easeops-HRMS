import 'package:easeops_web_hrms/app_export.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppPreferences.init();
  Logger.init(kReleaseMode ? LogMode.debug : LogMode.debug);
  setPathUrlStrategy();
  FlavorConfig(
    flavor: Flavor.production,
    values: FlavorValues(
      appName: 'EaseOps HRMS',
      baseUrl: 'https://api.moonwyre.com/',
      qrBaseUrl: 'http://feedback.easeops.io/',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.kcPrimaryColor,
        focusColor: AppColors.kcPrimaryColor,
        scaffoldBackgroundColor: AppColors.kcDrawerColor,
        textTheme: GoogleFonts.openSansTextTheme(
          Theme.of(context).textTheme,
        ).apply(bodyColor: Colors.black, displayColor: Colors.black),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          },
        ),
      ),
      initialRoute: AppPreferences.getUserData() != null
          ? AppRoutes.routeUsers
          : AppRoutes.routeLogin,
      getPages: AppPages.routes,
    );
  }
}
