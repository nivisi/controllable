import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:controllable/controllable.dart';
import 'package:controllable_generator/src/generator/helpers/src/emitter_generator_helper.dart';
import 'package:controllable_generator/src/generator/helpers/src/helper_methods.dart';
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
      EmitterGeneratorHelper.generate(
        generatedBuffer,
        element,
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

      generatedBuffer.writeln(
        '/// Is used for tracking what field remained unchanged during emitting.',
      );
      generatedBuffer.writeln('const $unchangedObjectName = Object();');

      return generatedBuffer.toString();
    } catch (e, s) {
      print(e.toString());
      print(s.toString());
      rethrow;
    }
  }
}
