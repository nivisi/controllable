import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/generator/controllable_generator.dart';

Builder controllableGenerator(BuilderOptions options) => PartBuilder(
      [ControllableGenerator()],
      '.x.dart',
    );
