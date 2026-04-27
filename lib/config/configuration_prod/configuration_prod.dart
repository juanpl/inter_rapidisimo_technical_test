import 'package:inter_rapidisimo_technical_test/config/schema_configuration.dart';
import 'package:inter_rapidisimo_technical_test/core/ui_system/colors/application_colors.dart';

class ConfigurationProd {
  late final SchemaConfiguration _configuration;
  ConfigurationProd() {
    _configuration = SchemaConfiguration(
      appName: 'Prueba tecnica',
      endpoints: ConfigurationEndpoints(
        productEndPoint: 'https://dummyjson.com/products',
      ),
      companyName: 'Inter rapidisiomo',
      appColors: ApplicationColors(),
    );
  }

  SchemaConfiguration get config => _configuration;
}
