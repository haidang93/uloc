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
