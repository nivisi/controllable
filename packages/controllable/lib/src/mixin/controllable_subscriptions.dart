import 'dart:async';

import 'package:controllable/controllable.dart';
import 'package:meta/meta.dart';

/// A mixin for XControllers that helps to control stream subscriptions.
///
/// The subscriptions that you will subscribe to
/// will be automatically cancelled when the controller is disposed.
///
/// ---
///
/// Attach it to your controller:
///
/// ```dart
/// class MyController extends XController<MyState> with ControllableSubscriptions {
///   ...
/// }
/// ```
///
/// Now use it in, for example, `onProvided` method:
/// ```dart
///     @override
///     void onProvided() {
///       super.onProvided();
///
///       subscribeTo(stream.listen.onStream);
///         subscribeToAll([
///           stream1.listen.onStream1,
///           stream2.listen.onStream2,
///         ]);
///     }
/// }
/// ```
mixin ControllableSubscriptions<T extends XState> on XController<T> {
  final List<StreamSubscription> _subscriptions = [];

  /// Subscribes to the given subscription to cancel it on [dispose].
  @protected
  void subscribeTo(StreamSubscription subscription) {
    _subscriptions.add(subscription);
  }

  /// Subscribes to the list of given subscriptions to cancel them on [dispose].
  @protected
  void subscribeToAll(Iterable<StreamSubscription> subscriptions) {
    _subscriptions.addAll(subscriptions);
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }

    _subscriptions.clear();

    super.dispose();
  }
}
