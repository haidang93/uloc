import 'dart:io';

import 'package:uloc/commands/entities/command.dart';
import 'package:uloc/commands/entities/const.dart';
import 'package:uloc/commands/entities/enum.dart';
import 'package:uloc/commands/functions/generate_page.dart';
import 'package:uloc/commands/functions/generate_route.dart';

class GenerateCommand {
  final Command _command;
  GenerateCommand(List<String> args) : _command = Command(args);

  void run() async {
    try {
      final cmdArgs = _command.cmdArgs;

      if ([
        CommandFlag.genPage,
        CommandFlag.genPage.shortHand,
      ].contains(cmdArgs.command?.name)) {
        await generatePage(cmdArgs.command!);
        return;
      }

      if ([
        CommandFlag.genRoute,
        CommandFlag.genRoute.shortHand,
      ].contains(cmdArgs.command?.name)) {
        generateRoute(cmdArgs.command!);
        return;
      }

      if (cmdArgs.flag(CommandFlag.help) ||
          cmdArgs.command?.name == CommandFlag.help) {
        print(_command.helpText());
        return;
      }

      throw Exception("Please enter a command");
    } catch (e) {
      print('$red${e.toString()}$reset');
      exit(1);
    }
  }
}
