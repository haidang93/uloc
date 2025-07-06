import 'dart:io';

import 'package:args/args.dart';
import 'package:uloc/commands/entities/const.dart';
import 'package:uloc/commands/entities/enum.dart';
import 'package:uloc/commands/functions/urtil.dart';

void generatePage(ArgResults cmdArgs) {
  Directory dir = Directory(defaultPageDir);
  String pageName = '';
  List<String> pageParameters = [];

  if (cmdArgs.arguments.isNotEmpty &&
      !cmdArgs.arguments.first.startsWith('-')) {
    pageName = cmdArgs.arguments.first;
    final regex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    if (regex.hasMatch(pageName)) {
      throw Exception(
        '$pageName name is invalid\nFile name must not contain special characters',
      );
    }
  } else {
    throw Exception('page name must be provided');
  }

  final customDir = cmdArgs.option(CommandFlag.dir) ?? '';
  if (customDir.isNotEmpty) {
    dir = Directory(
      customDir.replaceAll('/', pathSeparator).replaceAll('\\', pathSeparator),
    );
  }

  final parameters = cmdArgs.option(CommandFlag.parameters) ?? '';
  if (parameters.isNotEmpty) {
    pageParameters = parameters.split(',');
  }

  String viewName = '${pageName.toLowerCase()}_page';
  String controllerName = '${pageName.toLowerCase()}_controller';

  File viewFile = File(
    [
      dir.path,
      pageName,
      'views',
      'pages',
      '$viewName.dart',
    ].join(pathSeparator),
  );
  File controllerFile = File(
    [
      dir.path,
      pageName,
      'controllers',
      '$controllerName.dart',
    ].join(pathSeparator),
  );
  if (!viewFile.existsSync()) {
    viewFile.createSync(recursive: true);
  }
  if (!controllerFile.existsSync()) {
    controllerFile.createSync(recursive: true);
  }

  List<String> result = [];
  final viewClassName = snakeToPascal(viewName);
  final controllerClassName = snakeToPascal(controllerName);

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
  if (pageParameters.contains('name')) {
    result.add(
      '      appBar: AppBar(title: Text(watch.name ?? "${snakeToPascal(pageName)}")),',
    );
  } else {
    result.add('      appBar: AppBar(title: Text(watch.name)),');
  }
  if (pageParameters.contains('content')) {
    result.add(
      '      body: Center(child: Text(watch.content ?? "${snakeToPascal(pageName)} has not yet implemented")),',
    );
  } else {
    result.add('      body: Center(child: Text(watch.content)),');
  }
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
      result.add('  final String? $paramName;');
    }
    result.add(
      '  $controllerClassName(super.context, {${pageParameters.map((e) => 'this.$e').join(', ')}});',
    );
  } else {
    result.add('  $controllerClassName(super.context);');
  }
  if (!pageParameters.contains('name')) {
    result.add('  String name = "${snakeToPascal(pageName)}";');
  }
  if (!pageParameters.contains('content')) {
    result.add(
      '  String content = "${snakeToPascal(pageName)} has not yet implemented";',
    );
  }
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
  exit(0);
}
