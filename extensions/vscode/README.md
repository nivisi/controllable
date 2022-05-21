# controllable

A set of commands to create [controllable](https://github.com/nivisi/controllable) modules with ease.

### 💡 Pro tip

Run the following command before creating a module so controllable generates the .x file automatically:

```
flutter pub run build_runner --watch --delete-conflicting-outputs
```

### Generate module

Right click on a folder you want to create the module in and select the `Controllable: Module` option. This will generate a suggested controllable module file structure.

Let's say the name of the module is `hello_world`. Then this will be generated:

```
your_target_dir
  hello_world
    controller
      hello_world_controller.dart
      hello_world_effect.dart
      hello_world_event.dart
      hello_world_state.dart
    ui
      hello_world_body.dart
      hello_world_listener.dart
      hello_world_page.dart
```

- All the files will have the default configuration;
- If the target directory name equals to the module name, the subfolders will be created there. If not — it will create a directory with name equal to the module name.

### Generate controller

Right click on a folder you want to create the module in and select the `Controllable: Controller` option. This will create a directory `controller` and generate a set of controller files in it.

Let's say the name of the module is `hello_world`. Then this will be generated:

```
your_target_dir
  controller
    hello_world_controller.dart
    hello_world_effect.dart
    hello_world_event.dart
    hello_world_state.dart
```

- All the files will have the default configuration.