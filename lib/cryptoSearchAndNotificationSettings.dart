import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:autocomplete_textfield/autocomplete_textfield.dart';

import 'crypto_backend.dart';
// import 'local_storage_service.dart';

class CryptoSearchAndNotificationSettings extends StatefulWidget {
  const CryptoSearchAndNotificationSettings({Key? key}) : super(key: key);

  @override
  _CryptoSearchAndNotificationSettingsState createState() =>
      _CryptoSearchAndNotificationSettingsState();
}

class CryptoInfo {
  String name, symbol;

  CryptoInfo(this.name, this.symbol);
}

class _CryptoSearchAndNotificationSettingsState
    extends State<CryptoSearchAndNotificationSettings> {
  final GlobalKey<_SubscribedCoinsListState> _cryptoListingWidgetKey =
      GlobalKey<_SubscribedCoinsListState>();
  bool isLoading = false;
  List<CryptoInfo> data = [
    CryptoInfo("Harmony", "ONE"),
    CryptoInfo("Cardano", "ADA"),
    CryptoInfo("Bitcoin", "BTC"),
    CryptoInfo("Pancake Swap", "CAKE"),
    CryptoInfo("Etherium", "ETH")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Notification for Crypto Coins'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Autocomplete(
                    optionsBuilder: (TextEditingValue searchStringVal) {
                      if (searchStringVal.text.isEmpty) {
                        return const Iterable<String>.empty();
                      } else {
                        return data
                            .where((CryptoInfo item) => item.name
                                .toLowerCase()
                                .contains(searchStringVal.text.toLowerCase()))
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
                              borderSide: BorderSide(color: Colors.grey[300]!)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!)),
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
                ],
              ),
            ),
    );
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
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: listOfSubscribedCoins.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
              trailing: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  print('you pressed  ${listOfSubscribedCoins[index]} close icon');
                  setState(() {
                    listOfSubscribedCoins.removeAt(index);
                  });
                },
              ),
              title: Text("${listOfSubscribedCoins[index]}"));
        });
    // return ListView(
    //     shrinkWrap: true,
    //     padding: EdgeInsets.all(8),
    //     // ignore: prefer_const_literals_to_create_immutables
    //     children:
    // );
  }
}
