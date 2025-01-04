import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trading_bot/core/apis/index.dart';
import 'package:trading_bot/core/apis/models/coin.model.dart';
import 'package:trading_bot/core/services/Storage.service.dart';

part 'create_coin_state.dart';

class CreateCoinCubit extends Cubit<CreateCoinState> {
  final Coin? coinToEdit;
  bool get isEditing => coinToEdit != null;
  CreateCoinCubit({this.coinToEdit})
      : super(
          CreateCoinState(
            leverage: coinToEdit?.leverage.toDouble() ?? 1.0,
            precision: coinToEdit?.precision.toDouble() ?? 2.0,
            sellPercentage: coinToEdit?.takeProfitPercent.toDouble() ?? 1.0,
            reorderOnBuy: coinToEdit?.reorder ?? false,
            buyPercentage: coinToEdit?.reorderPercent.toDouble() ?? 1.0,
            reorderOnSell: coinToEdit?.reorderOnSell ?? false,
            buyOnMarketAfterSell: coinToEdit?.buyOnMarketAfterSell ?? false,
            maxTrade: coinToEdit?.maxTrade.toDouble() ?? 1.0,
          ),
        );

  void setLeverage(double value) => emit(state.copyWith(leverage: value));
  void setPrecision(double value) => emit(state.copyWith(precision: value));
  void setSellPercentage(double value) =>
      emit(state.copyWith(sellPercentage: value));
  void setReorderOnBuy(bool value) => emit(state.copyWith(reorderOnBuy: value));
  void setBuyPercentage(double value) =>
      emit(state.copyWith(buyPercentage: value));
  void setReorderOnSell(bool value) =>
      emit(state.copyWith(reorderOnSell: value));
  void setBuyOnMarketAfterSell(bool value) =>
      emit(state.copyWith(buyOnMarketAfterSell: value));
  void setMaxTrade(double value) => emit(state.copyWith(maxTrade: value));

  Future<void> submitForm({
    required String symbol,
    required String amount,
  }) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final Map<String, String> body = {
        'symbol': symbol,
        'amount': amount,
        'leverage': state.leverage.toString(),
        'precision': state.precision.toString(),
        'takeProfitPercent': state.sellPercentage.toString(),
        'reorder': state.reorderOnBuy.toString(),
        'reorderPercent': state.buyPercentage.toString(),
        'reorderOnSell': state.reorderOnSell.toString(),
        'buyOnMarketAfterSell': state.buyOnMarketAfterSell.toString(),
        'maxTrade': state.maxTrade.toString(),
      };
      if (isEditing) {
        body.remove("symbol");
      }
      isEditing
          ? await API.shared.updateCoin(body, symbol)
          : await API.shared.createCoin(body);
      !isEditing
          ? Storage.shared.setRefetchCoins()
          : setUpdatedValues(coinToEdit!, double.parse(amount));
      emit(state.copyWith(isLoading: false, isSuccess: true, error: null));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to add coin: ${e.toString()}',
      ));
    }
  }

  setUpdatedValues(Coin coin, double amount) {
    coin.setBuyOnMarketAfterSell(state.buyOnMarketAfterSell);
    coin.setMaxTrade(state.maxTrade.toInt());
    coin.setPrecision(state.precision.toInt());
    coin.setLeverage(state.leverage.toInt());
    coin.setTakeProfitPercent(state.sellPercentage);
    coin.setReorder(state.reorderOnBuy);
    coin.setReorderPercent(state.buyPercentage);
    coin.setReorderOnSell(state.reorderOnSell);
    coin.setAmount(amount);
    Storage.shared.updateCoin(coin);
  }
}
