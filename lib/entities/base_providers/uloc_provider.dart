part of '../../uloc.dart';

/// A base provider class designed for use with the ULoC (Unified Logic of Component) architecture.
///
/// `ULoCProvider` serves as a state and lifecycle controller that extends
/// [ULoCProviderInterface] and mixes in [_WidgetNavigationModule]. It is intended to be
/// extended by feature-specific logic classes to manage widget state, navigation, and lifecycle events.
///
/// ### Features:
/// - Access to `context`, `mounted`, and navigation helpers.
/// - Lifecycle hooks: [onInit], [onReady], and [dispose].
/// - State management via [setState].
///
/// ### Example:
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
///
/// This class is best suited for stateful widgets that need a clear separation of logic and UI.
class ULoCProvider extends ULoCProviderInterface
    with ChangeNotifier, _WidgetNavigationModule {
  /// The constructor for the BaseProvider.
  ULoCProvider(super.context);

  /// Called once when the provider is first created.
  ///
  /// Override this method to perform initialization logic, such as loading
  /// data or reading arguments. This is similar to `initState()` in Flutter.
  ///
  /// If you override this method, you should call `super.onInit()` to retain
  /// base functionality like logging.
  @mustCallSuper
  void onInit() {
    printLog('Initialized');
  }

  /// Called after the widget has been rendered and the initial build is complete.
  ///
  /// This is similar to Flutter’s `SchedulerBinding.instance.addPostFrameCallback`
  /// and is useful for performing tasks that require the widget tree to be laid out,
  /// such as starting animations or showing dialogs.
  ///
  /// If you override this method, you should call `super.onReady()` to preserve
  /// base behavior like logging.
  @mustCallSuper
  void onReady() {
    printLog('Ready');
  }

  /// Called when the widget associated with this provider is disposed.
  ///
  /// Override this method to release any resources, cancel timers,
  /// or clean up listeners. Always call `super.dispose()` to ensure
  /// the base cleanup logic is executed, such as removing listeners
  /// and internal teardown.
  @override
  void dispose() {
    super.dispose();
    printLog('Disposed');
  }

  /// Updates the provider's state and notifies listeners.
  ///
  /// If a function [fn] is provided, it will be executed before notifying listeners.
  /// This function can be either synchronous or asynchronous.
  ///
  /// The method ensures the provider is still mounted before performing any updates.
  ///
  /// ### Example (sync):
  /// ```dart
  /// setState(() {
  ///   counter++;
  /// });
  /// ```
  ///
  /// ### Example (async):
  /// ```dart
  /// setState(() async {
  ///   final result = await fetchData();
  ///   data = result;
  /// });
  /// ```
  ///
  /// You can also call it without a function to simply trigger a rebuild:
  /// ```dart
  /// setState();
  /// ```
  void setState([FutureOr<void> Function()? fn]) async {
    if (!mounted) return;
    if (fn != null) {
      await fn();
    }
    notifyListeners();
  }
}
