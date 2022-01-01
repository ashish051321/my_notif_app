import 'package:flutter/material.dart';

import 'local_storage_service.dart';
import 'modelAndConstants.dart';

class SubscribedCoinsList extends StatefulWidget {
  bool isEditable;
  Key? _key;

  SubscribedCoinsList(this.isEditable, {Key? key}) : super(key: key);

  @override
  _SubscribedCoinsListState createState() => _SubscribedCoinsListState();
}

class _SubscribedCoinsListState extends State<SubscribedCoinsList>
    with SingleTickerProviderStateMixin {
  List<CryptoInfo> listOfSubscribedCoins = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    // Create anonymous function:
    () async {
      listOfSubscribedCoins = List.empty(growable: true);
      List<CryptoInfo> response = await getListOfSubscribedCoins();
      setState(() {
        listOfSubscribedCoins.addAll(response);
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
                trailing: !widget.isEditable
                    ? SizedBox()
                    : IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          print(
                              'you pressed  ${listOfSubscribedCoins[index]} close icon');
                          setState(() {
                            listOfSubscribedCoins.removeAt(index);
                            storeListOfSubscribedCoins(listOfSubscribedCoins);
                          });
                        },
                      ),
                title: Text(
                    "${listOfSubscribedCoins[index].name} : ${listOfSubscribedCoins[index].symbol}"));
          }),
    );
  }
}
