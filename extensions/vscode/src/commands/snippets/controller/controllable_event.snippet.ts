import * as changeCase from "change-case";

export function eventSnippet(controllerName: string) {
  const pascalCaseName = changeCase.pascalCase(controllerName.toLowerCase());
  const snakeCaseName = changeCase.snakeCase(controllerName.toLowerCase());

  const event = `${pascalCaseName}Event`;

  return `part of '${snakeCaseName}_controller.dart';

abstract class ${event} extends XEvent {
  void incrementCounter();
}
`;
}
