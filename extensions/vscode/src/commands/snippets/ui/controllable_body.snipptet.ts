import * as changeCase from "change-case";

export function bodySnippet(controllerName: string) {
  const pascalCaseName = changeCase.pascalCase(controllerName.toLowerCase());
  const pascalLowerCaseName = pascalCaseName[0].toLowerCase() + pascalCaseName.substring(1);
  const snakeCaseName = changeCase.snakeCase(controllerName.toLowerCase());

  const page = `${pascalCaseName}Page`;
  const body = `${pascalCaseName}Body`;

  return `import 'package:flutter/widgets.dart';
  
import '../controller/${snakeCaseName}_controller.dart';  

class ${body} extends StatelessWidget {
  const ${body}({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.${pascalLowerCaseName}Controller;

    return Text(controller.state.watch.counter.toString());
  }
}
`;
}
