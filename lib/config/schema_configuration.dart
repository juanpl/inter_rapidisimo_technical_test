class SchemaConfiguration {
  final String appName;
  //final String partnerId;
  //final ThemeData appTheme;
  //final ColorsBase appColors;
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
    required this.companyName,
  });
}

class ConfigurationEndpoints {
  final String productEndPoint;

  ConfigurationEndpoints({required this.productEndPoint});
}
