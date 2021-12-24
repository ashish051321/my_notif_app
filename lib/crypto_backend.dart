import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/http.dart';

// import 'package:http/http.dart';

// void main() {
//   print('Program started');
//   print(fetchAllCoins());
//   print('Program finished');
// }

Future<dynamic> fetchAllCoins() async {
  var url = Uri.parse('https://parseapi.back4app.com/functions/getAllCoins');
  Response response = await http.post(url, headers: {
    'X-Parse-Application-Id': 'yKujveqA2lJWMJ0mJhWGYudoMncTnfE7a5HKoaNZ',
    'X-Parse-REST-API-Key': 'IMAEUdc6b4zfa4iVHMKvzzG5XjouNqtnLf4cqynn'
  });
  dynamic allCoinsArray = jsonDecode(response.body);

  // print('Response status: ${response.statusCode}');
  // print('Response body: ${response.body}');
  return allCoinsArray;
  // Imagine that this function is fetching user info from another service or database.
//   return Future.delayed(const Duration(seconds: 2), () => print('Large Latte'));
}

Future<void> fetchStockDetails() async {
  var url = Uri.parse(
      'https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest?symbol=ONE&convert=INR');
  var response = await http.get(url,
      headers: {'X-CMC_PRO_API_KEY': '10354938-549d-4817-ada2-be06ea1524c8'});
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  // Imagine that this function is fetching user info from another service or database.
  return Future.delayed(const Duration(seconds: 2), () => print('Large Latte'));
}

Future<void> fetchStockDetails2() async {
  var url = Uri.parse('https://parseapi.back4app.com/functions/getCoinInfo');
  var response = await http.post(url, body: {
    'coin': 'ADA'
  }, headers: {
    'X-Parse-Application-Id': 'yKujveqA2lJWMJ0mJhWGYudoMncTnfE7a5HKoaNZ',
    'X-Parse-REST-API-Key': 'IMAEUdc6b4zfa4iVHMKvzzG5XjouNqtnLf4cqynn'
  });
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  // Imagine that this function is fetching user info from another service or database.
  return Future.delayed(const Duration(seconds: 2), () => print('Large Latte'));
}
