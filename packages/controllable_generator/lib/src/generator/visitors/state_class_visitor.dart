import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor.dart';

class StateClassVisitor extends SimpleElementVisitor<void> {
  final parameters = <String, DartType>{};
  late final String stateName;
  late final String generatedName;

  @override
  void visitPropertyAccessorElement(PropertyAccessorElement element) {
    parameters[element.name] = element.returnType;
  }

  @override
  void visitConstructorElement(ConstructorElement element) {
    if (!element.isDefaultConstructor) {
      throw Exception('You cannot provide a custom constructor for the state');
    }

    stateName = element.displayName;
    generatedName = '_${element.displayName}';
  }
}
