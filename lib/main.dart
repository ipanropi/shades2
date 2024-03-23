import 'package:flutter/material.dart';
import 'HomeScreen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

import 'NotificationController.dart';



void main() {
AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'scheduled',
        channelName: 'Scheduled notifications',
        channelDescription: 'Scheduled notifications',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
      )
    ],
  );
  runApp(const MyApp());
}

void _requestPermissions() async {
  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowed) {
    // Show dialog or directly request permissions
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static const String name = 'Awesome Notifications - Example App';
  static const Color mainColor = Colors.deepPurple;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    // Only after at least the action method is set, the notification events are delivered
    AwesomeNotifications().setListeners(
        onActionReceivedMethod:         NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:    NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:  NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:  NotificationController.onDismissActionReceivedMethod
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: MyApp.navigatorKey,
      title: MyApp.name,
      color: MyApp.mainColor,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) =>
                const Home()
            );

          case '/notification-page':
            return MaterialPageRoute(builder: (context) => const Home());

          default:
            assert(false, 'Page ${settings.name} not found');
            return null;
        }
      },
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
      ),
    );
  }
}



