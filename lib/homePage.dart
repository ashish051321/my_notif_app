import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_notif_app/local_storage_service.dart';
import 'package:my_notif_app/modelAndConstants.dart';
import 'package:my_notif_app/services/notification_service.dart';

// import 'package:my_notif_app/subscribed_coins_view.dart';
import 'cryptoSearchAndNotificationSettings.dart';
import 'crypto_backend.dart';
import 'main.dart';

// final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();
var setIntervalHandle;
class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

// Crypto Notification Summary Page
class _HomePageState extends State<HomePage> with RouteAware {
  bool isLoading = false;
  bool isNotificationON = false;

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
                    SubscribedCoinsList(key: GlobalKey(), isEditable: false),
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
                            cancelNotificationBackgroundTask();
                            setState(() {
                              isNotificationON = false;
                            });
                            return;
                          }
                          triggerBackgroundTaskforNotification();
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
