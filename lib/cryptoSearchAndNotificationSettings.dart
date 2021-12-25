import 'package:flutter/material.dart';
import 'package:my_notif_app/homePage.dart';
import 'package:my_notif_app/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final GlobalKey<_SubscribedCoinsListState> _cryptoListingWidgetKey =
      GlobalKey<_SubscribedCoinsListState>();
  bool isLoading = false;
  late List<CryptoInfo> cryptoInfoList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    () async {
      List<CryptoInfo> response = await fetchAndSaveCryptoCoinsList();
      setState(() async {
        cryptoInfoList = response;
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                      searchStringVal.text.toLowerCase()) ||
                                  item.symbol.toLowerCase().contains(
                                      searchStringVal.text.toLowerCase()))
                              .map((e) => '${e.name} -- ${e.symbol}');
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
                        print('----');
                        print(option);
                        _cryptoListingWidgetKey.currentState?.setState(() {
                          _cryptoListingWidgetKey
                              .currentState?.listOfSubscribedCoins
                              .add(option.toString());
                        });
                      },
                    ),
                    SubscribedCoinsList(key: _cryptoListingWidgetKey),
                    ElevatedButton.icon(
                        onPressed: () {
                          storeCryptoList(_cryptoListingWidgetKey
                                  .currentState?.listOfSubscribedCoins)
                              .then((value) => {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()))
                                  });
                        },
                        icon: Icon(Icons.save),
                        label: Text('Done')),
                  ],
                ),
              ),
            ),
    );
  }

  storeCryptoList(listOfCoins) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("CryptoList", listOfCoins);
  }

  getAllCoinInfo() async {
    dynamic allCoins = await fetchAllCoins();
    return allCoins;
  }
}

class SubscribedCoinsList extends StatefulWidget {
  const SubscribedCoinsList({Key? key}) : super(key: key);

  @override
  _SubscribedCoinsListState createState() => _SubscribedCoinsListState();
}

class _SubscribedCoinsListState extends State<SubscribedCoinsList> {
  List<String> listOfSubscribedCoins = [];

  @override
  void initState() {
    super.initState();

    // Create anonymous function:
    () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? stringList;
      if (prefs.getStringList("CryptoList") == null) {
        stringList = [];
      } else {
        stringList = prefs.getStringList("CryptoList");
      }

      setState(() {
        listOfSubscribedCoins = stringList!;
        // Update your UI with the desired changes.
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: listOfSubscribedCoins.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                trailing: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    print(
                        'you pressed  ${listOfSubscribedCoins[index]} close icon');
                    setState(() {
                      listOfSubscribedCoins.removeAt(index);
                    });
                  },
                ),
                title: Text("${listOfSubscribedCoins[index]}"));
          }),
    );
  }
}
