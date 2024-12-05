import 'package:flutter/material.dart';
import 'package:sahha_flutter/sahha_flutter.dart';
import 'package:sahha_flutter_example/Views/ScoresView.dart';
import 'package:sahha_flutter_example/Views/AuthenticationView.dart';
import 'package:sahha_flutter_example/Views/HomeView.dart';
import 'package:sahha_flutter_example/Views/ProfileView.dart';
import 'package:sahha_flutter_example/Views/WebView.dart';
import 'package:sahha_flutter_example/Views/SensorPermissionView.dart';
import 'package:sahha_flutter_example/Views/appview/mainchatbot.dart';
import 'package:sahha_flutter_example/Views/appview/onboardingview.dart';

void main() {
  runApp(const TestApp());
}

class TestApp extends StatefulWidget {
  const TestApp({super.key});

  @override
  State<TestApp> createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: 
    // ModernChatbotView()
    Onboardingview(),
    
    );
  }
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => AppState();
}



class AppState extends State<App> {
  @override
  void initState() {
    super.initState();

    // Use default values
    SahhaFlutter.configure(
      environment: SahhaEnvironment.sandbox,
    )
        .then((success) => {debugPrint(success.toString())})
        .catchError((error, stackTrace) => {debugPrint(error.toString())});

/*
    // Android only
    var notificationSettings = {
      'icon': 'Custom Icon',
      'title': 'Custom Title',
      'shortDescription': 'Custom Description'
    };

    // Use custom values
    SahhaFlutter.configure(
            environment: SahhaEnvironment.production,
            sensors: [SahhaSensor.device],
            notificationSettings: notificationSettings)
        .then((success) => {debugPrint(success.toString())})
        .catchError((error, stackTrace) => {debugPrint(error.toString())});
        */
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',home: Onboardingview(),
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => const HomeView(),
        '/authentication': (BuildContext context) => const AuthenticationView(),
        '/profile': (BuildContext context) => const ProfileView(),
        '/permissions': (BuildContext context) => const SensorPermissionView(),
        '/scores': (BuildContext context) => const ScoresView(),
        '/web': (BuildContext context) => const WebView(),
      },
    );
  }
}
