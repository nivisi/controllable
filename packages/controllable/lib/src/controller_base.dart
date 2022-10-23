import 'dart:async';

import 'package:interfaces/interfaces.dart';
import 'package:meta/meta.dart';

import 'interfaces/side_effect_streamable.dart';

abstract class XController<TState extends XState>
    implements SideEffectStreamable, StateStreamable<TState>, Disposable {
  late TState _state = createInitialState();

  final _stateStreamController = StreamController<TState>.broadcast();
  final _effectStreamController = StreamController.broadcast();

  bool _isProvided = false;

  @override
  Stream get effectStream => _effectStreamController.stream;

  @override
  Stream<TState> get stateStream => _stateStreamController.stream;

  /// The current state of this controller.
  @nonVirtual
  TState get state => _state;

  /// Creates the initial state when [state] is references for the first time.
  ///
  /// Code Generation will create a method `create*YourStateName*`. Use it to
  /// provide the initial state. E.g. like this:
  ///
  /// ```dart
  /// @XControllable()
  /// class MyController extends XController<MyState, MyEffect>
  ///   @override
  ///   MyState createInitialState() {
  ///     return createMyState(
  ///       /* Provide parameters if needed or required */
  ///     );
  ///   }
  /// ```
  TState createInitialState();

  /// Whether the controller was disposed (e.g. unmounted from the screen).
  ///
  /// Use this check after long-running operations to ensure that the controller
  /// can still emit new states. If [isDisposed] is `false`,
  /// the `emit` method will throw a corresponding exception.
  @override
  @nonVirtual
  bool get isDisposed => _stateStreamController.isClosed;

  /// Whether the controller has been provided.
  @nonVirtual
  bool get isProvided => _isProvided;

  /// Called after the controller was provided to the tree for the first time.
  ///
  /// final controller = MyController();
  ///
  /// ```dart
  /// XProvider(
  ///   create: (context) => controller, // onProvided is called.
  ///   child: XProvider.value(
  ///     value: controller, // onProvided is not called.
  ///     child: MyChild(),
  ///   ),
  /// )
  /// ```
  ///
  /// Use this as a callback to initialize the controller.
  /// You can launch a future to fetch initial data, emit a new state etc.
  ///
  /// But don't put too heavy synchronous logic in-here. This will freeze the app.
  /// Launching a future or doing lightweight calculations will work.
  @mustCallSuper
  void onProvided() {
    _isProvided = true;
  }

  /// Emits a new state of this controller.
  @protected
  @nonVirtual
  void emit(TState state) {
    if (isDisposed) {
      throw Exception(
        'This controller was disposed and cannot emit new states anymore,',
      );
    }

    if (_state == state) {
      return;
    }

    _state = state;
    _stateStreamController.add(state);
  }

  /// Fires a new side effect via the [effectStream].
  ///
  /// Use `XListener` to listen for side effects on the UI level:
  ///
  /// ```dart
  /// return XListener(
  ///   streamable: context.myController,,
  ///   listener: (context, MyEffect effect) {
  ///     /* Do something on the UI level */
  ///   },
  ///   child: const MyScreen(),
  /// );
  /// ```
  @protected
  @nonVirtual
  void fireEffect(effect) {
    _effectStreamController.add(effect);
  }

  @override
  @mustCallSuper
  void dispose() {
    if (isDisposed) {
      return;
    }

    _stateStreamController.close();
    _effectStreamController.close();
  }
}

abstract class XState {}

abstract class XEvent {}
