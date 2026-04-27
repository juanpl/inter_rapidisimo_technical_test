import 'package:inter_rapidisimo_technical_test/core/ui_system/colors/application_colors.dart';

class SchemaConfiguration {
  final String appName;
  //final String partnerId;
  //final ThemeData appTheme;
  final ApplicationColors appColors;
  //final FontsBase fonts;
  //final String svgPath;
  final ConfigurationEndpoints endpoints;
  final String companyName;
  //final String androidAppId;
  //final String iosAppId;

  SchemaConfiguration({
    required this.appName,
    //required this.partnerId,
    required this.endpoints,
    required this.appColors,
    required this.companyName,
  });
}

class ConfigurationEndpoints {
  final String productEndPoint;

  ConfigurationEndpoints({required this.productEndPoint});
}
