import * as changeCase from "change-case";

export function effectSnippet(controllerName: string) {
  const pascalCaseName = changeCase.pascalCase(controllerName.toLowerCase());
  const snakeCaseName = changeCase.snakeCase(controllerName.toLowerCase());

  const effect = `${pascalCaseName}Effect`;

  return `part of '${snakeCaseName}_controller.dart';

enum ${effect} {
  counterIncremented,
}
`;
}
