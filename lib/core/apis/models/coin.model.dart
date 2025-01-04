class Coin {
  String? _sId;
  String? _symbol;
  int? _leverage;
  double? _stopLossPercent;
  double? _takeProfitPercent;
  bool? _reorder;
  bool? _useStopLoss;
  double? _amount;
  double? _reorderPercent;
  double? _marketPrice;
  double? _marketPricePercent;
  double? _todayLow;
  double? _todayHigh;
  bool _isMarketPriceUp = false;
  int? _precision;
  String? _createdAt;
  bool? _reorderOnSell;
  int? _maxTrade;
  bool? _buyOnMarketAfterSell;

  String get sId => _sId ?? '';
  String get symbol => _symbol ?? '';
  int get leverage => _leverage ?? 0;
  double get stopLossPercent => _stopLossPercent ?? 0.0;
  double get takeProfitPercent => _takeProfitPercent ?? 0.0;
  bool get reorder => _reorder ?? false;
  bool get useStopLoss => _useStopLoss ?? false;
  double get amount => _amount ?? 0.0;
  double get reorderPercent => _reorderPercent ?? 0.0;
  double get marketPrice => _marketPrice ?? 0.0;
  double get marketPricePercent => _marketPricePercent ?? 0.0;
  bool get isMarketPriceUp => _isMarketPriceUp;
  double get todayLow => _todayLow ?? 0.0;
  double get todayHigh => _todayHigh ?? 0.0;
  int get precision => _precision ?? 0;
  int get maxTrade => _maxTrade ?? 0;
  bool get reorderOnSell => _reorderOnSell ?? false;
  bool get buyOnMarketAfterSell => _buyOnMarketAfterSell ?? false;

  setMaxTrade(int maxtrade) {
    _maxTrade = maxtrade;
  }

  setBuyOnMarketAfterSell(bool buyOnMarketAfterSell) {
    _buyOnMarketAfterSell = buyOnMarketAfterSell;
  }

  setMarketPrice(double marketPrice) {
    _marketPrice = marketPrice;
  }

  setMarketPricePercent(double marketPricePercent) {
    _marketPricePercent = marketPricePercent;
  }

  setTodayLow(double todayLow) {
    _todayLow = todayLow;
  }

  setTodayHigh(double todayHigh) {
    _todayHigh = todayHigh;
  }

  setIsMarketPriceUp(bool isMarketPriceUp) {
    _isMarketPriceUp = isMarketPriceUp;
  }

  setPrecision(int precision) {
    _precision = precision;
  }

  setLeverage(int leverage) {
    _leverage = leverage;
  }

  setTakeProfitPercent(double takeProfitPercent) {
    _takeProfitPercent = takeProfitPercent;
  }

  setReorder(bool reorder) {
    _reorder = reorder;
  }

  setReorderPercent(double reorderPercent) {
    _reorderPercent = reorderPercent;
  }

  setReorderOnSell(bool reorderOnSell) {
    _reorderOnSell = reorderOnSell;
  }

  setStopLossPercent(double stopLossPercent) {
    _stopLossPercent = stopLossPercent;
  }

  setUseStopLoss(bool useStopLoss) {
    _useStopLoss = useStopLoss;
  }

  setAmount(double amount) {
    _amount = amount;
  }

  setCreatedAt(String createdAt) {
    _createdAt = createdAt;
  }

  Coin.fromJson(Map<String, dynamic> json) {
    _sId = json['_id'];
    _symbol = json['symbol'];
    _leverage = json['leverage'];
    _stopLossPercent = parseDouble(json['stopLossPercent']);
    _takeProfitPercent = parseDouble(json['takeProfitPercent']);
    _reorder = json['reorder'];
    _useStopLoss = json['useStopLoss'];
    _amount = parseDouble(json['amount']);
    _reorderPercent = json['reorderPercent'].runtimeType == int
        ? json['reorderPercent'].toDouble()
        : json['reorderPercent'];
    _precision = json['precision'];
    _createdAt = json['createdAt'];
    _reorderOnSell = json['reorderOnSell'];
    _maxTrade = json['maxTrade'];
    _buyOnMarketAfterSell = json['buyOnMarketAfterSell'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = _sId;
    data['symbol'] = _symbol;
    data['leverage'] = _leverage;
    data['stopLossPercent'] = _stopLossPercent;
    data['takeProfitPercent'] = _takeProfitPercent;
    data['reorder'] = _reorder;
    data['useStopLoss'] = _useStopLoss;
    data['amount'] = _amount;
    data['reorderPercent'] = _reorderPercent;
    data['precision'] = _precision;
    data['createdAt'] = _createdAt;
    data['reorderOnSell'] = _reorderOnSell;
    return data;
  }

  double parseDouble(dynamic value) {
    if (value == null) return 0.0;
    return value is String
        ? double.parse(value)
        : value is int
            ? value.toDouble()
            : value;
  }
}
