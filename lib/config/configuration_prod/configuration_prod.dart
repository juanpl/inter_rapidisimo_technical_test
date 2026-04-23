import 'package:inter_rapidisimo_technical_test/config/schema_configuration.dart';

class ConfigurationProd {
  late final SchemaConfiguration _configuration;
  ConfigurationProd() {
    _configuration = SchemaConfiguration(
      appName: 'Prueba tecnica',
      endpoints: ConfigurationEndpoints(
        productEndPoint: 'ttps://dummyjson.com/products',
      ),
      companyName: 'Inter rapidisiomo',
    );
  }

  SchemaConfiguration get config => _configuration;
}
