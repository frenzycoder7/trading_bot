part of 'trade_item_cubit.dart';

class TradeItemState extends Equatable {
  const TradeItemState({
    this.marketPrice = 0.0,
    this.currentProfit = 0.0,
    this.currentROI = 0.0,
    this.coinNotFound = false,
    this.buyPrice = 0.0,
    this.isProfit = false,
    this.isHigh = false,
  });

  final double marketPrice;
  final double currentProfit;
  final double currentROI;
  final bool coinNotFound;
  final double buyPrice;
  final bool isProfit;
  final bool isHigh;

  @override
  List<Object> get props => [
        marketPrice,
        currentProfit,
        currentROI,
        coinNotFound,
        buyPrice,
        isProfit,
        isHigh,
      ];

  TradeItemState copyWith({
    double? marketPrice,
    double? currentProfit,
    double? currentROI,
    bool? coinNotFound,
    double? buyPrice,
    bool? isProfit,
    bool? isHigh,
  }) {
    return TradeItemState(
      marketPrice: marketPrice ?? this.marketPrice,
      currentProfit: currentProfit ?? this.currentProfit,
      currentROI: currentROI ?? this.currentROI,
      coinNotFound: coinNotFound ?? this.coinNotFound,
      buyPrice: buyPrice ?? this.buyPrice,
      isProfit: isProfit ?? this.isProfit,
      isHigh: isHigh ?? this.isHigh,
    );
  }
}
