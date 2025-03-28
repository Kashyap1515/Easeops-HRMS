enum Flavor { staging, production }

class FlavorValues {
  FlavorValues({required this.appName, required this.baseUrl,required this.qrBaseUrl,});

  String appName;
  String baseUrl;
  String qrBaseUrl;
}

class FlavorConfig {
  factory FlavorConfig({
    required Flavor flavor,
    required FlavorValues values,
  }) {
    _instance ??= FlavorConfig._internal(
      flavor,
      values,
    );
    return _instance!;
  }

  FlavorConfig._internal(this.flavor, this.values);

  final Flavor flavor;
  final FlavorValues values;
  static FlavorConfig? _instance;

  static FlavorConfig get instance {
    return _instance!;
  }

  static bool isProduction() => _instance!.flavor == Flavor.production;

  static bool isDevelopment() => _instance!.flavor == Flavor.staging;
}
