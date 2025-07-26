import 'dart:io';

import 'package:args/args.dart';
import 'package:uloc/commands/cmd_enum.dart';
import 'package:uloc/commands/const.dart';
import 'package:uloc/commands/functions/urtil.dart';
import 'package:uloc/commands/route_declaration.dart';

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
  result.add(
    '/// **************************************************************',
  );
  result.add(
    '/// **** [GENERATED CODE - ONLY MODIFY IMPORT PATH IF NEEDED] ****',
  );
  result.add(
    '/// **************************************************************',
  );
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
    result.add(
      _buildRouteName(entry.key, entry.value.route, entry.value.arguments),
    );
  }
  result.add('');
  result.add(
    '  static ULoCRoute fromString(String? url) => ULoCRoute.fromString(url);',
  );
  result.add('');
  result.add('   /// use this to pass to [MaterialApp] Route setting');
  result.add(
    '  static final ULoCRouteConfiguration ulocRouteConfiguration = ULoCRouteConfiguration([',
  );
  for (MapEntry<String, RouteDeclaration> entry in routesMap.entries) {
    result.add('    RouteProperties<${entry.value.providerName}>(');
    result.add(
      '      routeName: Routes.${entry.key}${(entry.value.route.contains(':') || entry.value.arguments.isNotEmpty) ? '()' : ''},',
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

String _buildRouteName(String name, String value, Map<String, String> args) {
  if (value.contains(':') || args.isNotEmpty) {
    List<String> paramList = value
        .split('/')
        .where((e) => e.contains(':'))
        .map((e) => e.replaceAll(':', ''))
        .toList();

    final params = paramList.map((e) => 'String? $e').join(', ');
    final arguments = args.entries
        .map((e) => '${e.value}? ${e.key}')
        .join(', ');

    final functionParam = [
      params,
      arguments,
    ].where((e) => e.isNotEmpty).join(', ');
    final routeParams = paramList.isNotEmpty
        ? ', routeParams: [${paramList.join(', ')}]'
        : '';
    final argumentsText = args.isNotEmpty
        ? ", arguments: {${args.keys.map((e) => "'$e': $e").join(', ')}}"
        : '';

    return "  static ULoCRoute $name({$functionParam}) => ULoCRoute( '$value'$routeParams$argumentsText );";
  } else {
    return "  static ULoCRoute $name = ULoCRoute('$value');";
  }
}
