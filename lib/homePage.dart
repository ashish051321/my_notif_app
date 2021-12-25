import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cryptoSearchAndNotificationSettings.dart';
import 'crypto_backend.dart';

// Displays the coins that are marked for Notification
// Will later give options to edit the API Keys and the notification frequency
class HomePage extends StatelessWidget {
  bool isLoading = false;

  HomePage({Key? key}) : super(key: key);

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
                    SubscribedCoinsList(),
                    ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  CryptoSearchAndNotificationSettings()));
                        },
                        icon: Icon(Icons.edit),
                        label: Text('Edit')),
                  ],
                ),
              ),
            ),
    );
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
      // height: 400,

      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: listOfSubscribedCoins.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(title: Text("${listOfSubscribedCoins[index]}"));
          }),
    );
  }
}
