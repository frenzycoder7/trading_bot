import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trading_bot/core/apis/index.dart';
import 'package:trading_bot/modules/trades/enums/trade_status.enums.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:trading_bot/modules/trades/models/trade.model.dart';

part 'fetch_trades_state.dart';

class FetchTradesCubit extends Cubit<FetchTradesState> {
  PagingController<int, Trade> pagingController =
      PagingController(firstPageKey: 0);

  FetchTradesCubit() : super(const FetchTradesState()) {
    pagingController.addPageRequestListener(fetchTrades);
  }

  void fetchTrades(int pageKey) async {
    Map<String, dynamic> query = {
      "status": state.status.name,
      "limit": state.limit,
      "skip": pageKey,
    };

    if (state.symbols.isNotEmpty) {
      query["symbol"] = state.symbols.length > 1
          ? state.symbols.join(",")
          : state.symbols.first;
    }

    try {
      TradeResponse response = await API.shared.fetchTrades(query);
      emit(state.copyWith(total: response.total));
      if (response.trades.isEmpty || response.trades.length < state.limit) {
        pagingController.appendLastPage(response.trades);
      } else {
        pagingController.appendPage(response.trades, pageKey + 1);
      }
    } catch (e) {
      print(e);
      pagingController.error = e;
    }
  }

  setLimit(int limit) {
    emit(state.copyWith(limit: limit));
    pagingController.refresh();
  }

  setStatus(TradeStatus status) {
    emit(state.copyWith(status: status));
    pagingController.refresh();
  }

  setSymbols(List<String> symbols) {
    emit(state.copyWith(symbols: symbols));
    pagingController.refresh();
  }

  addSymbol(String symbol) {
    List<String> symbols = [...state.symbols];
    symbols.add(symbol);
    emit(state.copyWith(symbols: symbols));
    pagingController.refresh();
  }

  removeSymbol(String symbol) {
    List<String> symbols = [...state.symbols];
    symbols.remove(symbol);
    emit(state.copyWith(symbols: symbols));
    pagingController.refresh();
  }
}
