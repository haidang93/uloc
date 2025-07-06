import 'dart:io';

import 'package:args/args.dart';
import 'package:uloc/commands/entities/const.dart';
import 'package:uloc/commands/entities/enum.dart';

void generateRoute(ArgResults cmdArgs) {
  File declaredFile = File(defaultRouteDeclarationFileDir);
  File routesFile = File(defaultRouteFileDir);

  final customDeclaredDir =
      cmdArgs.command?.name ?? cmdArgs.option(CommandFlag.dir) ?? '';

  if (customDeclaredDir.isNotEmpty) {
    declaredFile = File(customDeclaredDir);
  }

  if (!declaredFile.existsSync()) {
    throw Exception('${declaredFile.path} is not found');
  }

  final content = declaredFile.readAsStringSync();

  if (!content.contains(annotation)) {
    throw Exception('$customDeclaredDir Cannot find ULoCDeclaration');
  }

  final imports = content.split(annotation).first;

  final customRouteDir =
      cmdArgs.command?.command?.name ??
      cmdArgs.option(CommandFlag.target) ??
      '';

  if (customRouteDir.isNotEmpty) {
    routesFile = File(customRouteDir);
  }

  if (!routesFile.existsSync()) {
    routesFile.createSync(recursive: true);
  }

  final routesMap = _parseULoCRoutesToJson(content);

  List<String> result = [];

  result.add('///');
  result.add('/// **************************************************');
  result.add('/// **** [GENERATED CODE - DO NOT MODIFY BY HAND] ****');
  result.add('/// **************************************************');
  result.add('///');
  result.add(
    '// ignore_for_file: constant_identifier_names, non_constant_identifier_names, dangling_library_doc_comments',
  );
  result.add(imports);
  result.add('/// use this for [named navigation]');
  result.add('class Routes {');
  result.add('  Routes._();');
  result.add('');
  for (MapEntry<String, Map<String, String>> entry in routesMap.entries) {
    result.add(_buildRouteName(entry.key, entry.value['route'] ?? ''));
  }
  result.add('}');
  result.add('');
  result.add('/// use this to pass to [MaterialApp] Route setting');
  result.add('final ULoC uloc = ULoC([');
  for (MapEntry<String, Map<String, String>> entry in routesMap.entries) {
    result.add('  RouteProperties<${entry.value['providerName']}>(');
    result.add(
      '    routeName: Routes.${entry.key}${(entry.value['route']?.contains(':') ?? false) ? '()' : ''},',
    );
    result.add('    provider: ${entry.value['provider']},');
    result.add('    child: ${entry.value['child']}(),');
    result.add('  ),');
  }
  result.add(']);');
  result.add('');
  routesFile.writeAsStringSync(result.join('\n'));

  print('$green File generated: ${routesFile.absolute.path} $reset');
  exit(0);
}

String _buildRouteName(String name, String value) {
  if (!value.contains(':')) {
    return "  static const RouteName $name = '$value';";
  } else {
    List<String> paramList = value
        .split('/')
        .where((e) => e.contains(':'))
        .map((e) => e.replaceAll(':', ''))
        .toList();

    return "  static RouteName $name({${paramList.map((e) => 'String? $e').join(', ')}}) => ${paramList.map((e) => '$e == null').join(' && ')} ? '$value' : '${value.replaceAll(':', '\$')}';";
  }
}

Map<String, Map<String, String>> _parseULoCRoutesToJson(String source) {
  final routeMap = <String, Map<String, String>>{};

  final routeRegex = RegExp(
    r"'(\w+)':\s*ULoCRoute\(\s*"
    r"route:\s*'([^']+)',\s*"
    r"provider:\s*\(([^)]+)\)\s*=>\s*([^\n]+?),\s*"
    r"child:\s*([^\n,]+)",
    multiLine: true,
  );

  for (final match in routeRegex.allMatches(source)) {
    final key = match.group(1)!; // e.g. 'HOME'
    final route = match.group(2)!; // e.g. '/'
    final providerArgs = match.group(3)!; // e.g. context, _
    final providerBody = match.group(4)!.trim(); // e.g. HomeController(context)
    final child = match.group(5)!.trim().replaceAll(',', ''); // e.g. Home

    // Extract provider name (e.g., HomeController from HomeController(context))
    final providerNameMatch = RegExp(r'(\w+)\s*\(').firstMatch(providerBody);
    final providerName = providerNameMatch?.group(1) ?? 'UnknownProvider';

    routeMap[key] = {
      'route': route,
      'providerName': providerName,
      'provider': '($providerArgs) => $providerBody',
      'child': child,
    };
  }

  return routeMap;
}
