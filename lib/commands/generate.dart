// ignore_for_file: avoid_print

import 'dart:io';

class GenerateCommand {
  final _Command _command;
  GenerateCommand(List<String> args) : _command = _Command(args);

  void run() async {
    try {
      switch (_command.command) {
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
    List<String> pageParameters = [];

    if (_command.length >= 2 && (_command.get(1)?.isNotEmpty ?? false)) {
      pageName = _command.get(1) ?? '';
      final regex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
      if (regex.hasMatch(pageName)) {
        throw Exception(
          '$pageName name is invalid\nFile name must not contain special characters',
        );
      }
    } else {
      throw Exception('page name must be provided');
    }

    if (_command.param['dir']?.isNotEmpty ?? false) {
      dir = Directory(
        _command.param['dir']
                ?.replaceAll('/', pathSeparator)
                .replaceAll('\\', pathSeparator) ??
            '',
      );
    }

    if (_command.param['params']?.isNotEmpty ?? false) {
      pageParameters = _command.param['params']?.split(',') ?? [];
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
    if (pageParameters.isNotEmpty) {
      for (var paramName in pageParameters) {
        result.add('  final String $paramName;');
      }
      result.add(
        '  $controllerClassName(super.context, ${pageParameters.map((e) => 'this.$e').join(', ')});',
      );
    } else {
      result.add('  $controllerClassName(super.context);');
    }
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

    if (_command.length >= 2 && (_command.get(1)?.isNotEmpty ?? false)) {
      declaredFile = File(_command.get(1) ?? '');
      if (!declaredFile.existsSync()) {
        throw Exception('${_command.get(1) ?? ''} is not found');
      }
    }

    final content = declaredFile.readAsStringSync();

    if (!content.contains(annotation)) {
      throw Exception('${_command.get(1) ?? ''} Cannot find ULoCDeclaration');
    }

    final imports = content.split(annotation).first;

    if (_command.length >= 3 && (_command.get(2)?.isNotEmpty ?? false)) {
      routesFile = File(_command.get(2) ?? '');
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

class _Command {
  String fullCommand = '';
  int length = 0;
  String command = '';
  Map<String, String> param = {};
  final List<String> input;
  _Command(this.input) {
    if (input.isEmpty) {
      return;
    }

    length = input.length;

    command = input.first;

    param = {};

    for (int i = 1; i < input.length; i++) {
      final part = input[i];
      if (part.startsWith('--')) {
        final key = part.substring(2);
        String? value;

        // Check if next part exists and is not another flag
        if (i + 1 < input.length && !input[i + 1].startsWith('--')) {
          value = input[i + 1];
          i++; // Skip the value
        }
        param[key] = value ?? '';
      }
    }
  }

  String? get(int index) {
    try {
      return input[index];
    } catch (e) {
      return null;
    }
  }
}
