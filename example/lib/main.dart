import 'package:controllable_flutter/controllable_flutter.dart';
import 'package:flutter/material.dart';

import 'home_controller/home_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return XProvider(
      create: (context) => HomeController(),
      builder: (context) {
        return XListener(
          streamable: context.homeController,
          listener: (context, int effect) {
            print(effect);
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'You have pushed the button this many times:',
                  ),
                  TextButton(
                    onPressed: () {
                      _counter++;
                      context.homeController.raiseEvent.updateName(
                        _counter.toString(),
                      );
                    },
                    child: const Text('Update Name'),
                  ),
                  TextButton(
                    onPressed: () {
                      _counter++;
                      context.homeController.raiseEvent.updateAddress(
                        _counter.toString(),
                      );
                    },
                    child: const Text('Update Address'),
                  ),
                  TextButton(
                    onPressed: () {
                      _counter++;
                      context.homeController.raiseEvent.updateCounter(_counter);
                    },
                    child: const Text('Update Counter'),
                  ),
                  Builder(
                    builder: (context) {
                      final stateWatch = context.homeController.state.watch;

                      return Text(
                        'Name: ' +
                            stateWatch.name +
                            '\n' +
                            'Address: ' +
                            (stateWatch.address ?? 'No Address'),
                        style: Theme.of(context).textTheme.headline6,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
