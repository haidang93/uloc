part of '../../uloc.dart';

class ULoCProvider with ChangeNotifier {
  /// The context of the provider.
  final BuildContext context;

  /// The constructor for the BaseProvider.
  ULoCProvider(this.context);

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
    if (fn != null) {
      await fn();
    }

    notifyListeners();
  }
}
