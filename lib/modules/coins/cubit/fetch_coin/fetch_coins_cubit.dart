import 'package:bloc/bloc.dart';
import 'package:trading_bot/core/apis/index.dart';
import 'package:trading_bot/core/apis/models/coin.model.dart';
import 'package:trading_bot/core/enums/enums.dart';
import 'package:trading_bot/core/services/Storage.service.dart';

part 'fetch_coins_state.dart';

// FetchCoinsCubit is used to fetch the coins from the server or from the local storage
class FetchCoinsCubit extends Cubit<FetchCoinsState> {
  FetchCoinsCubit() : super(FetchCoinsState());

  Future<void> fetchCoins() async {
    emit(state.copyWith(status: PageStatus.loading));
    try {
      // a flag to check if the coins should be refetched from the server
      bool shouldRefetchCoins = Storage.shared.shouldRefetchCoins;
      // fetch the coins from the server or from the local storage
      final coins = shouldRefetchCoins
          ? await API.shared.fetchCoins()
          : Storage.shared.fetchCoins();

      // set the coins to the local storage
      Storage.shared.setCoins(coins);
      // set the flag to false
      Storage.shared.setFetchedCoins();
      // emit the coins to the UI
      emit(state.copyWith(status: PageStatus.success, coins: coins));
    } catch (e) {
      // emit the error to the UI
      emit(state.copyWith(
        status: PageStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
