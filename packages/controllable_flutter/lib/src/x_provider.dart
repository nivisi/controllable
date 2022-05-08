import 'dart:async';

import 'package:controllable/controllable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef _ControllableCreate<T> = T Function(BuildContext context);

class XProvider<TController extends XController<TState, TEffect>,
    TState extends XState, TEffect> extends StatelessWidget {
  /// Use builder if you'd like to access your controller right after it was provided.
  final WidgetBuilder? builder;
  final Widget? child;

  final TController? _streamableValue;
  final _ControllableCreate<TController>? _streamableCreator;

  /// Whether to initialize the controller only after it is accessed for the first time (read/watched).
  final bool lazy;

  const XProvider({
    Key? key,
    required _ControllableCreate<TController> create,
    this.lazy = true,
    this.builder,
    this.child,
  })  : assert(
          (child != null && builder == null) ||
              (child == null && builder != null),
          'Either a child or a builder must be provided, not both at the same time',
        ),
        _streamableValue = null,
        _streamableCreator = create,
        super(key: key);

  const XProvider.value({
    Key? key,
    required TController value,
    this.lazy = true,
    this.builder,
    this.child,
  })  : assert(
          (child != null && builder == null) ||
              (child == null && builder != null),
          'Either a child or a builder must be provided, not both at the same time',
        ),
        _streamableValue = value,
        _streamableCreator = null,
        super(key: key);

  VoidCallback _startListening(
    BuildContext context,
    InheritedContext<TController?> element,
    TController controller,
  ) {
    controller.init();

    StreamSubscription? _effectSubscription;

    final stateSubscription = controller.stateStream.listen(
      (dynamic _) => element.markNeedsNotifyDependents(),
    );

    return () {
      _effectSubscription?.cancel();
      stateSubscription.cancel();
    };
  }

  @override
  Widget build(BuildContext context) {
    final value = _streamableValue;

    return value != null
        ? InheritedProvider<TController>.value(
            value: value,
            startListening: (element, controller) => _startListening(
              context,
              element,
              controller,
            ),
            lazy: lazy,
            child: builder != null ? Builder(builder: builder!) : child,
          )
        : InheritedProvider<TController>(
            create: _streamableCreator,
            dispose: (_, controller) => controller.dispose(),
            startListening: (element, controller) => _startListening(
              context,
              element,
              controller,
            ),
            child: builder != null ? Builder(builder: builder!) : child,
            lazy: lazy,
          );
  }
}
