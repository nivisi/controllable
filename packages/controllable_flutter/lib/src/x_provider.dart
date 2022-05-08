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

  const XProvider({
    Key? key,
    required _ControllableCreate<TController> create,
    this.lazy = true,
    required Widget child,
  })  : _streamableValue = null,
        _streamableCreator = create,
        super(
          key: key,
          child: child,
        );

  /// Use builder if you'd like to access your controller right after it was provided.
  XProvider.builder({
    Key? key,
    required _ControllableCreate<TController> create,
    this.lazy = true,
    required WidgetBuilder builder,
  })  : _streamableValue = null,
        _streamableCreator = create,
        super(
          key: key,
          child: Builder(builder: builder),
        );

  XProvider.value({
    Key? key,
    required TController value,
    this.lazy = true,
    required Widget child,
  })  : _streamableValue = value,
        _streamableCreator = null,
        super(
          key: key,
          child: child,
        );

  /// Use builder if you'd like to access your controller right after it was provided.
  XProvider.valueBuilder({
    Key? key,
    required TController value,
    this.lazy = true,
    required WidgetBuilder builder,
  })  : _streamableValue = value,
        _streamableCreator = null,
        super(
          key: key,
          child: Builder(builder: builder),
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
