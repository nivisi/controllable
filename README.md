# controllable

Home repository for the controllable ecosystem.

Easy and convenient state management. Set your business logic apart from the UI level.

⚠️ _This is an alpha version. The documentation is not finished and will be extended and updated later on._

---

| Package | pub.dev |
| ------- | ------- |
| [controllable](https://github.com/nivisi/controllable/tree/develop/packages/controllable) | [![controllable pub version][controllable-pub-version-img]][controllable-pub-version-url] |
| [controllable_flutter](https://github.com/nivisi/controllable/tree/develop/packages/controllable_flutter) | [![controllable flutter pub version][controllable-flutter-pub-version-img]][controllable-flutter-pub-version-url] |
| [controllable_generator](https://github.com/nivisi/controllable/tree/develop/packages/controllable_generator) | [![controllable generator pub version][controllable-generator-pub-version-img]][controllable-generator-pub-version-url] |

### Quick overview

#### Emit updates for your state

```dart
@override
void onUpdateName(String newName) {
  emitWith(name: newName);
}
```

#### Read your state

```dart
Text(context.myController.state.name);
```

#### Watch for your state changes

```dart
Text(context.myController.state.watch.name);
```

#### Raise events

```dart
TextButton(
  onPressed: () => context.myController.raiseEvent.updateName('New name'),
  child: Text('Raise update name event'),
);
```

#### And more

For more details, see below.

---

### Table of contents

- [Example](https://github.com/nivisi/controllable#example)
  - [Setup](https://github.com/nivisi/controllable#setup)
    - [State](https://github.com/nivisi/controllable#state)
    - [Event](https://github.com/nivisi/controllable#event)
    - [Now you can declare your controller class](https://github.com/nivisi/controllable#now-you-can-declare-your-controller-class)
    - [Run the build runner](https://github.com/nivisi/controllable#run-the-build-runner)
  - [Usage](https://github.com/nivisi/controllable#usage)
    - [Fill your controller](https://github.com/nivisi/controllable#fill-your-controller)
    - [UI](https://github.com/nivisi/controllable#ui)
    - [Listen for side effects](https://github.com/nivisi/controllable#listen-for-side-effect)
- [How to](https://github.com/nivisi/controllable#how-to)
  - [Emit new states](https://github.com/nivisi/controllable#emit-new-states)
  - [Watch or read the state](https://github.com/nivisi/controllable#watch-or-read-the-state)
  - [Raise events](https://github.com/nivisi/controllable#raise-events)
  - [Fire side effects](https://github.com/nivisi/controllable#fire-side-effects)
  - [Listen for side effects](https://github.com/nivisi/controllable#listen-for-side-effects)
- [Best practices](https://github.com/nivisi/controllable#best-practices)
  - [Use the generated interface](https://github.com/nivisi/controllable#use-the-generated-interface)
- [How it all works?](https://github.com/nivisi/controllable#how-it-all-works)
  - [Yes, code generation. But let me explain](https://github.com/nivisi/controllable#yes-code-generation-but-let-me-explain)

## Example

### Setup

Add packages to pubspec.yaml:

```
dependencies:
  controllable_flutter:
  
dev_dependencies:
  build_runner:
  controllable_generator:
```

At first, declare your `State` and `Event` classes. And, optionally, a side effect class. For simplicity we'll use an `int` as a side effect.

#### State

Put the required data fields of your state as getters. These will be accessible on the UI and the controller level.

```dart
part of 'home_controller.dart';

abstract class HomeState extends XState {
  String get name;
  String? get address;
}
```

Describe what events can the UI trigger as methods. These will be used by the UI to trigger controller actions.

#### Event

```dart
part of 'home_controller.dart';

abstract class HomeEvent extends XEvent {
  void updateName(String newName);
  void updateAddress(String newAddress);
  void updateCounter(int counter);
}
```

#### Now you can declare your controller class
```dart
/* imports */

part 'home_controller.x.dart';
part 'home_event.dart';
part 'home_state.dart';

@XControllable<HomeEvent>()
class HomeController extends XController<HomeState, int> with _$HomeController {
  @override
  HomeState createInitialState() {
    // We will fill it later on.
  }
}

```

#### Run the build runner

```
flutter pub run build_runner build
```

### Usage

#### Fill your controller

A file with settings and extensions for your controller was generated. You can now fill details of your controller:

```dart
@XControllable<HomeEvent>()
class HomeController extends XController<HomeState, int> with _$HomeController {
  @override
  HomeState createInitialState() {
    // Use the method below to create the initial state of your controller.
    // The parameters are the same as you declared in the HomeState class.
    return createHomeState(name: 'something');
  }

  // Methods below are called events. These will be raised from the UI level.
  // They are generated based on the HomeEvent class.
  // Notice, the updateName method became onUpdateName and so on.

  @override
  void onUpdateAddress(String newAddress) {
    // Use emitWith to deliver a new state with updated fields to your UI.
    emitWith(address: newAddress);
  }

  @override
  void onUpdateName(String newName) {
    emitWith(name: newName);
  }

  @override
  void onUpdateCounter(int counter) {
    // Use fireEffect to make the UI react on it navigating to another page, showing a snackbar etc
    fireEffect(counter);
  }
}
```

#### UI

Provide `HomeController`:

```dart
return XProvider(
  create: (context) => HomeController(),
  child: const HomeBody(),
);
```

In `HomeBody`, access the fields:

```dart
return Column(
  children: [
    Text(context.homeController.state.watch.name),
    Text(context.homeController.state.watch.address),
    TextButton(
      // The onUpdateName method of the controller will be called here.
      onPressed: () => context.homeController.raiseEvent.updateName('New Name'),
      child: Text('Set name to "New Name"'),
    ),
  ],
);
```

The `watch` statement will make the widget of the given `BuildContext` to rebuild whenever the corresponding field changes. So, in the example above, whenever you do either `emitWith(name: any);` or `emitWith(address: any);`, the tree will get rebuilt. But we want to avoid unnecesseary rebuilds, right? Move the texts to separate widgets then! Or wrap them with builders:

```dart
return Column(
  children: [
    Builder(
      // This will be rebuilt only when name changes 
      // Because this `context` now is only related to this part of the tree!
      builder: (context) => Text(context.homeController.state.watch.name)
    ),
    Builder(
      // This will be rebuilt only when address changes
      // Because this `context` now is only related to this part of the tree!
      builder: (context) => Text(context.homeController.state.watch.address)
    ),
    // This button will not get rebuilt when neither name or address changes
    TextButton(
      onPressed: () => context.homeController.raiseEvent.updateName('New Name'),
      child: Text('Set name to "New Name"'),
    ),
  ],
);
```

If you want to simply read a field w/o watching for it, just access it w/o watch:

```dart
onPressed: () => print(context.homeController.state.name),
```

## How to

### Emit new states

In your controller, use the `emitWith` to deliver a new state to your UI. Call `emitWith(yourField: newValue)` to update `yourField`.

### Watch or read the state

Use `context.controller.state.watch.*` for listening for state field updates.

Use `context.controller.state.*` for simply reading the state fields.

### Raise events

To make the controller to perform certain business logic, on the UI level do `context.yourController.raiseEvent.yourEvent`. This will execute the corresponding method in your controller.

### Fire side effects

Side effects are needed to perform UI actions. Navigation to another screen, showing a dialog or a toast, validating a form field ect. — this is what side effects are for.

### Listen for side effects

Remember that side effect of type `int` of `HomeController`? Use the `XListener` widget to listen for it!

```dart
XListener(
  streamable: context.homeController,
  listener: (context, int effect) {
    // Do whatever is required on the UI level.
    print(effect); // or just print the effect...
  },
  child: const SomeWidget(),
);
```

## Best practices

They are yet to determine! :) But the first one is:

### Use the generated interface

Access the state and the events only via the `context.controller.state` / `context.controller.raiseEvent`. Still, you can get your controller via the `Provider`'s `context.read<YourController>()` or other methods. But it is recommended to use only the `BuildContext` extensions for that.

On your UI level the interface of your controller has only three fields: `state`, `raiseEvent` and `effectSteam`. Though the latter is only for `XListener` widgets. So use:
- `state` for reading/watching values and rendering the UI;
- `raiseEvent` for triggering actions in the controller.

## How it all works?

It is all possible with the power of mixins and extensions.

_TODO: Describe it._

### Yes, code generation. But let me explain

Controllable generates code uniquely for your controllers so you can avoid writing boilerplate code. Also, it creates an interface for public methods that the UI should use and state fields that the UI should render.

<!--References-->
[controllable-pub-version-img]: https://img.shields.io/badge/pub-v0.0.3-green
[controllable-pub-version-url]: https://pub.dev/packages/controllable

[controllable-flutter-pub-version-img]: https://img.shields.io/badge/pub-v0.0.4-green
[controllable-flutter-pub-version-url]: https://pub.dev/packages/controllable_flutter

[controllable-generator-pub-version-img]: https://img.shields.io/badge/pub-v0.0.7-green
[controllable-generator-pub-version-url]: https://pub.dev/packages/controllable_generator
