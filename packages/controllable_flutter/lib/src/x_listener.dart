import 'dart:async';

import 'package:controllable/controllable.dart';
import 'package:controllable_flutter/src/helpers/x_listener_single_child_widget_mixin.dart';
import 'package:flutter/material.dart';
import 'package:provider/single_child_widget.dart';

// typedef _StreamableCreate<T> = T Function(BuildContext context);

typedef _EffectListenerCallback<TStreamable extends SideEffectStreamable> = void
    Function(
  BuildContext context,
  dynamic effect,
);

/// Allows to listen for side effects fired by controllers.
class XListener<TStreamable extends SideEffectStreamable>
    extends SingleChildStatefulWidget with XListenerSingleChildWidgetMixin {
  final TStreamable streamable;
  final _EffectListenerCallback<TStreamable> listener;

  XListener({
    Key? key,
    required this.streamable,
    required this.listener,
    Widget? child,
    WidgetBuilder? builder,
  })  : assert(
          ((child == null && builder == null) ||
                  child != null && builder == null) ||
              (child == null && builder != null),
          'Either a child or a builder must be provided, not both at the same time',
        ),
        super(
            key: key,
            child: builder != null ? Builder(builder: builder) : child);

  @override
  State<XListener> createState() => _XListenerState<TStreamable>();
}

class _XListenerState<TStreamable extends SideEffectStreamable>
    extends SingleChildState<XListener<TStreamable>> {
  late StreamSubscription _streamSubscription;

  @override
  void initState() {
    super.initState();

    _streamSubscription = widget.streamable.effectStream.listen(_onEvent);
  }

  void _updateStreamable(covariant XListener<TStreamable> oldWidget) {
    if (oldWidget.streamable != widget.streamable) {
      _streamSubscription.cancel();
      _streamSubscription = widget.streamable.effectStream.listen(_onEvent);
    }
  }

  @override
  void didUpdateWidget(covariant XListener<TStreamable> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateStreamable(oldWidget);
  }

  void _onEvent(dynamic effect) {
    if (!mounted) {
      return;
    }

    widget.listener(context, effect);
  }

  @override
  void dispose() {
    _streamSubscription.cancel();

    super.dispose();
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return child ?? const SizedBox();
  }
}
