import 'package:controllable/controllable.dart';
import 'package:controllable_flutter/src/helpers/x_provider_single_child_widget_mixin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

typedef _ControllableCreate<T> = T Function(BuildContext context);

class XProvider<TController extends XController<TState, TEffect>,
        TState extends XState, TEffect> extends SingleChildStatelessWidget
    with XProviderSingleChildWidgetMixin {
  final TController? _streamableValue;
  final _ControllableCreate<TController>? _streamableCreator;

  /// Whether to initialize the controller only after it is accessed for the first time (read/watched).
  final bool lazy;

  /// Use builder if you'd like to access your controller right after it was provided.
  XProvider({
    Key? key,
    required _ControllableCreate<TController> create,
    this.lazy = true,
    WidgetBuilder? builder,
    Widget? child,
  })  : assert(
          (child != null && builder == null) ||
              (child == null && builder != null),
          'Either a child or a builder must be provided, not both at the same time',
        ),
        _streamableValue = null,
        _streamableCreator = create,
        super(
          key: key,
          child: builder != null ? Builder(builder: builder) : child,
        );

  /// Use builder if you'd like to access your controller right after it was provided.
  XProvider.value({
    Key? key,
    required TController value,
    this.lazy = true,
    WidgetBuilder? builder,
    Widget? child,
  })  : assert(
          (child != null && builder == null) ||
              (child == null && builder != null),
          'Either a child or a builder must be provided, not both at the same time',
        ),
        _streamableValue = value,
        _streamableCreator = null,
        super(
          key: key,
          child: builder != null ? Builder(builder: builder) : child,
        );

  VoidCallback _startListening(
    BuildContext context,
    InheritedContext<TController?> element,
    TController controller,
  ) {
    controller.init();

    final stateSubscription = controller.stateStream.listen(
      (dynamic _) => element.markNeedsNotifyDependents(),
    );

    return stateSubscription.cancel;
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
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
