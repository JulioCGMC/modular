import 'dart:async';

import 'package:flutter_modular/src/presenter/models/route.dart';
import 'package:modular_core/modular_core.dart';

import '../errors/errors.dart';
import '../models/redirect_to_route.dart';

/// RouteGuard implements Middleware and adds guard behavior,
/// authorizing or not the route via the canActivate() method;
abstract class RouteGuard extends Middleware<ModularArguments> {
  /// Returns a FutureOr<bool>.
  /// If true, allow the route to continue processing.
  /// If it is false, the Guard will try to redirect the route.
  /// If there is no redirect then an error will
  /// be thrown [GuardedRouteException].
  FutureOr<bool> canActivate(String path, ParallelRoute route);

  /// If the route is not allowed then the Guard will redirect to that route.
  final String? redirectTo;

  RouteGuard({this.redirectTo});

  @override
  FutureOr<ModularRoute?> pre(ModularRoute route) => route;

  @override
  FutureOr<ParallelRoute?> pos(
    ModularRoute route,
    ModularArguments data,
  ) async {
    if (await canActivate(data.uri.toString(), route as ParallelRoute)) {
      return route;
    } else if (redirectTo != null) {
      return RedirectRoute(route.name, to: redirectTo!);
    }

    throw GuardedRouteException(route.uri.toString().trim());
  }
}
