import 'package:analyzer/dart/element/element.dart';
import 'package:controllable_generator/src/generator/visitors/event_methods_visitor.dart';
import 'package:dart_code_writer/dart_code_writer.dart';

class RaiseEventGeneratorHelper {
  static void generate(
    StringBuffer buffer,
    ClassElement element, {
    required Element eventType,
  }) {
    final controllerName = element.name;
    final eventMethodsElementVisitor = EventMethodsElementVisitor();
    eventType.visitChildren(eventMethodsElementVisitor);

    final controllerField = DartCodeWriter.createField
        .withName('_controller')
        .withType(' _\$$controllerName')
        .private
        .final_;

    final raiseEventClass = DartCodeWriter.createClass
        .withName('_\$${controllerName}RaiseEvent')
        .withField(controllerField);

    for (final eventMethod in eventMethodsElementVisitor.eventMethods) {
      final signature = eventMethod.signature;
      final call = eventMethod.onCall;

      final method = DartCodeWriter.createMethod
          .withCustomSignature(
              '/// Calls [$controllerName.${eventMethod.onName}]\n$signature')
          .withOneLineCall('_controller.$call');

      raiseEventClass.withMethod(method);
    }

    raiseEventClass.writeTo(buffer);
  }
}
