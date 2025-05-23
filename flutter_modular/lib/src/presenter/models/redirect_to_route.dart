import 'package:flutter/widgets.dart';
import 'package:modular_core/modular_core.dart';

import 'child_route.dart';
import 'route.dart';

/// A route to redirect.
class RedirectRoute extends ChildRoute {
  final String to;
  RedirectRoute(
    String name, {
    required this.to,
  }) : super(name, child: (_) => const SizedBox());

  @override
  RedirectRoute copyWith({
    ModularChild? child,
    Module? module,
    TransitionType? transition,
    CustomTransition? customTransition,
    Duration? duration,
    bool? isFullscreenDialog,
    String? name,
    String? schema,
    void Function(dynamic)? popCallback,
    List<Middleware>? middlewares,
    List<ModularRoute>? children,
    String? parent,
    Uri? uri,
    Map<ModularKey, ModularRoute>? routeMap,
    Map<Type, Module>? innerModules,
  }) {
    return this;
  }
}
