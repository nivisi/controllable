import 'package:controllable_flutter/controllable_flutter.dart';

part 'home_controller.x.dart';
part 'home_event.dart';
part 'home_state.dart';

@XControllable<HomeEvent>()
class HomeController extends XController<HomeState, int> with _$HomeController {
  @override
  HomeState createInitialState() {
    return createHomeState(name: 'something');
  }

  @override
  void onUpdateAddress(String newAddress) {
    emitWith(address: newAddress);
  }

  @override
  void onUpdateName(String newName) {
    emitWith(name: newName);
  }

  @override
  void onUpdateCounter(int counter) {
    fireEffect(counter);
  }
}
