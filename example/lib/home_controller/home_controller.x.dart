// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_controller.dart';

// **************************************************************************
// ControllableGenerator
// **************************************************************************

/// Generated for [HomeController]
mixin _$HomeController on XController<HomeState, int> {
  bool _isInitialized = false;
  late final _$HomeControllerRaiseEvent raiseEvent;
  late final _$Emitter emitWith;

  @override
  @mustCallSuper
  void onProvided() {
    if (_isInitialized) {
      return;
    }

    _isInitialized = true;

    emitWith = _$EmitterImpl(this);
    raiseEvent = _$HomeControllerRaiseEvent(this);
  }

  @protected
  @nonVirtual
  HomeState createHomeState({
    required String name,
    String? address,
  }) {
    return _HomeState(
      name: name,
      address: address,
    );
  }

  void onUpdateName(String newName) {
    throw UnimplementedError('updateName is not implemented yet.');
  }

  void onUpdateAddress(String newAddress) {
    throw UnimplementedError('updateAddress is not implemented yet.');
  }

  void onUpdateCounter(int counter) {
    throw UnimplementedError('updateCounter is not implemented yet.');
  }
}

abstract class _$Emitter {
  const _$Emitter();

  void call({
    String name,
    String? address,
  });
}

class _$EmitterImpl implements _$Emitter {
  final _$HomeController _controller;

  const _$EmitterImpl(
    this._controller,
  );

  @override
  void call({
    Object? name = __unchanged,
    Object? address = __unchanged,
  }) {
    final newState = _HomeState(
      name: name == __unchanged ? _controller.state.name : name as String,
      address: address == __unchanged
          ? _controller.state.address
          : address as String?,
    );
    // ignore: invalid_use_of_protected_member
    _controller.emit(newState);
  }
}

class _HomeState implements HomeState {
  @override
  final String name;
  @override
  final String? address;

  const _HomeState({
    required this.name,
    required this.address,
  });
}

class _$HomeControllerRaiseEvent {
  final _$HomeController _controller;

  _$HomeControllerRaiseEvent(
    this._controller,
  );

  /// Calls [HomeController.onUpdateName]
  void updateName(String newName) => _controller.onUpdateName(newName);

  /// Calls [HomeController.onUpdateAddress]
  void updateAddress(String newAddress) =>
      _controller.onUpdateAddress(newAddress);

  /// Calls [HomeController.onUpdateCounter]
  void updateCounter(int counter) => _controller.onUpdateCounter(counter);
}

extension HomeControllerBuildContextExtensions on BuildContext {
  _HomeControllerBuildContext get homeController {
    final controller = read<HomeController>();

    final watch = _HomeControllerStateWatchBuildContext(this);
    final state = _HomeControllerStateBuildContext(
      controller.state,
      watch: watch,
    );

    return _HomeControllerBuildContext(controller, state);
  }
}

class _HomeControllerBuildContext implements SideEffectStreamable<int> {
  final HomeController _controller;
  final _HomeControllerStateBuildContext _state;

  _$HomeControllerRaiseEvent get raiseEvent => _controller.raiseEvent;
  _HomeControllerStateBuildContext get state => _state;
  @override
  Stream<int> get effectStream => _controller.effectStream;

  _HomeControllerBuildContext(
    this._controller,
    this._state,
  );
}

class _HomeControllerStateBuildContext {
  final HomeState _state;
  final _HomeControllerStateWatchBuildContext watch;

  String get name => _state.name;
  String? get address => _state.address;

  _HomeControllerStateBuildContext(
    this._state, {
    required this.watch,
  });
}

class _HomeControllerStateWatchBuildContext {
  final BuildContext _context;

  String get name =>
      _context.select((HomeController controller) => controller.state.name);
  String? get address =>
      _context.select((HomeController controller) => controller.state.address);

  _HomeControllerStateWatchBuildContext(
    this._context,
  );
}

/// Is used for tracking what field remained unchanged during emitting.
const __unchanged = Object();
