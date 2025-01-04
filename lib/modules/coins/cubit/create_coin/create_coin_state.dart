part of 'create_coin_cubit.dart';

class CreateCoinState extends Equatable {
  final double leverage;
  final double precision;
  final double sellPercentage;
  final bool reorderOnBuy;
  final double buyPercentage;
  final bool reorderOnSell;
  final bool buyOnMarketAfterSell;
  final double maxTrade;
  final bool isLoading;
  final bool isSuccess;
  final String? error;

  const CreateCoinState({
    this.leverage = 1.0,
    this.precision = 2.0,
    this.sellPercentage = 1.0,
    this.reorderOnBuy = false,
    this.buyPercentage = 1.0,
    this.reorderOnSell = false,
    this.buyOnMarketAfterSell = false,
    this.maxTrade = 1.0,
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
  });

  CreateCoinState copyWith({
    double? leverage,
    double? precision,
    double? sellPercentage,
    bool? reorderOnBuy,
    double? buyPercentage,
    bool? reorderOnSell,
    bool? buyOnMarketAfterSell,
    double? maxTrade,
    bool? isLoading,
    bool? isSuccess,
    String? error,
  }) {
    return CreateCoinState(
      leverage: leverage ?? this.leverage,
      precision: precision ?? this.precision,
      sellPercentage: sellPercentage ?? this.sellPercentage,
      reorderOnBuy: reorderOnBuy ?? this.reorderOnBuy,
      buyPercentage: buyPercentage ?? this.buyPercentage,
      reorderOnSell: reorderOnSell ?? this.reorderOnSell,
      buyOnMarketAfterSell: buyOnMarketAfterSell ?? this.buyOnMarketAfterSell,
      maxTrade: maxTrade ?? this.maxTrade,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        leverage,
        precision,
        sellPercentage,
        reorderOnBuy,
        buyPercentage,
        reorderOnSell,
        buyOnMarketAfterSell,
        maxTrade,
        isLoading,
        isSuccess,
        error,
      ];
}
