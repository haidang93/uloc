import 'package:flutter/material.dart';
import 'package:uloc_example/routes/routes.uloc.g.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ULoC Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: Routes.HOME.name,
      onGenerateRoute: Routes.ulocRouteConfiguration.routeBuilder,
    );
  }
}
