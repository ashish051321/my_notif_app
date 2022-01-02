class CryptoInfo {
  String name, symbol;
  String currency = 'INR';
  double price;

  CryptoInfo(this.name, this.symbol, this.currency, this.price);

  static CryptoInfo fromJson(Map<String, dynamic> json) {
    String name = json['name'];
    String symbol = json['symbol'];
    String currency = json['currency'] ?? 'INR';
    double price = json['price'] ?? 0;
    return CryptoInfo(name, symbol, currency, price);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'symbol': symbol,
      'currency': currency,
      'price': price
    };
  }
}

class Constants {
  static const String COIN_INFO_LIST = "COIN_INFO_LIST";
  static const String SUBSCRIBED_COINS_LIST = "SUBSCRIBED_COINS_LIST";
  static const String NOTIFICATION_BKG_TASK = "NOTIFICATION_BKG_TASK";
  static const String NOTIFICATION_BKG_TASK_TAG = "NOTIFICATION_BKG_TASK_TAG" ;
}
