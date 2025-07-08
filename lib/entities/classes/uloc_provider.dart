part of '../../uloc.dart';

class ULoCProvider with ChangeNotifier {
  /// The context of the provider.
  final BuildContext context;

  /// The constructor for the BaseProvider.
  ULoCProvider(this.context);

  /// get arguments from previous route
  Object? get arguments => context.routeArguments;

  /// moute state of this controller/widget
  bool get mounted => context.mounted;

  /// The query from routeName.
  /// ex: /home?utm_source=facebook&utm_medium=social
  Map<String, dynamic> get queryParametersAll {
    final result = <String, dynamic>{};
    for (var entry in Uri.parse(
      context.location ?? '',
    ).queryParametersAll.entries) {
      if (entry.value.length == 1) {
        result[entry.key] = entry.value.first;
      } else {
        result[entry.key] = entry.value;
      }
    }
    return result;
  }

  /// get query from routeName.
  /// ex: /home?utm_source=facebook&utm_medium=social
  Object? query(String? key) {
    return queryParametersAll[key];
  }

  // Map<String, dynamic> get query =>
  //     Uri.parse(context.location ?? '').queryParametersAll;

  void onInit() {
    _RouteUtilities.log('$runtimeType created');
  }

  void onReady() {
    _RouteUtilities.log('$runtimeType ready');
  }

  void onDispose() {
    _RouteUtilities.log('$runtimeType disposed');
  }

  void setstate([FutureOr<void> Function()? fn]) async {
    if (!mounted) return;
    if (fn != null) {
      await fn();
    }

    notifyListeners();
  }

  void printLog([Object? message]) {
    _RouteUtilities.log('[$runtimeType]: $message');
  }
}
