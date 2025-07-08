import 'dart:io';

const green = '\x1B[32m';
const red = '\x1B[31m';

const reset = '\x1B[0m';

const annotation = '@ULoCDeclaration()';

const transitionParamKey = '@transition';
const curveParamKey = '@curve';

final pathSeparator = Platform.pathSeparator;

final defaultPageDir = ['lib', 'app', 'screens'].join(pathSeparator);

final defaultRouteDeclarationFileDir = [
  'lib',
  'routes',
  'routes.dart',
].join(pathSeparator);

final defaultRouteFileDir = [
  'lib',
  'routes',
  'routes.uloc.g.dart',
].join(pathSeparator);
