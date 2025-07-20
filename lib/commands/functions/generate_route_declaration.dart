import 'dart:io';

import 'package:args/args.dart';
import 'package:uloc/commands/cmd_enum.dart';
import 'package:uloc/commands/command.dart';
import 'package:uloc/commands/const.dart';
import 'package:uloc/commands/functions/generate_route.dart';
import 'package:uloc/commands/functions/urtil.dart';
import 'package:uloc/commands/route_declaration.dart';

Future generateRouteDeclaration({
  required String viewClassName,
  required String controllerClassName,
  required String controllerInport,
  required String viewInport,
  required String pageName,
  required List<String> pageParameters,
  required Map<String, String> pageArgs,
  required ArgResults cmdArgs,
  required Stream<String> stdInputStream,
}) async {
  File declaredFile = File(defaultRouteDeclarationFileDir);

  final customDeclaredDir =
      cmdArgs.command?.name ??
      cmdArgs.option(CommandFlag.routeDeclarationDir) ??
      '';

  if (customDeclaredDir.isNotEmpty) {
    declaredFile = File(customDeclaredDir);
  }

  if (!declaredFile.existsSync()) {
    declaredFile.createSync(recursive: true);
  }

  final content = declaredFile.readAsStringSync();

  if (!content.contains(annotation)) {
    throw Exception('$customDeclaredDir Cannot find ULoCDeclaration');
  }

  final imports = content.split(annotation).first.trim();

  final routesMap = parseULoCRoutesToJson(content);

  final routeName = pageName.toUpperCase();

  final route = ['', pageName, ...pageParameters.map((e) => ':$e')].join('/');

  final params = pageParameters.map((e) => "$e: route?.param('$e')").join(', ');
  final arguments = pageArgs.entries
      .map((e) => "${e.value}: route?.arguments<${e.key}>('${e.value}')")
      .join(', ');

  final functionParam = [params, arguments].join(', ');

  final provider = pageParameters.isNotEmpty || pageArgs.isNotEmpty
      ? "(context, route) => $controllerClassName( context, $functionParam )"
      : "(context, _) => $controllerClassName(context)";

  if (routesMap[routeName] != null) {
    await checkExistAndExit(routeName, stdInputStream);
  }
  routesMap[routeName] = RouteDeclaration(
    routeName: routeName,
    route: route,
    providerName: controllerClassName,
    provider: provider,
    arguments: pageArgs,
    child: viewClassName,
  );

  List<String> result = [];

  result.add(imports);
  if (!imports.contains(controllerInport)) {
    result.add(controllerInport);
  }
  if (!imports.contains(viewInport)) {
    result.add(viewInport);
  }
  result.add('');
  result.add('@ULoCDeclaration()');
  result.add('class MyRoutes extends ULoCRouteDeclaration {');
  result.add('  @override');
  result.add('  Map<String, ULoCRouteDefine<ULoCProvider>> get route => {');
  for (RouteDeclaration declaration in routesMap.values) {
    result.add("    '${declaration.routeName}': ULoCRouteDefine(");
    result.add("      route: '${declaration.route}',");
    result.add("      provider: ${declaration.provider},");
    result.add("      child: ${declaration.child},");
    result.add("    ),");
  }
  result.add('  };');
  result.add('}');
  result.add('');
  declaredFile.writeAsStringSync(result.join('\n'));

  print('$green File generated: ${declaredFile.absolute.path} $reset');

  final Command command = Command([
    CommandFlag.genRoute,
    if (cmdArgs.option(CommandFlag.routeDeclarationDir)?.isNotEmpty ??
        false) ...[
      '--${CommandFlag.dir}',
      cmdArgs.option(CommandFlag.routeDeclarationDir) ?? '',
    ],
    if (cmdArgs.option(CommandFlag.routeTargetDir)?.isNotEmpty ?? false) ...[
      '--${CommandFlag.target}',
      cmdArgs.option(CommandFlag.routeTargetDir) ?? '',
    ],
  ]);
  generateRoute(command.cmdArgs.command!);

  exit(0);
}
