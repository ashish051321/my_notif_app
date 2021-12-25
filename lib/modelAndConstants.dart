class CryptoInfo {
  String name, symbol;

  CryptoInfo(this.name, this.symbol);

  static CryptoInfo fromJson(Map<String, dynamic> json) {
    String name = json['name'];
    String symbol = json['symbol'];
    return CryptoInfo(name, symbol);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'symbol': symbol,
    };
  }
}

class Constants {
  static String COIN_INFO_LIST = "COIN_INFO_LIST";
}
