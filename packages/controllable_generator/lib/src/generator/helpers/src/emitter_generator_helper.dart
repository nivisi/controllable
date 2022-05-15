import 'package:analyzer/dart/element/element.dart';
import 'package:controllable_generator/src/generator/visitors/state_class_visitor.dart';
import 'package:dart_code_writer/dart_code_writer.dart';

import 'helper_methods.dart';

class EmitterGeneratorHelper {
  static void generate(StringBuffer buffer, ClassElement element) {
    final superType = element.supertype!;

    final controllerName = element.name;

    final stateType = superType.typeArguments.first;
    final stateVisitor = StateClassVisitor();

    stateType.element!.visitChildren(stateVisitor);

    final stateName = stateVisitor.stateName;

    const emitterInterfaceName = '_\$Emitter';
    const emitterImplClassName = '_\$EmitterImpl';

    final emitWithAbstactCall =
        DartCodeWriter.createMethod.withName('call').withReturnType('void');

    final emitWithImplCall = DartCodeWriter.createMethod
        .withName('call')
        .withReturnType('void')
        .overriding;

    final controllerField = DartCodeWriter.createField
        .withName('_controller')
        .withType(' _\$$controllerName')
        .private
        .final_;

    final emitWithClass = DartCodeWriter
        .createClass.abstract.withConstConstructor
        .withName(emitterInterfaceName)
        .withMethod(emitWithAbstactCall);

    final emitWithImplClass = DartCodeWriter.createClass.withConstConstructor
        .implements(emitterInterfaceName)
        .withName(emitterImplClassName)
        .withMethod(emitWithImplCall)
        .withField(controllerField);

    for (final e in stateVisitor.parameters.entries) {
      final name = e.key;
      final type = e.value.getDisplayString(withNullability: true);

      emitWithAbstactCall.withNamedParameter(
        name: name,
        type: type,
        forceNotRequired: true,
      );

      emitWithImplCall.withNamedParameter(
        name: name,
        type: 'Object?',
        defaultValue: unchangedObjectName,
      );
    }

    final settterLines = stateVisitor.parameters.entries.map((e) {
      final name = e.key;
      final type = e.value.getDisplayString(withNullability: true);

      return '$name: $name == $unchangedObjectName ? _controller.state.$name : $name as $type,';
    });

    emitWithImplCall
        .line('final newState = _$stateName(')
        .lines(settterLines)
        .line(');')
        .line('// ignore: invalid_use_of_protected_member')
        .line('_controller.emit(newState);');

    emitWithClass.writeTo(buffer);
    buffer.writeln();
    emitWithImplClass.writeTo(buffer);
  }
}
