import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_notif_app/api_key_input_page.dart';
import 'package:my_notif_app/homePage.dart';
import 'package:my_notif_app/modelAndConstants.dart';
import 'package:my_notif_app/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'local_storage_service.dart';
import 'init_notification_service.dart';

// global RouteObserver
final RouteObserver<PageRoute> routeObserver = new RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );
  await NotificationService().init();

  SharedPreferences sharedPrefs = await initSharedPreferences();

  bool isAPIKeyPresent = checkForCryptoAPIKeyInLocalStorage(sharedPrefs);
  if (isAPIKeyPresent) {
    await fetchAndSaveCryptoCoinsList();
  }
  runApp(MyApp(isAPIKeyPresent, sharedPrefs));
}

class MyApp extends StatelessWidget {
  MyApp(this.isAPIKeyPresent, this.sharedPrefs, {Key? key}) : super(key: key);

  final bool isAPIKeyPresent;
  SharedPreferences sharedPrefs;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Notifier',
      debugShowCheckedModeBanner: false,
      navigatorObservers: <NavigatorObserver>[routeObserver],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: isAPIKeyPresent ? HomePage() : ApiKeyInputPage(sharedPrefs),
    );
  }
}

void callbackDispatcher() {
  print('------------------------->>>>>>>>>>>>>>>> WorkManager called the callbackDispatcher  >>>>>>>>>>>>>>>>>');
  Workmanager().executeTask((task, inputData) async {
    //use switch case
    switch (task) {
      case Constants.NOTIFICATION_BKG_TASK:
        await triggerNotification();
        return Future.value(true);
    }
    return Future.value(true);
  });
}
