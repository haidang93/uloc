part of '../../uloc.dart';

class ULoCProvider with ChangeNotifier {
  /// The context of the provider.
  final BuildContext context;

  /// The constructor for the BaseProvider.
  ULoCProvider(this.context);

  void onInit() {
    log('$runtimeType created', name: 'PROV:');
  }

  void onReady() {
    log('$runtimeType ready', name: 'PROV:');
  }

  void onDispose() {
    log('$runtimeType disposed', name: 'PROV:');
  }

  void setstate([FutureOr<void> Function()? fn]) async {
    if (fn != null) {
      await fn();
    }

    notifyListeners();
  }
}
