import 'dart:async';

import 'package:meta/meta.dart';

import 'interfaces/disposable.dart';
import 'interfaces/side_effect_streamable.dart';
import 'interfaces/state_streamable.dart';

abstract class XController<TState extends XState, TEffect>
    implements
        SideEffectStreamable<TEffect>,
        StateStreamable<TState>,
        Disposable {
  late TState _state = createInitialState();

  final _stateStreamController = StreamController<TState>.broadcast();
  final _effectStreamController = StreamController<TEffect>.broadcast();

  @override
  Stream<TEffect> get effectStream => _effectStreamController.stream;

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

  /// A method that is called after the controller is initialized.
  ///
  /// Don't put too heavy logic in-here: maybe launch an initialization future
  /// or do lightweight calculations.
  @mustCallSuper
  void init() {}

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
  void fireEffect(TEffect effect) {
    _effectStreamController.add(effect);
  }

  @override
  Future<void> dispose() async {
    _stateStreamController.close();
    _effectStreamController.close();
  }
}

abstract class XState {}

abstract class XEvent {}
