import * as changeCase from "change-case";

export function controllerSnippet(controllerName: string) {
  const pascalCaseName = changeCase.pascalCase(controllerName.toLowerCase());
  const snakeCaseName = changeCase.snakeCase(controllerName.toLowerCase());

  const state = `${pascalCaseName}State`;
  const event = `${pascalCaseName}Event`;
  const effect = `${pascalCaseName}Effect`;

  return `import 'package:controllable_flutter/controllable_flutter.dart';

part '${snakeCaseName}_controller.x.dart';
part '${snakeCaseName}_effect.dart';
part '${snakeCaseName}_event.dart';
part '${snakeCaseName}_state.dart';

@XControllable<${event}>()
class ${pascalCaseName}Controller extends XController<${state}, ${effect}> with _$${pascalCaseName}Controller {
  @override
  ${state} createInitialState() {
    return create${state}(
      counter: 0,
    );
  }
}
`;
}
