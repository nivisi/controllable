## 0.0.6

Don't generate `isInitilized` property (revert of 0.0.5) but use `isProvided` property of the core package instead.

## 0.0.5

`onProvided` is now called only once when the controller is provided for the very first time.

## 0.0.4

Allow to use `emitWith` with nulls. Previously, using a null meant «do not change this variable». Now, using a null actually means «use this null».

```dart
@override
void onIncrementCounter() {
    // state.counter == 10032000 now.
    emitWith(counter: 10032000);

    // Previously this would not change the value.
    emitWith(counter: null);

    // Now this line would not even compile if counter is not nullable!
    // And if it is nullable, a new state with counter == null will be emitted.
    emitWith(counter: null);
}
```

## 0.0.3

Allow to use named parameters in events.

## 0.0.2

Use `.x.dart` extension for generated files.

## 0.0.1

Initial release.