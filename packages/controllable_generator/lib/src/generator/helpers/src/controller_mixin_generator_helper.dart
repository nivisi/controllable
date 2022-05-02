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

    final emitWithMethod =
        DartCodeWriter.createMethod.withName('emitWith').protected.nonVirtual;

    for (final en in stateVisitor.parameters.entries) {
      final name = en.key;
      final type = '${en.value.getDisplayString(withNullability: false)}?';

      emitWithMethod.withNamedParameter(name: name, type: type);
    }

    final settterLines = stateVisitor.parameters.entries
        .map((e) => '${e.key}: ${e.key} ?? state.${e.key},');

    emitWithMethod
        .line('final newState = _$stateName(')
        .lines(settterLines)
        .line(');')
        .line('// ignore: invalid_use_of_visible_for_testing_member')
        .line('emit(newState);');

    final initMethod = DartCodeWriter.createMethod
        .withName('init')
        .overriding
        .mustCallSuper
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
        .withMethod(initMethod)
        .withMethod(createStateMethod)
        .withMethod(emitWithMethod);

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
