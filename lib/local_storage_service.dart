import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_notif_app/main.dart';

String COINMARKETCAP_API_KEY_LABEL = 'COINMARKETCAP_API_KEY';

bool checkForCryptoAPIKeyInLocalStorage(SharedPreferences sharedPrefs) {
  // final sharedPrefs = SharedPrefs._sharedPrefs;
  if (sharedPrefs.getString(COINMARKETCAP_API_KEY_LABEL) != null) {
    return true;
  }
  return false;
}

Future<void> storeCryptoKey(SharedPreferences sharedPrefs, String cryptoKey) async {
  await sharedPrefs.setString(COINMARKETCAP_API_KEY_LABEL, cryptoKey);
}

// utils/shared_prefs.dart
Future<SharedPreferences> initSharedPreferences() async {
  SharedPreferences _sharedPrefs = await SharedPreferences.getInstance();
  return _sharedPrefs;
}
