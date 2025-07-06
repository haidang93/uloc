// ignore_for_file: avoid_print

import 'dart:io';

import 'package:args/args.dart';
import 'package:uloc/commands/entities/const.dart';
import 'package:uloc/commands/entities/enum.dart';

class Command {
  final List<String> input;
  Command(this.input) {
    initialize();
  }

  late ArgResults cmdArgs;

  String _globalUsageText = '';

  final _commands = <CMDPros>[
    CMDPros(
      name: [CommandFlag.genRoute, CommandFlag.genRoute.shortHand],
      parser: ArgParser()
        ..addOption(
          CommandFlag.dir,
          abbr: CommandFlag.dir.abbr,
          help:
              "Custom routes declaration dir. Default: lib/routes/routes.dart",
        )
        ..addOption(
          CommandFlag.target,
          abbr: CommandFlag.target.abbr,
          help: "Custom routes dir. Default: lib/routes/routes.uloc.g.dart",
        ),
      help:
          "Generate routing files for the current project from ULoCDeclaration - default path: lib/routes/routes.dart.",
    ),
    CMDPros(
      name: [CommandFlag.genPage, CommandFlag.genPage.shortHand],
      parser: ArgParser()
        ..addOption(
          CommandFlag.dir,
          abbr: CommandFlag.dir.abbr,
          help: "Custom dir for new page files. Default: lib/app/screens/",
        )
        ..addMultiOption(
          CommandFlag.parameters,
          abbr: CommandFlag.parameters.abbr,
          help:
              "List of page parameters separated by commas. Ex: id,name,email",
        )
        ..addFlag(
          CommandFlag.genRoute,
          abbr: CommandFlag.genRoute.abbr,
          help:
              "enable to generate route declaration after create page. Default: lib/routes/routes.uloc.g.dart",
        )
        ..addOption(
          CommandFlag.routeDeclarationDir,
          abbr: CommandFlag.routeDeclarationDir.abbr,
          help:
              "Custom routes declaration dir. Default: lib/routes/routes.dart",
        )
        ..addOption(
          CommandFlag.routeTargetDir,
          abbr: CommandFlag.target.abbr,
          help: "Custom routes dir. Default: lib/routes/routes.uloc.g.dart",
        ),
      help:
          "Generate new page widget with [name] - default path: lib/app/screens/.",
    ),
  ];

  void initialize() {
    final parser = ArgParser()
      // add global options and commands
      ..addCommand(CommandFlag.help)
      ..addFlag(
        CommandFlag.help,
        abbr: CommandFlag.help.abbr,
        negatable: false,
        help: "Print this usage information.",
      );

    for (var commandProp in _commands) {
      // add command
      for (var command in commandProp.name) {
        parser.addCommand(command, commandProp.parser);
      }
    }

    _globalUsageText = parser.usage;

    try {
      cmdArgs = parser.parse(input);
    } on Exception catch (e) {
      print('$red$e$reset');
      exit(1);
    }
  }

  String helpText() =>
      '''
///////////////////////////////////////////////////////
//                                                   //
//     //     //  //                     ///////     //
//     //     //  //         //////    ///    ///    //
//     //     //  //        //    //  ///            //
//     //     //  //        //    //  ///   ///      //
//      ///////   ////////   //////    //////        //
//                                                   //
//                     ULoC                          //
///////////////////////////////////////////////////////

Usage: dart run uloc <command> [arguments]

Global options:
$_globalUsageText

Available commands:

${_commands.map((commands) => '${commands.name.join(', ')}: ${commands.help ?? ''}\n${commands.parser?.usage ?? ''}').join('\n\n')}

${green}For more information, visit https://dannynguyen.vn/packages/dart-flutter/uloc$reset
  ''';
}

class CMDPros {
  CMDPros({required this.name, this.parser, this.help});
  final List<String> name;
  final ArgParser? parser;
  final String? help;
}
