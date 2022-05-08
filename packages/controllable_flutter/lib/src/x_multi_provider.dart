import 'package:controllable_flutter/controllable_flutter.dart';
import 'package:controllable_flutter/src/helpers/x_provider_single_child_widget_mixin.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class XMultiProvider<TController extends XController<TState, TEffect>,
    TState extends XState, TEffect> extends MultiProvider {
  XMultiProvider({
    Key? key,
    required List<XProviderSingleChildWidgetMixin> providers,
    WidgetBuilder? builder,
    Widget? child,
  })  : assert(
          (child != null && builder == null) ||
              (child == null && builder != null),
          'Either a child or a builder must be provided, not both at the same time',
        ),
        super(
          key: key,
          providers: providers,
          child: builder != null ? Builder(builder: builder) : child,
        );
}
