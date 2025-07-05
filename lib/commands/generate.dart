// ignore_for_file: avoid_print

import 'dart:io';

class GenerateCommand {
  final List<String> args;
  GenerateCommand(this.args);

  void run() async {
    try {
      switch (args[0]) {
        case 'gen':
          gen();
          break;
        case 'new':
          newPage();
          break;
        default:
          throw Exception();
      }
    } catch (e) {
      print(
        [
          'Help:',
          '* Generate routes:',
          '  dart run uloc gen',
          '',
          '* Generate routes with paths:',
          '  dart run uloc gen <target> <destination>',
          '',
          '* Generate new screen widget:',
          '  dart run uloc new <widget_name> <dir>',
          '',
          '',
          '',
        ].join('\n'),
      );
      print(e);
      exit(1);
    }
  }

  void newPage() {
    final pathSeparator = Platform.pathSeparator;
    Directory dir = Directory(['lib', 'app', 'screens'].join(pathSeparator));
    String pageName = '';

    if (args.length >= 2 && args[1] != '') {
      pageName = args[1];
      final regex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
      if (regex.hasMatch(pageName)) {
        throw Exception(
          '$pageName name is invalid\nFile name must not contain special characters',
        );
      }
    } else {
      throw Exception('page name must be provided');
    }

    if (args.length >= 3 && args[2] != '') {
      dir = Directory(
        args[2].replaceAll('/', pathSeparator).replaceAll('\\', pathSeparator),
      );
    }

    String viewName = '${pageName.toLowerCase()}_page';
    String controllerName = '${pageName.toLowerCase()}_controller';

    File viewFile = File(
      [dir.path, 'views', 'pages', '$viewName.dart'].join(pathSeparator),
    );
    File controllerFile = File(
      [dir.path, 'controllers', '$controllerName.dart'].join(pathSeparator),
    );
    if (!viewFile.existsSync()) {
      viewFile.createSync(recursive: true);
    }
    if (!controllerFile.existsSync()) {
      controllerFile.createSync(recursive: true);
    }

    const green = '\x1B[32m';
    const reset = '\x1B[0m';

    List<String> result = [];
    final viewClassName = _snakeToPascal(viewName);
    final controllerClassName = _snakeToPascal(controllerName);

    //
    //
    //
    //
    //
    // Generate view file
    result.add("import 'package:flutter/material.dart';");
    result.add("import 'package:uloc/uloc.dart';");
    result.add('');
    result.add("import '../../controllers/$controllerName.dart';");
    result.add('');
    result.add('class $viewClassName extends StatefulWidget {');
    result.add('  const $viewClassName({super.key});');
    result.add('');
    result.add('  @override');
    result.add(
      '  State<$viewClassName> createState() => _${viewClassName}State();',
    );
    result.add('}');
    result.add('');
    result.add('class _${viewClassName}State extends State<$viewClassName> {');
    result.add(
      '  $controllerClassName get watch => context.watch<$controllerClassName>();',
    );
    result.add(
      '  $controllerClassName get controller => context.read<$controllerClassName>();',
    );
    result.add('');
    result.add('  @override');
    result.add('  Widget build(BuildContext context) {');
    result.add('    return Scaffold(');
    result.add('      appBar: AppBar(title: Text(watch.name)),');
    result.add('      body: Center(child: Text(watch.content)),');
    result.add('    );');
    result.add('  }');
    result.add('}');
    result.add('');

    viewFile.writeAsStringSync(result.join('\n'));
    print('$green File generated: ${viewFile.absolute.path} $reset');

    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    // Generate controller file
    result.clear();
    result.add("import 'package:uloc/uloc.dart';");
    result.add('');
    result.add('class $controllerClassName extends ULoCProvider {');
    result.add('  $controllerClassName(super.context);');
    result.add('  String name = "Home";');
    result.add('  String content = "Home has not yet implemented";');
    result.add('');
    result.add('  @override');
    result.add('  void onInit() {');
    result.add('    super.onInit();');
    result.add('  }');
    result.add('');
    result.add('  @override');
    result.add('  void onReady() {');
    result.add('    super.onReady();');
    result.add('  }');
    result.add('');
    result.add('  @override');
    result.add('  void onDispose() {');
    result.add('    super.onDispose();');
    result.add('  }');
    result.add('');
    result.add('}');
    result.add('');

    controllerFile.writeAsStringSync(result.join('\n'));
    print('$green File generated: ${controllerFile.absolute.path} $reset');

    exit(0);
  }

  void gen() {
    final pathSeparator = Platform.pathSeparator;
    final annotation = '@ULoCDeclaration()';
    File declaredFile = File(
      ['lib', 'routes', 'routes.dart'].join(pathSeparator),
    );
    File routesFile = File(
      ['lib', 'routes', 'routes.uloc.g.dart'].join(pathSeparator),
    );

    if (args.length >= 2 && args[1] != '') {
      declaredFile = File(args[1]);
      if (!declaredFile.existsSync()) {
        throw Exception('${args[1]} is not found');
      }
    }

    final content = declaredFile.readAsStringSync();

    if (!content.contains(annotation)) {
      throw Exception('${args[1]} Cannot find ULoCDeclaration');
    }

    final imports = content.split(annotation).first;

    if (args.length >= 3 && args[2] != '') {
      routesFile = File(args[2]);
      if (!routesFile.existsSync()) {
        routesFile.createSync(recursive: true);
      }
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
    for (MapEntry<String, Map<String, String>> entry in routesMap.entries) {
      result.add(buildRouteName(entry.key, entry.value['route'] ?? ''));
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
    const green = '\x1B[32m';
    const reset = '\x1B[0m';

    print('$green File generated: ${routesFile.absolute.path} $reset');
    exit(0);
  }

  String buildRouteName(String name, String value) {
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

  Map<String, Map<String, String>> parseULoCRoutesToJson(String source) {
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
      final providerBody = match
          .group(4)!
          .trim(); // e.g. HomeController(context)
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

  String _snakeToPascal(String input) {
    return input
        .split('_')
        .map(
          (word) => word.isEmpty
              ? ''
              : '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join();
  }
}
