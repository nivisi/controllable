import * as changeCase from "change-case";

export function stateSnippet(controllerName: string) {
  const pascalCaseName = changeCase.pascalCase(controllerName.toLowerCase());
  const snakeCaseName = changeCase.snakeCase(controllerName.toLowerCase());

  const state = `${pascalCaseName}State`;

  return `part of '${snakeCaseName}_controller.dart';

abstract class ${state} extends XState {
  int get counter;
}
`;
}
