class CryptoInfo {
  String name, symbol;
  String currency = 'INR';

  CryptoInfo(this.name, this.symbol, this.currency);

  static CryptoInfo fromJson(Map<String, dynamic> json) {
    String name = json['name'];
    String symbol = json['symbol'];
    String currency = json['currency'] ?? 'INR' ;
    return CryptoInfo(name, symbol, currency);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'symbol': symbol,
      'currency':currency
    };
  }
}

class Constants {
  static String COIN_INFO_LIST = "COIN_INFO_LIST";
  static String SUBSCRIBED_COINS_LIST = "SUBSCRIBED_COINS_LIST";
}
