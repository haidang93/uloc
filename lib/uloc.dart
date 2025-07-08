// ignore_for_file: depend_on_referenced_packages, implementation_imports

import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uloc/commands/entities/const.dart';
export 'package:provider/provider.dart';

part 'widgets/lifecycle_widget.dart';
part 'entities/classes/annotation.dart';
part 'entities/classes/uloc_provider.dart';
part 'entities/classes/route_properties.dart';
part 'entities/classes/route_definiton.dart';
part 'entities/classes/route_congiguration.dart';
part 'entities/custom_types/custom_types.dart';
part 'entities/enums/transition_enum.dart';
part 'entities/enums/curves_enum.dart';
part 'utilities/route_utilities.dart';
part 'extension/context_extension.dart';
part 'extension/string_extension.dart';

class ULoCRouteConfiguration {
  ULoCRouteConfiguration(List<RouteProperties> routes)
    : _configuration = _RoutesConfiguration(routes);
  final _RoutesConfiguration _configuration;

  /// Put this route to MaterialApp.routes
  RouteMap get routes => _configuration.routes;

  /// Put this route to MaterialApp.onGenerateRoute
  Route<dynamic>? Function(RouteSettings settings) get routeBuilder =>
      _configuration.routeBuilder;
}
