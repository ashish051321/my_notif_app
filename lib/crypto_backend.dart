import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/http.dart';

import 'modelAndConstants.dart';

// import 'package:http/http.dart';

void main() {
  print('Program started');
  print(fetchCoinDetails("ONE,ETH,BTC"));
  print('Program finished');
}

Future<List<CryptoInfo>> fetchAllCoins() async {
  var url = Uri.parse('https://parseapi.back4app.com/functions/getAllCoins');
  Response response = await http.post(url, headers: {
    'X-Parse-Application-Id': 'yKujveqA2lJWMJ0mJhWGYudoMncTnfE7a5HKoaNZ',
    'X-Parse-REST-API-Key': 'IMAEUdc6b4zfa4iVHMKvzzG5XjouNqtnLf4cqynn'
  });
  dynamic allCoinsMap = jsonDecode(response.body);
  List<dynamic> coinList = allCoinsMap?['result'];
  List<CryptoInfo> cryptoInfoList =
      coinList.map((e) => CryptoInfo.fromJson(e)).toList();
  // print('Response status: ${response.statusCode}');
  // print('Response body: ${response.body}');
  return cryptoInfoList;
  // Imagine that this function is fetching user info from another service or database.
//   return Future.delayed(const Duration(seconds: 2), () => print('Large Latte'));
}

Future<List<CryptoInfo>> fetchCoinDetails(String coinSymbols) async {
  try {
    var url = Uri.parse('https://parseapi.back4app.com/functions/getCoinInfo');
    print('coinSymbols : ${coinSymbols}');
    var response = await http.post(url, body: {
      'coins': coinSymbols,
      'currency': 'INR'
    }, headers: {
      'X-Parse-Application-Id': 'yKujveqA2lJWMJ0mJhWGYudoMncTnfE7a5HKoaNZ',
      'X-Parse-REST-API-Key': 'IMAEUdc6b4zfa4iVHMKvzzG5XjouNqtnLf4cqynn'
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    dynamic allCoinsMap = jsonDecode(response.body);
    List<dynamic> coinList = allCoinsMap?['result'];
    List<CryptoInfo> coinInfoList =
        coinList.map((e) => CryptoInfo.fromJson(e)).toList();

    // Imagine that this function is fetching user info from another service or database.
    return coinInfoList;
  } catch (e) {
    return Future.value(List.empty());
  }
}
