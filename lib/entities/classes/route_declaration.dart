part of '../../../uloc.dart';

class RouteDeclaration {
  final String routeName;
  final String route;
  final String providerName;
  final String provider;
  final String child;
  final Map<String, String> arguments;
  RouteDeclaration({
    required this.routeName,
    required this.route,
    required this.providerName,
    required this.provider,
    required this.arguments,
    required this.child,
  });
}
