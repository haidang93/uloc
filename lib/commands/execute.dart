part of '../../uloc.dart';

class ExecuteCommand {
  final Command _command;
  ExecuteCommand(List<String> args) : _command = Command(args);

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
