import 'package:meta/meta_meta.dart';

/// ## Annotation for XController classes.
///
/// Put this annotation above your controllers so the generator can do its job.
///
/// ----
///
/// ### What is this?
///
/// [TEvent] is the event type where you specify method events for your controller.
/// It is optional, if [TEvent] will not be specified, then nothing will be generated.
///
/// ### Example
///
/// Create your event like so:
///
/// ```dart
/// abstract class MyEvent {
///   void nameChanged(String newName);
///   void somethingElseHappened(DataClass data);
/// }
/// ```
///
/// Annotate your controller:
///
/// ```dart
/// @XControllable<MyEvent>
/// class MyController extends XController<MyState, MyEffect> {
///   ...
/// }
/// ```
///
/// And run the build runner.
///
/// Now, on the UI level, you can raise these events this way:
///
/// ```dart
/// context.myController.raiseEvent.nameChanged('Some name');
/// context.myController.raiseEvent.somethingElseHappened('Some name');
/// ```
///
/// Remember❗️
///
/// Until you override these events in your controller,
/// they will throw an [UnimplementedError] when called.
/// To override them, do the following:
///
/// ```dart
/// @XControllable<MyEvent>
/// class MyController extends XController<MyState, MyEffect> {
///   ...
///
///   @override
///   void onNameChanged(String newName) { // note: it is not nameChanged, but onNameChanged
///     emitWith(name: newName); // or whatever
///   }
///
///   @override
///   void onSomethingElseHappened(DataClass data) {
///     /* Do something with this ... */
///   }
/// }
///
/// ```

@Target({TargetKind.classType})
class XControllable<TEvent> {
  const XControllable();
}
