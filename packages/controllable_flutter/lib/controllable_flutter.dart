/// The Flutter part of the [controllable ecosystem](https://github.com/nivisi/controllable).
/// Contains widgets that operate with controllable on the UI level.
///
/// For more details visit [GitHub](https://github.com/nivisi/controllable_flutter)
/// or [pub.dev](https://pub.dev/packages/controllable_flutter).
library controllable_flutter;

export 'package:controllable/controllable.dart';
export 'package:flutter/foundation.dart'
    show nonVirtual, protected, mustCallSuper;
export 'package:flutter/widgets.dart' show BuildContext;
export 'package:provider/provider.dart' show ReadContext, SelectContext;

export 'src/x_builder.dart';
export 'src/x_listener.dart';
export 'src/x_provider.dart';
