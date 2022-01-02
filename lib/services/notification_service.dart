import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

import '../crypto_backend.dart';
import '../local_storage_service.dart';
import '../modelAndConstants.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

triggerBackgroundTaskforNotification() {
  // Periodic task registration
  Workmanager().registerPeriodicTask("1", "simplePeriodicTask",
      // When no frequency is provided the default 15 minutes is set.
      // Minimum frequency is 15 min. Android will automatically change your frequency to 15 min if you have configured a lower frequency.
      frequency: Duration(minutes: 15),
      tag: Constants.NOTIFICATION_BKG_TASK_TAG);
}

cancelNotificationBackgroundTask(){
  Workmanager().cancelByTag(Constants.NOTIFICATION_BKG_TASK_TAG);
}



triggerNotification() async {
  List<CryptoInfo> listofCrypto = await getListOfSubscribedCoins();
  listofCrypto = await fetchCoinDetails(
      listofCrypto.map((item) => item.symbol.trim()).join(","));
  if (listofCrypto.isNotEmpty) {
    String message = listofCrypto
        .map((item) =>
            '${item.symbol} : ${double.parse(item.price.toStringAsFixed(2))}')
        .toList()
        .toString();
    _showNotification(message);
  }
}

Future<void> _showProgressNotification() async {
  const int maxProgress = 5;
  for (int i = 0; i <= maxProgress; i++) {
    await Future<void>.delayed(const Duration(seconds: 1), () async {
      final AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails('progress channel', 'progress channel',
              channelDescription: 'progress channel description',
              channelShowBadge: false,
              importance: Importance.max,
              priority: Priority.high,
              onlyAlertOnce: true,
              showProgress: true,
              maxProgress: maxProgress,
              progress: i);
      final NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          0, 'Crypto Prices', '', platformChannelSpecifics,
          payload: 'item x');
    });
  }
}

Future<void> _showInsistentNotification(String message) async {
  // This value is from: https://developer.android.com/reference/android/app/Notification.html#FLAG_INSISTENT
  const int insistentFlag = 4;
  final AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('your channel id', 'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
          additionalFlags: Int32List.fromList(<int>[insistentFlag]));
  final NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, 'Crypto Notifications', message, platformChannelSpecifics,
      payload: 'item x');
}

Future<void> _showNotification(String message) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'channel1',
    'channel1',
    channelDescription: 'channel1',
    importance: Importance.max,
    priority: Priority.high,
    enableVibration: false,
    playSound: false,
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, 'Crypto Price Alert (INR)', message, platformChannelSpecifics,
      payload: 'item x');
}
