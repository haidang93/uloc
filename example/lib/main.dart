import 'package:flutter/material.dart';
import 'package:uloc/uloc.dart';
import 'package:uloc_example/routes/routes.uloc.g.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => SDasdf(context),
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: context.read<SDasdf>().text,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            initialRoute: Routes.HOME.name,
            onGenerateRoute: Routes.ulocRouteConfiguration.routeBuilder,
          );
        },
      ),
    );
  }
}

class SDasdf extends ULoCStatelessProvider {
  SDasdf(super.context);
  String text = 'asdasd';

  @override
  void onCreate() {
    super.onCreate();
    print('object');
  }
}
