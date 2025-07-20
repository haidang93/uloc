// ignore_for_file: depend_on_referenced_packages, implementation_imports

import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

export 'package:provider/provider.dart';

part 'entities/classes/annotation.dart';
part 'entities/classes/route_congiguration.dart';
part 'entities/classes/route_definiton.dart';
part 'entities/classes/route_properties.dart';
part 'entities/classes/uloc_arguments.dart';
part 'entities/classes/uloc_provider.dart';
part 'entities/classes/uloc_route.dart';
part 'entities/const.dart';
part 'entities/custom_types/custom_types.dart';
part 'entities/enums/curves_enum.dart';
part 'entities/enums/transition_enum.dart';
part 'extension/context_extension.dart';
part 'extension/string_extension.dart';
part 'utilities/route_utilities.dart';
part 'widgets/lifecycle_widget.dart';

/// A wrapper class that holds the ULoC route configuration for the app.
///
/// This class is responsible for converting a list of [RouteProperties]
/// into usable routing mechanisms for [MaterialApp], including:
/// - [routes] for static route registration
/// - [routeBuilder] for dynamic route generation with parameters
/// class ULoCRouteConfiguration {
/// Creates a [ULoCRouteConfiguration] from a list of [RouteProperties].
///
/// This sets up internal configuration used to resolve routes and
/// generate corresponding controllers and views.
///
/// ```dart
/// ULoCRouteConfiguration(List<RouteProperties> routes)
///   : _configuration = _RoutesConfiguration(routes);
/// ```
///
/// final _RoutesConfiguration _configuration;
/// A static map of route names to widget builders.
///
/// Uage:
///
/// ```dart
/// class MyApp extends StatelessWidget {
///   const MyApp({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///       title: 'ULoC Demo',
///       theme: ThemeData(
///         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
///       ),
///       initialRoute: Routes.HOME,
///       routes: Routes.ulocRouteConfiguration.routes,
///       onGenerateRoute: Routes.ulocRouteConfiguration.routeBuilder,
///     );
///   }
/// }
/// ```

class ULoCRouteConfiguration {
  ULoCRouteConfiguration(List<RouteProperties> routes)
    : _configuration = _RoutesConfiguration(routes);
  final _RoutesConfiguration _configuration;

  /// Put this route to MaterialApp.onGenerateRoute
  Route<dynamic>? Function(RouteSettings settings) get routeBuilder =>
      _configuration.routeBuilder;
}
