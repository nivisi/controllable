import * as changeCase from "change-case";

export function listenerSnippet(controllerName: string) {
  const pascalCaseName = changeCase.pascalCase(controllerName.toLowerCase());
  const pascalLowerCaseName = pascalCaseName[0].toLowerCase() + pascalCaseName.substring(1);
  const snakeCaseName = changeCase.snakeCase(controllerName.toLowerCase());

  const listener = `${pascalCaseName}Listener`;
  const effect = `${pascalCaseName}Effect`;

  return `import 'package:controllable_flutter/controllable_flutter.dart';
import 'package:flutter/widgets.dart';
  
import '../controller/${snakeCaseName}_controller.dart';
  

class ${listener} extends StatelessWidget {
  const ${listener}({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final controller = context.${pascalLowerCaseName}Controller;

    return XListener(
      streamable: controller,
      listener: (context, ${effect} effect) {
        // TODO: Implement listener.
      },
      child: child,
    );
  }
}
`;
}
