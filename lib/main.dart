import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inter_rapidisimo_technical_test/config/configuration.dart';
import 'package:inter_rapidisimo_technical_test/config/configuration_prod/configuration_prod.dart';
import 'package:inter_rapidisimo_technical_test/core/router/app_roueter.dart';
import 'package:inter_rapidisimo_technical_test/injection_container.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Configuration.config = ConfigurationProd().config;
  initInjectionContainer();
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
