import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';

class EventMethodParam {
  final String name;
  final String type;
  final bool isNullable;

  EventMethodParam(
    this.name,
    this.type, {
    this.isNullable = false,
  });
}

class EventMethod {
  final String name;
  final String onName;
  final String signature;
  final String onSignature;
  final String returnType;
  final List<EventMethodParam> parameters;
  final String call;
  final String onCall;

  EventMethod({
    required this.name,
    required this.onName,
    required this.returnType,
    required this.parameters,
    required this.signature,
    required this.onSignature,
    required this.call,
    required this.onCall,
  });
}

class EventMethodsElementVisitor extends SimpleElementVisitor<void> {
  final eventMethods = <EventMethod>{};

  @override
  void visitMethodElement(MethodElement element) {
    super.visitMethodElement(element);

    var name = element.displayName;
    var onName = name.replaceRange(0, 1, name[0].toUpperCase());
    onName = 'on$onName';

    final doc = element.documentationComment;

    final signature = element.getDisplayString(withNullability: true);

    final onSignature = signature.replaceFirst(
      '${element.name}(',
      '$onName(',
    );

    final type = element.returnType.getDisplayString(withNullability: true);

    final both = doc == null ? signature : '$doc\n$signature';

    late final String call;
    late final String onCall;

    final paramNames = element.parameters.map((e) => e.name);
    if (paramNames.isEmpty) {
      call = '$name();';
      onCall = '$onName();';
    } else {
      call = '$name(${paramNames.join(',')});';
      onCall = '$onName(${paramNames.join(',')});';
    }

    final parameters = element.parameters.map((e) {
      final type = e.type.getDisplayString(withNullability: true);
      return EventMethodParam(
        e.name,
        type,
        isNullable: type.contains('?'),
      );
    }).toList();

    eventMethods.add(
      EventMethod(
        name: name,
        onName: onName,
        signature: both,
        onSignature: onSignature,
        call: call,
        onCall: onCall,
        returnType: type,
        parameters: parameters,
      ),
    );
  }
}
