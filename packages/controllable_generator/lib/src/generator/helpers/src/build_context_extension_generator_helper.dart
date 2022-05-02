import 'package:analyzer/dart/element/element.dart';
import 'package:controllable_generator/src/generator/helpers/src/helper_methods.dart';
import 'package:controllable_generator/src/generator/visitors/state_class_visitor.dart';
import 'package:dart_code_writer/dart_code_writer.dart';

class BuildContextExtensionGeneratorHelper {
  static void generate(
    StringBuffer buffer,
    ClassElement element, {
    required Element sideEffect,
  }) {
    final superType = element.supertype!;

    final stateType = superType.typeArguments.first;
    final stateVisitor = StateClassVisitor();

    stateType.element!.visitChildren(stateVisitor);

    final stateName = stateVisitor.stateName;
    final controllerName = element.name;

    final controllerToLower = controllerName.replaceRange(
      0,
      1,
      controllerName[0].toLowerCase(),
    );

    final buildContextField = DartCodeWriter.createField
        .withName('context')
        .withType('BuildContext')
        .private
        .final_;

    final controllerBuildContextName = '_${controllerName}BuildContext';
    final controllerStateBuildContextName =
        '_${controllerName}StateBuildContext';
    final controllerStateWatchBuildContextName =
        '_${controllerName}StateWatchBuildContext';

    final controllerGetter = DartCodeWriter.createGetter
        .withName(controllerToLower)
        .withType(controllerBuildContextName)
        .withCustomGetLine('final controller = read<$controllerName>();')
        .withCustomGetLine('')
        .withCustomGetLine(
          'final watch = $controllerStateWatchBuildContextName(this);',
        )
        .withCustomGetLine(
          'final state = _${controllerName}StateBuildContext(controller.state, watch: watch,);',
        )
        .withCustomGetLine('')
        .withCustomGetLine(
          'return $controllerBuildContextName(controller, state);',
        );

    final newExt = DartCodeWriter.createExtension
        .withName('${controllerName}BuildContextExtensions')
        .on('BuildContext')
        .withGetter(controllerGetter);

    newExt.writeTo(buffer);

    final controllerField = DartCodeWriter.createField
        .withName('_controller')
        .withType(controllerName)
        .private
        .final_;

    final stateContextName = DartCodeWriter.createField
        .withName('_state')
        .withType(controllerStateBuildContextName)
        .private
        .final_;

    final raiseEventGetter = DartCodeWriter.createGetter
        .withName('raiseEvent')
        .withType(getRaiseEventName(controllerName))
        .returns('_controller.raiseEvent;');

    final stateGetter = DartCodeWriter.createGetter
        .withName('state')
        .withType(controllerStateBuildContextName)
        .returns('_state;');

    final effectName = sideEffect.name;

    final sideEffectStreamGetter = DartCodeWriter.createGetter
        .withName('effectStream')
        .withType('Stream<$effectName>')
        .overriding
        .returns('_controller.effectStream');

    final controllerBuildContext = DartCodeWriter.createClass
        .withName(controllerBuildContextName)
        .implements('SideEffectStreamable<$effectName>')
        .withField(controllerField)
        .withField(stateContextName)
        .withGetter(raiseEventGetter)
        .withGetter(stateGetter)
        .withGetter(sideEffectStreamGetter);

    controllerBuildContext.writeTo(buffer);

    final controllerStateField = DartCodeWriter.createField
        .withName('_state')
        .private
        .withType(stateName)
        .final_;

    final controllerStateWatchField = DartCodeWriter.createField
        .withName('watch')
        .withType(controllerStateWatchBuildContextName)
        .final_;

    final controllerStateBuildContext = DartCodeWriter.createClass
        .withName(controllerStateBuildContextName)
        .withField(controllerStateField)
        .withField(controllerStateWatchField);

    for (final param in stateVisitor.parameters.entries) {
      final stateGetter = DartCodeWriter.createGetter
          .withName(param.key)
          .withType(param.value.getDisplayString(withNullability: true))
          .returns('_state.${param.key};');

      controllerStateBuildContext.withGetter(stateGetter);
    }

    controllerStateBuildContext.writeTo(buffer);

    final controllerStateWatch = DartCodeWriter.createClass
        .withName(controllerStateWatchBuildContextName)
        .withField(buildContextField);

    for (final param in stateVisitor.parameters.entries) {
      final watchGetter = DartCodeWriter.createGetter
          .withName(param.key)
          .withType(param.value.getDisplayString(withNullability: true))
          .returns(
            '_context.select(($controllerName controller) => controller.state.${param.key});',
          );

      controllerStateWatch.withGetter(watchGetter);
    }

    controllerStateWatch.writeTo(buffer);
  }
}
