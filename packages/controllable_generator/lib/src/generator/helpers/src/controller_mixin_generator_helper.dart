import 'package:analyzer/dart/element/element.dart';
import 'package:controllable_generator/src/generator/visitors/event_methods_visitor.dart';
import 'package:controllable_generator/src/generator/visitors/state_class_visitor.dart';
import 'package:dart_code_writer/dart_code_writer.dart';

import 'helper_methods.dart';

class ControllerMixinGeneratorHelper {
  static void generate(
    StringBuffer buffer,
    ClassElement element, {
    required Element eventType,
  }) {
    final superType = element.supertype!;

    final controllerMixinOn =
        superType.getDisplayString(withNullability: false);

    final controllerName = element.name;

    final stateType = superType.typeArguments.first;
    final stateVisitor = StateClassVisitor();

    stateType.element!.visitChildren(stateVisitor);

    final stateName = stateVisitor.stateName;
    final raiseEventName = getRaiseEventName(controllerName);

    final eventMethodsElementVisitor = EventMethodsElementVisitor();
    eventType.visitChildren(eventMethodsElementVisitor);

    final raiseEventField = DartCodeWriter.createField
        .withName('raiseEvent')
        .withType(raiseEventName)
        .late
        .final_;

    const emitterInterfaceName = '_\$Emitter';
    const emitterImplClassName = '_\$EmitterImpl';

    final emitWithField = DartCodeWriter.createField.late.final_
        .withName('emitWith')
        .withType(emitterInterfaceName);

    final onProvidedMethod = DartCodeWriter.createMethod
        .withName('onProvided')
        .overriding
        .mustCallSuper
        .line('super.onProvided();')
        .line('')
        .line('emitWith = $emitterImplClassName(this);')
        .line('raiseEvent = $raiseEventName(this);');

    final createStateParameters =
        stateVisitor.parameters.entries.map((e) => '${e.key}: ${e.key},');

    final createStateMethod = DartCodeWriter.createMethod
        .withName('create$stateName')
        .withReturnType(stateName)
        .nonVirtual
        .protected
        .line('return _$stateName(')
        .lines(createStateParameters)
        .line(');');

    for (final stateParam in stateVisitor.parameters.entries) {
      createStateMethod.withNamedParameter(
          name: stateParam.key,
          type: stateParam.value.getDisplayString(withNullability: true));
    }

    final controllerMixin = DartCodeWriter.createMixin
        .withName('_\$$controllerName')
        .on(controllerMixinOn)
        .withField(raiseEventField)
        .withField(emitWithField)
        .withMethod(onProvidedMethod)
        .withMethod(createStateMethod);

    for (final eventMethod in eventMethodsElementVisitor.eventMethods) {
      final method = DartCodeWriter.createMethod
          .withCustomSignature(eventMethod.onSignature)
          .line(
            'throw UnimplementedError(\'${eventMethod.name} is not implemented yet.\');',
          );

      controllerMixin.withMethod(method);
    }

    buffer.writeln('/// Generated for [$controllerName]');
    controllerMixin.writeTo(buffer);
  }
}
