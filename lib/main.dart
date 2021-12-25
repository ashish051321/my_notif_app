import 'dart:async';

import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:my_notif_app/api_key_input_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cryptoSearchAndNotificationSettings.dart';
import 'local_storage_service.dart';

void main() async {
  // bool isCryptoApiKeyAvailable = await checkForCryptoAPIKeyInLocalStorage();
  // print('is crypto api key available : ${isCryptoApiKeyAvailable}');
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPrefs = await initSharedPreferences();

  bool isAPIKeyPresent = checkForCryptoAPIKeyInLocalStorage(sharedPrefs);
  if(isAPIKeyPresent){
    await fetchAndSaveCryptoCoinsList();
  }
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      'resource://drawable/app_icon',
      [
        NotificationChannel(
            playSound: false,
            enableVibration: false,
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white),
      ]);
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      // This is just a basic example. For real apps, you must show some
      // friendly dialog box before call the request method.
      // This is very important to not harm the user experience
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: isAPIKeyPresent
          ? CryptoSearchAndNotificationSettings()
          : ApiKeyInputPage(sharedPrefs),
    );
  }
}
