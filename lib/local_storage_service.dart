import 'dart:convert';

import 'package:my_notif_app/modelAndConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_notif_app/main.dart';

import 'crypto_backend.dart';

String COINMARKETCAP_API_KEY_LABEL = 'COINMARKETCAP_API_KEY';

bool checkForCryptoAPIKeyInLocalStorage(SharedPreferences sharedPrefs) {
  // final sharedPrefs = SharedPrefs._sharedPrefs;
  if (sharedPrefs.getString(COINMARKETCAP_API_KEY_LABEL) != null) {
    return true;
  }
  return false;
}

Future<List<CryptoInfo>> fetchAndSaveCryptoCoinsList() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? coinInfoListRawString = prefs.getString(Constants.COIN_INFO_LIST);
  if (coinInfoListRawString == null) {
    //if the map is not present we will fetch it from the backend
    List<CryptoInfo> cryptoInfoList = await fetchAllCoins();
    await prefs.setString(
        Constants.COIN_INFO_LIST, json.encode(cryptoInfoList));
    return cryptoInfoList;
  }
  List<dynamic> listOfCoins = json.decode(coinInfoListRawString);
  List<CryptoInfo> cryptoInfoList =
      listOfCoins.map((e) => CryptoInfo.fromJson(e)).toList();
  return cryptoInfoList;
}

Future<void> storeCryptoKey(
    SharedPreferences sharedPrefs, String cryptoKey) async {
  await sharedPrefs.setString(COINMARKETCAP_API_KEY_LABEL, cryptoKey);
}

Future<void> storeListOfSubscribedCoins(List<CryptoInfo> listOfSubscribedCoins) async {
  SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
  String? storedCoinList = sharedPrefs.getString(Constants.SUBSCRIBED_COINS_LIST);
  await sharedPrefs.setString(Constants.SUBSCRIBED_COINS_LIST, json.encode(listOfSubscribedCoins));
}

Future<List<CryptoInfo>> getListOfSubscribedCoins() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? coinInfoListRawString = prefs.getString(Constants.SUBSCRIBED_COINS_LIST);
  if(coinInfoListRawString == null){
    return Future.value(List.empty());
  }
  List<dynamic> listOfCoins = json.decode(coinInfoListRawString);
  List<CryptoInfo> cryptoInfoList =
  listOfCoins.map((e) => CryptoInfo.fromJson(e)).toList();
  return cryptoInfoList;
}

// utils/shared_prefs.dart
Future<SharedPreferences> initSharedPreferences() async {
  SharedPreferences _sharedPrefs = await SharedPreferences.getInstance();
  return _sharedPrefs;
}
