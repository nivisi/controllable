import 'dart:async';

import 'package:controllable/controllable.dart';
import 'package:flutter/material.dart';

// typedef _StreamableCreate<T> = T Function(BuildContext context);

typedef _EffectListenerCallback<
        TStreamable extends SideEffectStreamable<TEffect>, TEffect>
    = void Function(
  BuildContext context,
  TEffect effect,
);

/// Allows to listen for side effects fired by controllers.
class XListener<TStreamable extends SideEffectStreamable<TEffect>, TEffect>
    extends StatefulWidget {
  final TStreamable streamable;
  final _EffectListenerCallback<TStreamable, TEffect> listener;
  final Widget? child;
  final WidgetBuilder? builder;

  const XListener({
    Key? key,
    required this.streamable,
    required this.listener,
    this.child,
    this.builder,
  })  : assert(
          (child != null && builder == null) ||
              (child == null && builder != null),
          'Either a child or a builder must be provided, not both at the same time',
        ),
        super(key: key);

  @override
  State<XListener> createState() => _XListenerState<TStreamable, TEffect>();
}

class _XListenerState<TStreamable extends SideEffectStreamable<TEffect>,
    TEffect> extends State<XListener<TStreamable, TEffect>> {
  late StreamSubscription _streamSubscription;

  @override
  void initState() {
    super.initState();

    _streamSubscription = widget.streamable.effectStream.listen(_onEvent);
  }

  void _updateStreamable(covariant XListener<TStreamable, TEffect> oldWidget) {
    if (oldWidget.streamable != widget.streamable) {
      _streamSubscription.cancel();
      _streamSubscription = widget.streamable.effectStream.listen(_onEvent);
    }
  }

  @override
  void didUpdateWidget(covariant XListener<TStreamable, TEffect> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateStreamable(oldWidget);
  }

  void _onEvent(TEffect effect) {
    if (!mounted) {
      return;
    }

    widget.listener(context, effect);
  }

  @override
  void dispose() {
    super.dispose();

    _streamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder != null ? widget.builder!(context) : widget.child!;
  }
}
