part of '../uloc.dart';

class _RouteWithProvider<P extends ULoCProvider> extends StatefulWidget {
  const _RouteWithProvider({
    required this.child,
    List<BuildContext>? ancestorContext,
  }) : _ancestorContext = ancestorContext;
  final Widget child;
  final List<BuildContext>? _ancestorContext;
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
    controller._ancestorContexts = [
      ...(widget._ancestorContext ?? []),
      context,
    ];
    WidgetsBinding.instance.addPostFrameCallback((t) {
      controller.onReady();
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
