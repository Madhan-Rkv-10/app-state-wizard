import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Flutter code sample for [AppLifecycleListener].

void main() {
  runApp(const AppLifecycleListenerExample());
}

class AppLifecycleListenerExample extends StatelessWidget {
  const AppLifecycleListenerExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: AppLifecycleDisplay()),
    );
  }
}

class AppLifecycleDisplay extends StatefulWidget {
  const AppLifecycleDisplay({super.key});

  @override
  State<AppLifecycleDisplay> createState() => _AppLifecycleDisplayState();
}

class _AppLifecycleDisplayState extends State<AppLifecycleDisplay> {
  late final AppLifecycleListener _listener;
  final List<String> _states = <String>[];
  late AppLifecycleState? _state;

  @override
  void initState() {
    super.initState();
    _state = SchedulerBinding.instance.lifecycleState;
    _listener = AppLifecycleListener(
      onShow: () => _handleTransition('show'),
      onResume: () => _handleTransition('resume'),
      onHide: () => _handleTransition('hide'),
      onInactive: () => _handleTransition('inactive'),
      onPause: () => _handleTransition('pause'),
      onDetach: () => _handleTransition('detach'),
      onRestart: () => _handleTransition('restart'),
      // This fires for each state change. Callbacks above fire only for
      // specific state transitions.
      onStateChange: _handleStateChange,
    );
    if (_state != null) {
      _states.add(_state!.name);
    }
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  void _handleTransition(String name) {
    log(name, name: "LIFE CYCLE");
    setState(() {
      _states.add(name);
    });
    // _scrollController.animateTo(
    //   _scrollController.position.maxScrollExtent,
    //   duration: const Duration(milliseconds: 200),
    //   curve: Curves.easeOut,
    // );
  }

  void _handleStateChange(AppLifecycleState state) {
    setState(() {
      _state = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              switch (_state) {
                AppLifecycleState.inactive =>
                  const Text("APP LIFE CYCLE IS INACTIVE"),
                AppLifecycleState.detached =>
                  const Text("APP LIFE CYCLE IS DETACHED"),
                AppLifecycleState.resumed =>
                  const Text("APP LIFE CYCLE IS RESUMED"),
                AppLifecycleState.hidden =>
                  const Text("APP LIFE CYCLE IS HIDDEN"),
                AppLifecycleState.paused =>
                  const Text("APP LIFE CYCLE IS PAUSED"),
                null => const Text("NORMAL SCREEn"),
              }
            ],
          ),
        ),
      ),
      if (AppLifecycleState.inactive == _state)
        const Scaffold(
          backgroundColor: Colors.red,
          body: SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("HIDDEN"),
              ],
            ),
          ),
        )
    ]);
  }
}
