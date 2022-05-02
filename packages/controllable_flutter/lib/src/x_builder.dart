import 'package:controllable/controllable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef XSelector<TController, TValue> = TValue Function(
  TController controller,
);

typedef _XBuilder<TValue> = Widget Function(
  BuildContext context,
  TValue value,
);

/// A builder that can be used if a widget must be rebuilt every time a new state is emitted.
class XBuilder<TController extends XController<TState, TEffect>,
    TState extends XState, TEffect> extends StatelessWidget {
  const XBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final _XBuilder<TController> builder;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TController>();
    return builder(context, controller);
  }
}
