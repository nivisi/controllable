import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:controllable/controllable.dart';
import 'package:source_gen/source_gen.dart';

import 'helpers/generator_helpers.dart';

class ControllableGenerator extends GeneratorForAnnotation<XControllable> {
  @override
  dynamic generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    // Hack to extract event type argument of the annotation
    final eventType =
        (annotation.objectValue.type as dynamic).typeArguments.first.element;

    try {
      if (element is! ClassElement) {
        throw Exception();
      }

      final superType = element.supertype;

      if (superType == null) {
        throw Exception();
      }

      final generatedBuffer = StringBuffer();

      ControllerMixinGeneratorHelper.generate(
        generatedBuffer,
        element,
        eventType: eventType,
      );
      StateGeneratorHelper.generate(generatedBuffer, element);
      RaiseEventGeneratorHelper.generate(
        generatedBuffer,
        element,
        eventType: eventType,
      );
      BuildContextExtensionGeneratorHelper.generate(
        generatedBuffer,
        element,
        sideEffect: element.supertype!.typeArguments.last.element!,
      );

      return generatedBuffer.toString();
    } catch (e, s) {
      print(e.toString());
      print(s.toString());
      rethrow;
    }
  }
}
