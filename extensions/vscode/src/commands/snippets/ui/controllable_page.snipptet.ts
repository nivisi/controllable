import * as changeCase from "change-case";

export function pageSnippet(controllerName: string) {
    const pascalCaseName = changeCase.pascalCase(controllerName.toLowerCase());
    const snakeCaseName = changeCase.snakeCase(controllerName.toLowerCase());

    const page = `${pascalCaseName}Page`;
    const body = `${pascalCaseName}Body`;

    return `import 'package:controllable_flutter/controllable_flutter.dart';
import 'package:flutter/material.dart';

import '../controller/${snakeCaseName}_controller.dart';
import '${snakeCaseName}_body.dart';
import '${snakeCaseName}_listener.dart';

class ${page} extends StatelessWidget {
  const ${page}({super.key});

  @override
  Widget build(BuildContext context) {
    return XProvider(
      create: (_) => ${pascalCaseName}Controller(),
      child: const Scaffold(
        body: ${pascalCaseName}Listener(
          child: ${body}(),
        ),
      ),
    );
  }
}
`;
}
