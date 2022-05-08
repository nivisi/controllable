import 'package:controllable_flutter/src/helpers/x_listener_single_child_widget_mixin.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class XMultiListener extends MultiProvider {
  XMultiListener({
    Key? key,
    required List<XListenerSingleChildWidgetMixin> listeners,
    required Widget child,
  }) : super(key: key, providers: listeners, child: child);
}
