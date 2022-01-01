import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_notif_app/homePage.dart';
import 'package:my_notif_app/local_storage_service.dart';
import 'package:my_notif_app/subscribed_coins_view.dart';

import 'crypto_backend.dart';
import 'modelAndConstants.dart';

class CryptoSearchAndNotificationSettings extends StatefulWidget {
  const CryptoSearchAndNotificationSettings({Key? key}) : super(key: key);

  @override
  _CryptoSearchAndNotificationSettingsState createState() =>
      _CryptoSearchAndNotificationSettingsState();
}

class _CryptoSearchAndNotificationSettingsState
    extends State<CryptoSearchAndNotificationSettings> {
  final GlobalKey<dynamic> _cryptoListingWidgetKey = GlobalKey();
  bool isLoading = false;
  late List<CryptoInfo> cryptoInfoList;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isLoading = true;
    });
    () async {
      List<CryptoInfo> response = await fetchAndSaveCryptoCoinsList();
      setState(() {
        cryptoInfoList = response;
        isLoading = false;
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? LinearProgressIndicator()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Setup Notification for Crypto Coins'),
            ),
            body: isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Autocomplete(
                            optionsBuilder: (TextEditingValue searchStringVal) {
                              if (searchStringVal.text.isEmpty) {
                                return const Iterable<String>.empty();
                              } else {
                                return cryptoInfoList
                                    .where((CryptoInfo item) =>
                                        item.name.toLowerCase().contains(
                                            searchStringVal.text
                                                .toLowerCase()) ||
                                        item.symbol.toLowerCase().contains(
                                            searchStringVal.text.toLowerCase()))
                                    .map((e) => '${e.name} : ${e.symbol}');
                              }
                            },
                            fieldViewBuilder: (context, textEditingController,
                                focusNode, onFieldSubmitted) {
                              return TextField(
                                controller: textEditingController,
                                focusNode: focusNode,
                                onEditingComplete: onFieldSubmitted,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: Colors.grey[300]!)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: Colors.grey[300]!)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: Colors.grey[300]!)),
                                  hintText: "Search Crypto Coin",
                                  prefixIcon: Icon(Icons.search),
                                ),
                              );
                            },
                            onSelected: (option) {
                              _cryptoListingWidgetKey.currentState
                                  ?.setState(() {
                                _cryptoListingWidgetKey
                                    .currentState?.listOfSubscribedCoins
                                    .add(CryptoInfo(
                                        option.toString().split(":")[0],
                                        option.toString().split(":")[1],
                                        "INR"));
                              });
                              storeListOfSubscribedCoins(_cryptoListingWidgetKey
                                  .currentState?.listOfSubscribedCoins);
                            },
                          ),
                          SubscribedCoinsList(true,
                              key: _cryptoListingWidgetKey),
                          // ElevatedButton.icon(
                          //     onPressed: () {
                          //       // storeCryptoList(_cryptoListingWidgetKey
                          //       //     .currentState?.listOfSubscribedCoins);
                          //       // await _showInsistentNotification();
                          //       // _showProgressNotification();
                          //       Navigator.of(context)
                          //           .push(MaterialPageRoute(
                          //               builder: (context) => HomePage()))
                          //           .then((value) => setState(() {this.isLoading=true; this.isLoading=false;}));
                          //       ;
                          //     },
                          //     icon: Icon(Icons.save),
                          //     label: Text('Done')),
                        ],
                      ),
                    ),
                  ),
          );
  }

  getAllCoinInfo() async {
    dynamic allCoins = await fetchAllCoins();
    return allCoins;
  }

  Future<void> _showInsistentNotification() async {
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
        0, 'insistent title', 'insistent body', platformChannelSpecifics,
        payload: 'item x');
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
            0,
            'progress notification title',
            'progress notification body',
            platformChannelSpecifics,
            payload: 'item x');
      });
    }
  }
}
