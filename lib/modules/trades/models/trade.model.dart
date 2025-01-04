class Trade {
  String? _sId;
  double? _amount;
  double? _buyPrice;
  double? _sellPrice;
  String? _symbol;
  String? _status;
  String? _createdAt;
  String? _updatedAt;
  double? _profit;
  int? _leverage;
  double? _marketSellPrice;
  int? _tradeCount;
  double? _fee;
  double? _roi;
  double? _margin;
  double? _size;
  double? _binanceProfit;

  String get sId => _sId ?? '';
  double get amount => _amount ?? 0.0;
  double get buyPrice => _buyPrice ?? 0.0;
  double get sellPrice => _sellPrice ?? 0.0;
  String get symbol => _symbol ?? '';
  String get status => _status ?? '';
  String get createdAt => _createdAt ?? '';
  String get updatedAt => _updatedAt ?? '';
  double get profit => _profit ?? 0.0;
  int get leverage => _leverage ?? 0;
  double get marketSellPrice => _marketSellPrice ?? 0.0;
  int get tradeCount => _tradeCount ?? 0;
  double get fee => _fee ?? 0.0;
  double get roi => _roi ?? 0.0;
  double get margin => _margin ?? 0.0;
  double get size => _size ?? 0.0;
  double get binanceProfit => _binanceProfit ?? 0.0;

  bool isClosed() => status == 'CLOSED';
  bool isOpen() => status == 'OPEN';
  bool isProfit() => profit > 0;
  double calculatedROI() {
    return ((profit / calculatedMargin()) * 100).toDouble();
  }

  double calculatedMargin() {
    return (amount * buyPrice) / leverage;
  }

  bool isBinanceProfit() {
    return binanceProfit > 0;
  }

  double calculateROIonMarketPrice(double marketPrice) {
    return ((calcuatedCurrentProfit(marketPrice) / calculatedMargin()) * 100)
        .toDouble();
  }

  double calcuatedCurrentProfit(double marketPrice) {
    return (marketPrice - buyPrice) * amount;
  }

  Trade.fromJson(Map<String, dynamic> json) {
    _sId = json['_id'];
    _amount = parseDouble(json['amount']);
    _buyPrice = parseDouble(json['entryPrice']);
    _sellPrice = parseDouble(json['exitPrice']);
    _symbol = json['symbol'];
    _status = json['status'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _profit = parseDouble(json['profit']);
    _leverage = json['leverage'];
    _marketSellPrice = parseDouble(json['exitPrice']);
    _tradeCount = json['tradeCount'];
    _fee = parseDouble(json['fee']);
    _roi = parseDouble(json['ROE']);
    _margin = parseDouble(json['margin']);
    _size = parseDouble(json['size']);
    _binanceProfit = parseDouble(json['binanceProfit']);
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

class TradeResponse {
  List<Trade> trades;
  int total;

  TradeResponse({
    required this.trades,
    required this.total,
  });
}
