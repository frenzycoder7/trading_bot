class ProfitSummary {
  double? _totalProfit;
  int? _totalTrades;
  double? _todayProfit;
  int? _todayTrades;
  double? _lastWeekProfit;
  int? _lastWeekTrades;
  double? _lastMonthProfit;
  int? _lastMonthTrades;

  double get totalProfit => _totalProfit ?? 0.0;
  int get totalTrades => _totalTrades ?? 0;
  double get todayProfit => _todayProfit ?? 0.0;
  int get todayTrades => _todayTrades ?? 0;
  double get lastWeekProfit => _lastWeekProfit ?? 0.0;
  int get lastWeekTrades => _lastWeekTrades ?? 0;
  double get lastMonthProfit => _lastMonthProfit ?? 0.0;
  int get lastMonthTrades => _lastMonthTrades ?? 0;

  ProfitSummary.fromJson(Map<String, dynamic> json) {
    _totalProfit = parseDouble(json['total']['profit']);
    _totalTrades = json['total']['tc'];
    _todayProfit = parseDouble(json['today']['profit']);
    _todayTrades = json['today']['tc'];
    _lastWeekProfit = parseDouble(json['week']['profit']);
    _lastWeekTrades = json['week']['tc'];
    _lastMonthProfit = parseDouble(json['month']['profit']);
    _lastMonthTrades = json['month']['tc'];
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
