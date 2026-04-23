import 'package:inter_rapidisimo_technical_test/config/configuration.dart';
import 'package:inter_rapidisimo_technical_test/config/configuration_prod/configuration_prod.dart';

Future<void> main() async {
  Configuration.config = ConfigurationProd().config;
}
