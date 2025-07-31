part of '../../uloc.dart';

class ULoCStatelessProvider extends ULoCProviderInterface
    with _WidgetNavigationModule {
  ULoCStatelessProvider(super.context);

  /// Called immediately after the provider is created.
  /// Triggers [onReady] after the first frame is rendered.
  @override
  void onCreate() {
    super.onCreate();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onReady();
    });
  }

  /// Called after the widget has completed its first frame rendering.
  ///
  /// This method is triggered automatically at the end of `onCreate()` using
  /// `WidgetsBinding.instance.addPostFrameCallback`. Override this method
  /// to perform tasks that require the widget to be fully built,
  /// such as navigation, showing dialogs, or fetching layout-related data.
  ///
  /// Subclasses overriding this method must call `super.onReady()` to ensure
  /// base functionality (e.g., logging) is not skipped.
  ///
  /// Example use:
  /// ```dart
  /// @override
  /// void onReady() {
  ///   super.onReady();
  ///   // Perform additional tasks here.
  /// }
  /// ```
  @mustCallSuper
  void onReady() {
    printLog('Ready');
  }
}
