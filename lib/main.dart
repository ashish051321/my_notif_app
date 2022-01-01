import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_notif_app/api_key_input_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cryptoSearchAndNotificationSettings.dart';
import 'local_storage_service.dart';
import 'notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
