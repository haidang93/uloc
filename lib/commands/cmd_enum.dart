class CommandFlag {
  static const genRoute = 'gen-route';
  static const genPage = 'gen-page';
  static const help = 'help';
  static const dir = 'dir';
  static const routeDeclarationDir = 'route-declaration-dir';
  static const routeTargetDir = 'route-target-dir';
  static const parameters = 'parameters';
  static const addPageArgs = 'add-page-arg';
  static const target = 'target';
  static const name = 'name';
}

extension CommandFlagFunction on String {
  String get abbr => length != 0 ? this[0] : '';
  String get shortHand => split('-').map((e) => e[0]).join();
}
