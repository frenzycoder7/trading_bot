import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:trading_bot/core/apis/models/coin.model.dart';
import 'package:trading_bot/core/extensions/double.extension.dart';
import 'package:trading_bot/core/services/Storage.service.dart';
import 'package:trading_bot/core/services/models/stream_data.model.dart';
import 'package:trading_bot/core/services/websocket.service.dart';
import 'package:trading_bot/modules/trades/models/trade.model.dart';

part 'trade_item_state.dart';

class TradeItemCubit extends Cubit<TradeItemState> {
  TradeItemCubit(this.trade)
      : super(
          const TradeItemState(
            marketPrice: 0.0,
            currentProfit: 0.0,
            currentROI: 0.0,
            coinNotFound: false,
          ),
        );
  Trade trade;
  StreamSubscription<List<StreamTicker>>? _subscription;

  listenMarketPrice() {
    Coin? coin = Storage.shared.fetchCoin(trade.symbol);
    if (coin == null) {
      emit(state.copyWith(coinNotFound: true));
      return;
    }

    if (trade.isClosed()) {
      emitDataForClosedTrade(coin);
      return;
    }

    _subscription =
        WebSocketService.shared.getMarketDataOfSymbol(coin.symbol, (p0) {
      double current = p0.c.toPrecision(coin.precision);
      double currentProfit = trade.calcuatedCurrentProfit(current);
      double currentROI = trade.calculateROIonMarketPrice(current);
      emit(state.copyWith(
        marketPrice: current,
        currentProfit: currentProfit.toPrecision(2),
        currentROI: currentROI.toPrecision(2),
        coinNotFound: false,
        isProfit: currentProfit > 0,
        isHigh: p0.c > p0.o,
      ));
    });
    debugPrint("subscribed to ${coin.symbol}");
  }

  emitDataForClosedTrade(Coin coin) {
    debugPrint("emitting data for closed trade");
    emit(state.copyWith(
      marketPrice: trade.sellPrice.toPrecision(coin.precision),
      currentProfit: trade.profit.toPrecision(2),
      currentROI: trade.calculatedROI().toPrecision(2),
      coinNotFound: false,
      buyPrice: trade.buyPrice.toPrecision(coin.precision),
      isProfit: trade.profit > 0,
    ));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    debugPrint("unsubscribed from ${trade.symbol}");
    return super.close();
  }
}
