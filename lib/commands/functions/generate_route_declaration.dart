import 'dart:io';

import 'package:args/args.dart';
import 'package:uloc/commands/entities/command.dart';
import 'package:uloc/commands/entities/const.dart';
import 'package:uloc/commands/entities/enum.dart';
import 'package:uloc/commands/entities/route_declaration.dart';
import 'package:uloc/commands/functions/generate_route.dart';
import 'package:uloc/commands/functions/urtil.dart';

Future generateRouteDeclaration({
  required String viewClassName,
  required String controllerClassName,
  required String controllerInport,
  required String viewInport,
  required String pageName,
  required List<String> pageParameters,
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

  final content = declaredFile.readAsStringSync();

  if (!content.contains(annotation)) {
    throw Exception('$customDeclaredDir Cannot find ULoCDeclaration');
  }

  final imports = content.split(annotation).first.trim();

  final routesMap = parseULoCRoutesToJson(content);

  final routeName = pageName.toUpperCase();

  final route = ['', pageName, ...pageParameters.map((e) => ':$e')].join('/');

  final provider = pageParameters.isNotEmpty
      ? "(context, params) => $controllerClassName(context, ${pageParameters.map((e) => "$e: params?['$e']").join(', ')})"
      : "(context, _) => $controllerClassName(context)";

  if (routesMap[routeName] != null) {
    await checkExistAndExit(routeName, stdInputStream);
  } else {
    routesMap[routeName] = RouteDeclaration(
      routeName: routeName,
      route: route,
      providerName: controllerClassName,
      provider: provider,
      child: viewClassName,
    );
  }

  List<String> result = [];

  result.add(imports);
  result.add(controllerInport);
  result.add(viewInport);
  result.add('');
  result.add('@ULoCDeclaration()');
  result.add('class MyRoutes extends ULoCRouteDeclaration {');
  result.add('  @override');
  result.add('  Map<String, ULoCRoute<ULoCProvider>> get route => {');
  for (RouteDeclaration declaration in routesMap.values) {
    result.add("    '${declaration.routeName}': ULoCRoute(");
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
