part of '../../uloc.dart';

/// ```dart
/// class DetailController extends ULoCProvider {
///   final String? id;
///   final BookDetail? data;
///   DetailController(super.context, {this.id, this.data});
///   String name = "Detail";
///   String content = "Detail has not yet implemented";
///
///   int count = 0;
///
///   @override
///   void init() {
///     super.init();
///
///     // get query from route
///     String utmSource = query('utm_source');
///     Map<String, dynamic> allQuery = queryParametersAll;
///
///     // get Flutter route arguments
///     final dynamic args =  arguments;
///
///     // get ULoC route arguments
///     final Map<String, dynamic>? args =  ulocArguments;
///   }
///
///   @override
///   void ready() {
///     super.ready();
///   }
///
///   @override
///   void dispose() {
///     super.dispose();
///   }
///
///   void increment() {
///     count++;
///     setstate();
///   }
///
///   void decrement() {
///     setstate(() {
///       count--;
///     });
///   }
/// }
///
/// ```
class ULoCProvider extends ULoCProviderInterface
    with ChangeNotifier, _WidgetNavigationModule {
  /// The constructor for the BaseProvider.
  ULoCProvider(super.context);

  /// Run when provider created
  @mustCallSuper
  void onInit() {
    printLog('Initialized');
  }

  /// Run after widget finish render
  @mustCallSuper
  void onReady() {
    printLog('Ready');
  }

  /// Run when widget disposed
  @override
  void dispose() {
    super.dispose();
    printLog('Disposed');
  }

  /// update state
  void setState([FutureOr<void> Function()? fn]) async {
    if (!mounted) return;
    if (fn != null) {
      await fn();
    }
    notifyListeners();
  }
}
