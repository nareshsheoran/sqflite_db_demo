// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:sqflite_project_db/provider/emp_provider.dart';
import 'package:sqflite_project_db/provider/user_provider.dart';
import 'package:sqflite_project_db/shared/page/home_page.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  AppLifecycleState? appLifecycleState;

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    setState(() {
      appLifecycleState = state;
    });

    switch (state) {
      case AppLifecycleState.resumed:
        print("State of app in resumed:$appLifecycleState");
        break;
      case AppLifecycleState.inactive:
        Provider.of<EmpUserProvider>(context, listen: false).closeDb();
        Provider.of<UserProvider>(context, listen: false).closeDb();
        print("State of app in inactive:$appLifecycleState");
        break;
      case AppLifecycleState.paused:
        print("State of app in paused:$appLifecycleState");
        break;
      case AppLifecycleState.detached:
        print("State of app in detached:$appLifecycleState");
        break;
      case AppLifecycleState.hidden:
        print("State of app in detached:$appLifecycleState");
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => EmpUserProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true),
        home: const HomePage(),
      ),
    );
  }
}
