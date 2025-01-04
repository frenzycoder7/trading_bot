part of 'coin_item_cubit.dart';

class CoinItemState {
  Coin coin;
  bool isMarketHigh;
  double marketPrice = 0.0;
  double marketHigh = 0.0;
  double marketLow = 0.0;
  double percentageChange = 0.0;

  CoinItemState({
    required this.coin,
    required this.isMarketHigh,
    required this.marketPrice,
    required this.marketHigh,
    required this.marketLow,
    required this.percentageChange,
  });

  CoinItemState copyWith({
    bool? isMarketHigh,
    double? marketPrice,
    double? marketHigh,
    double? marketLow,
    double? percentageChange,
  }) {
    return CoinItemState(
      coin: coin,
      isMarketHigh: isMarketHigh ?? this.isMarketHigh,
      marketPrice: marketPrice ?? this.marketPrice,
      marketHigh: marketHigh ?? this.marketHigh,
      marketLow: marketLow ?? this.marketLow,
      percentageChange: percentageChange ?? this.percentageChange,
    );
  }
}
