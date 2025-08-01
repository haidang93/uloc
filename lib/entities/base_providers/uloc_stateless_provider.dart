part of '../../uloc.dart';

/// A lightweight provider class for stateless widget logic and lifecycle handling.
///
/// `ULoCStatelessProvider` is designed to be used with stateless widgets that need
/// scoped logic handling without holding internal mutable state. It extends
/// [ULoCProviderInterface] and mixes in [_WidgetNavigationModule] for navigation support.
///
/// This class introduces a simple lifecycle:
/// - [onCreate]: Called immediately after construction. Ideal for initial setup or data loading.
/// - [onReady]: Called after the first frame is rendered. Ideal for layout-dependent logic,
///   dialog display, or navigation.
///
/// Subclasses are expected to override [onCreate] and [onReady] for customization,
/// while always calling their respective `super` methods to ensure proper initialization.
///
/// Example:
/// ```dart
/// class MyProvider extends ULoCStatelessProvider {
///   MyProvider(super.context);
///
///   @override
///   void onCreate() {
///     super.onCreate();
///     // Initial setup
///   }
///
///   @override
///   void onReady() {
///     super.onReady();
///     // Perform actions after build
///   }
/// }
/// ```
///
/// This class is best suited for widgets that don’t require persistent state changes,
/// but still benefit from lifecycle-aware separation of concerns.
class ULoCStatelessProvider extends ULoCProviderInterface
    with _WidgetNavigationModule {
  ULoCStatelessProvider(super.context);

  /// Called immediately after the provider is constructed.
  ///
  /// Use this method to perform any initial setup or logic that should
  /// happen as soon as the provider is created. This includes setting
  /// default values, fetching initial data, or registering listeners.
  ///
  /// Subclasses **must** call `super.onCreate()` when overriding this method,
  /// as it ensures essential base initialization runs.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// void onCreate() {
  ///   super.onCreate();
  ///   // Custom setup here
  /// }
  /// ```
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
