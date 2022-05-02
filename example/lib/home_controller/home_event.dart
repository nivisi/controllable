part of 'home_controller.dart';

abstract class HomeEvent extends XEvent {
  void updateName(String newName);
  void updateAddress(String newAddress);
  void updateCounter(int counter);
}
