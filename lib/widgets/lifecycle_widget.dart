part of '../uloc.dart';

class _RouteWithProvider<P extends ULoCProvider> extends StatefulWidget {
  const _RouteWithProvider({required this.child});
  final Widget child;
  @override
  State<_RouteWithProvider> createState() => _RouteWithProviderState<P>();
}

class _RouteWithProviderState<P extends ULoCProvider>
    extends State<_RouteWithProvider> {
  late P controller;

  @override
  void initState() {
    super.initState();
    controller = context.read<P>();
    controller.onInit();
    WidgetsBinding.instance.addPostFrameCallback((t) {
      controller.onReady();
    });
  }

  @override
  void dispose() {
    controller.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
