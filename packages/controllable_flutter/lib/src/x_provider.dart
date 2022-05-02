import 'dart:async';

import 'package:controllable/controllable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef _ControllableCreate<T> = T Function(BuildContext context);

class XProvider<TController extends XController<TState, TEffect>,
    TState extends XState, TEffect> extends StatelessWidget {
  final Widget child;
  final TController? _streamableValue;
  final _ControllableCreate<TController>? _streamableCreator;
  final bool lazy;

  const XProvider({
    Key? key,
    required this.child,
    required _ControllableCreate<TController> create,
    this.lazy = true,
  })  : _streamableValue = null,
        _streamableCreator = create,
        super(key: key);

  const XProvider.value({
    Key? key,
    required this.child,
    required TController value,
    this.lazy = true,
  })  : _streamableValue = value,
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
            child: child,
          )
        : InheritedProvider<TController>(
            create: _streamableCreator,
            dispose: (_, controller) => controller.dispose(),
            startListening: (element, controller) => _startListening(
              context,
              element,
              controller,
            ),
            child: child,
            lazy: lazy,
          );
  }
}
