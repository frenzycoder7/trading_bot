class ApiEndPoints {
  final String baseURL = "";
  final String websocketURL =
      "wss://stream.binance.com:9443/ws/!miniTicker@arr";
  String get fetchCoins => "";
  String get fetchProfit => "";
  String get createCoin => "";
  String get updateCoin => ""; // add coin after coin i.e. /coin/BTCUSDT
  String get deleteCoin => "";
  String get fetchTrades => ""; // limit , page and status
  String get fetchProfitSummary => "";
  String get fetch7DaysProfit => "";
}
