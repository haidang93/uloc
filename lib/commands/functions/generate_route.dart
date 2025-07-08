import 'dart:io';

import 'package:args/args.dart';
import 'package:uloc/commands/entities/const.dart';
import 'package:uloc/commands/entities/enum.dart';
import 'package:uloc/commands/entities/route_declaration.dart';
import 'package:uloc/commands/functions/urtil.dart';

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

  final routesMap = parseULoCRoutesToJson(content);

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
  for (MapEntry<String, RouteDeclaration> entry in routesMap.entries) {
    result.add(_buildRouteName(entry.key, entry.value.route));
  }
  result.add('');
  result.add('   /// use this to pass to [MaterialApp] Route setting');
  result.add(
    '  static final ULoCRouteConfiguration ulocRouteConfiguration = ULoCRouteConfiguration([',
  );
  for (MapEntry<String, RouteDeclaration> entry in routesMap.entries) {
    result.add('    RouteProperties<${entry.value.providerName}>(');
    result.add(
      '      routeName: Routes.${entry.key}${(entry.value.route.contains(':')) ? '()' : ''},',
    );
    result.add('      provider: ${entry.value.provider},');
    result.add('      child: ${entry.value.child}(),');
    result.add('    ),');
  }
  result.add('  ]);');
  result.add('}');
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

    return "  static RouteName $name({${paramList.map((e) => 'String? $e').join(', ')}}) => ${paramList.map((e) => '$e == null').join(' && ')} ? '$value' : '${value.replaceAllMapped(RegExp(r':(\w+)'), (match) => '\${${match[1]} ?? \'\' }')}';";
  }
}
