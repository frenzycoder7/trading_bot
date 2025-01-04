import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:trading_bot/core/apis/index.dart';
import 'package:trading_bot/core/apis/models/coin.model.dart';
import 'package:trading_bot/core/extensions/double.extension.dart';
import 'package:trading_bot/core/services/Storage.service.dart';
import 'package:trading_bot/core/services/models/stream_data.model.dart';
import 'package:trading_bot/core/services/websocket.service.dart';

part 'coin_item_state.dart';

class CoinItemCubit extends Cubit<CoinItemState> {
  Coin coin;
  CoinItemCubit(this.coin)
      : super(
          CoinItemState(
            coin: coin,
            isMarketHigh: false,
            marketPrice: 0.0,
            marketHigh: 0.0,
            marketLow: 0.0,
            percentageChange: 0.0,
          ),
        );

  StreamSubscription<List<StreamTicker>>? _subscription;

  listenMarket() {
    _subscription =
        WebSocketService.shared.getMarketDataOfSymbol(coin.symbol, (p0) {
      double current = p0.c.toPrecision(coin.precision);
      double high = p0.h.toPrecision(coin.precision);
      double low = p0.l.toPrecision(coin.precision);
      bool isMarketHigh = p0.c > p0.o;
      double old = p0.o.toPrecision(coin.precision);
      double percentageChange = ((current - old) / old) * 100;

      emit(
        state.copyWith(
          isMarketHigh: isMarketHigh,
          marketPrice: current,
          marketHigh: high,
          marketLow: low,
          percentageChange: percentageChange.toPrecision(coin.precision),
        ),
      );
    });

    debugPrint("CoinItemCubit opened");
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    debugPrint("CoinItemCubit closed");
    return super.close();
  }

  Future<bool> deleteCoin() async {
    try {
      await API.shared.deleteCoin(coin.symbol);
      Storage.shared.removeCoin(coin);
      return true;
    } catch (e) {
      debugPrint("Error deleting coin: $e");
      rethrow;
    }
  }
}
