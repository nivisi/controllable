// import 'package:analyzer/dart/element/element.dart';
// import 'package:analyzer/dart/element/type.dart';
// import 'package:analyzer/dart/element/visitor.dart';

// class ConstructorsParameterVisitor extends SimpleElementVisitor<void> {
//   final parameters = <String, DartType>{};
//   late String constructorName;
//   late String stateName;

//   ConstructorElement? _firstFactory;

//   @override
//   void visitConstructorElement(ConstructorElement element) {
//     super.visitConstructorElement(element);

//     if (!element.isFactory) {
//       return;
//     }

//     if (_firstFactory != null) {
//       throw Exception('The state must have only one factory');
//     }

//     _firstFactory = element;

//     constructorName = element.name;
//     stateName = element.displayName.split('.')[0];
//     constructorName = constructorName.replaceFirst(
//         constructorName[0], constructorName[0].toUpperCase());

//     for (final param in element.parameters) {
//       final name = param.name;
//       final type = param.type;

//       parameters.addAll({name: type});
//     }
//   }
// }
