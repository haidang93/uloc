// ignore_for_file: depend_on_referenced_packages, implementation_imports

import 'dart:async';
import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:meta/meta_meta.dart';
import 'package:provider/provider.dart';
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

class ULoC {
  ULoC(List<RouteProperties> routes)
    : _configuration = _RoutesConfiguration(routes);
  final _RoutesConfiguration _configuration;

  /// Put this route to MaterialApp.routes
  RouteMap get routes => _configuration.routes;

  /// Put this route to MaterialApp.onGenerateRoute
  Route<dynamic>? Function(RouteSettings settings) get routeBuilder =>
      _configuration.routeBuilder;
}
