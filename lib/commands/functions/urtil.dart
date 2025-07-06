import 'dart:async';
import 'dart:io';

import 'package:uloc/commands/entities/const.dart';
import 'package:uloc/commands/entities/route_declaration.dart';

String snakeToPascal(String input) {
  return input
      .split('_')
      .map(
        (word) =>
            word.isEmpty ? '' : '${word[0].toUpperCase()}${word.substring(1)}',
      )
      .join();
}

Map<String, RouteDeclaration> parseULoCRoutesToJson(String source) {
  final routeMap = <String, RouteDeclaration>{};

  final routeRegex = RegExp(
    r"'(\w+)':\s*ULoCRoute\(\s*"
    r"route:\s*'([^']+)',\s*"
    r"provider:\s*\(([^)]+)\)\s*=>\s*([^\n]+?),\s*"
    r"child:\s*([^\n,]+)",
    multiLine: true,
  );

  for (final match in routeRegex.allMatches(source)) {
    final key = match.group(1) ?? ''; // e.g. 'HOME'
    final route = match.group(2) ?? ''; // e.g. '/'
    final providerArgs = match.group(3) ?? ''; // e.g. context, _
    final providerBody = match.group(4)?.trim(); // e.g. HomeController(context)
    final child =
        match.group(5)?.trim().replaceAll(',', '') ??
        'UnknownChild'; // e.g. Home

    // Extract provider name (e.g., HomeController from HomeController(context))
    final providerNameMatch = RegExp(
      r'(\w+)\s*\(',
    ).firstMatch(providerBody ?? '');
    final providerName = providerNameMatch?.group(1) ?? 'UnknownProvider';

    routeMap[key] = RouteDeclaration(
      routeName: key,
      route: route,
      providerName: providerName,
      provider: '($providerArgs) => $providerBody',
      child: child,
    );
  }

  return routeMap;
}

String convertPathToImport(String path) {
  if (!path.toLowerCase().startsWith('lib')) {
    return path;
  }
  File yaml = File('pubspec.yaml');
  final packageName = yaml
      .readAsLinesSync()
      .firstWhere(
        (e) => e.startsWith('name: '),
        orElse: () => 'name: unknownPackageName',
      )
      .split('name: ')
      .last;
  final result = path
      .replaceFirst('lib', 'package:$packageName')
      .replaceAll('\\', '/');

  return "import '$result';";
}

Future checkExistAndExit(String name, Stream<String> stdInputStream) async {
  stdout.write(
    "$green$name$reset is already exist. Do you want to replace it? [y/n] ",
  );
  final Completer<String> completer = Completer();
  final listener = stdInputStream.listen((event) {
    if (event.isNotEmpty) {
      completer.complete(event[0]);
    } else {
      completer.complete('n');
    }
  });
  final inp = await completer.future;
  listener.cancel();
  if (inp.toLowerCase() != 'y') {
    exit(0);
  }
}
