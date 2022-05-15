import 'package:analyzer/dart/element/element.dart';
import 'package:controllable_generator/src/generator/visitors/state_class_visitor.dart';
import 'package:dart_code_writer/dart_code_writer.dart';

class StateGeneratorHelper {
  static void generate(
    StringBuffer buffer,
    ClassElement element,
  ) {
    final superType = element.supertype!;

    final stateType = superType.typeArguments.first;
    final stateVisitor = StateClassVisitor();

    stateType.element!.visitChildren(stateVisitor);

    final generatedStateName = stateVisitor.generatedName;

    final fields = stateVisitor.parameters.entries.map(
      (e) => DartCodeWriter.createField
          .withName(e.key)
          .withType(e.value.toString())
          .final_
          .overriding,
    );

    final stateClass = DartCodeWriter.createClass
        .withName(generatedStateName)
        .implements(stateType.getDisplayString(withNullability: false))
        .withConstConstructor;

    for (final field in fields) {
      stateClass.withField(field);
    }

    stateClass.writeTo(buffer);
  }
}
