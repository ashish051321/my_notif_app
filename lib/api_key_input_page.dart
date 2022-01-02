import 'package:flutter/material.dart';
import 'package:my_notif_app/homePage.dart';
import 'package:my_notif_app/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiKeyInputPage extends StatelessWidget {
  TextEditingController cryptoKeyFieldController = TextEditingController();
  SharedPreferences sharedPrefs;

  ApiKeyInputPage(this.sharedPrefs, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setup Crypto API Key'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: cryptoKeyFieldController,
                decoration: InputDecoration(
                    hintText:
                        'Enter Crypto API Key from https://pro.coinmarketcap.com',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.blue),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.red),
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80.0),
              child: ElevatedButton.icon(
                  onPressed: () {
                    storeCryptoKey(sharedPrefs, cryptoKeyFieldController.text)
                        .then((value) => {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => HomePage()))
                            });
                  },
                  icon: Icon(Icons.save),
                  label: Text('Save')),
            ),
          ],
        ),
      ),
    );
  }
}
