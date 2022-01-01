import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_notif_app/subscribed_coins_view.dart';
import 'cryptoSearchAndNotificationSettings.dart';
import 'main.dart';

// final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();
var setIntervalHandle;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  bool isLoading = false;
  bool isNotificationON = false;

  @override
  void initState() {
    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //   routeObserver.subscribe(this, MaterialPageRoute(builder: builder));
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  // Called when the top route has been popped off, and the current route shows up.
  void didPopNext() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isLoading = false;
      });
    });
    setState(() {
      isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto Notification'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SubscribedCoinsList(false),
                    ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  CryptoSearchAndNotificationSettings()));
                        },
                        icon: Icon(Icons.edit),
                        label: Text('Edit')),
                    ElevatedButton.icon(
                        onPressed: () {
                          if (isNotificationON) {
                            setIntervalHandle.cancel();
                            setState(() {
                              isNotificationON = false;
                            });
                            return;
                          }
                          setIntervalHandle =
                              Timer.periodic(Duration(seconds: 5), (timer) {
                            DateTime _now = DateTime.now();
                            _showInsistentNotification(
                                'timestamp: ${_now.hour}:${_now.minute}:${_now.second}.${_now.millisecond}');
                          });
                          setState(() {
                            isNotificationON = true;
                          });

                        },
                        icon: Icon(Icons.edit),
                        label: isNotificationON
                            ? Text('Stop Notifications')
                            : Text('Start Notifications')),
                  ],
                ),
              ),
            ),
    );
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
