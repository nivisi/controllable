part of 'home_controller.dart';

abstract class HomeState extends XState {
  String get name;
  String? get address;
}
